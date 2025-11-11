import logging
import json
from datetime import date, datetime, timedelta
from typing import List, Dict, Optional
from pathlib import Path

from src.db_manager import DatabaseManager
from src.sql_loader import SQLLoader
from config.database import CUTOFF_DATE, TIMEZONE, ETL_MODE

logger = logging.getLogger(__name__)

class MetricRunner:
    """Execute metric calculations with configuration-based filtering"""
    
    def __init__(self, db_manager: DatabaseManager, sql_loader: SQLLoader, mode: str = None):
        self.db = db_manager
        self.sql = sql_loader
        self.mode = mode or ETL_MODE
        self.config_file = Path("config/metrics_registry.json")
        
        # Load metrics configuration
        self.metrics_config = self._load_config()
        
        # Automatically discover metrics based on mode and config
        self.metric_order = self._discover_metrics()
        logger.info(f"Mode: {self.mode.upper()} | Discovered {len(self.metric_order)} metrics to run")
        if self.metric_order:
            logger.info(f"Metrics: {', '.join([m['name'] for m in self.metric_order])}")
    
    def _load_config(self) -> dict:
        """Load metrics configuration from JSON file"""
        if self.config_file.exists():
            with open(self.config_file, 'r') as f:
                return json.load(f)
        else:
            logger.warning(f"Config file not found: {self.config_file}")
            return {"metrics": {}, "last_updated": None}
    
    def _save_config(self):
        """Save metrics configuration to JSON file"""
        self.metrics_config["last_updated"] = datetime.now().isoformat()
        with open(self.config_file, 'w') as f:
            json.dump(self.metrics_config, f, indent=2)
        logger.info(f"Configuration saved to {self.config_file}")
    
    def _discover_metrics(self) -> List[Dict]:
        """
        Discover metric SQL files based on mode and configuration.
        Returns list of dicts with metric info and files to run.
        """
        metrics_to_run = []
        
        for metric_name, config in self.metrics_config.get("metrics", {}).items():
            # Skip disabled metrics
            if not config.get("enabled", True):
                logger.debug(f"Skipping disabled metric: {metric_name}")
                continue
            
            # Check if metric should run based on mode and initialization status
            is_initialized = config.get("initialized", False)
            
            if self.mode == 'initial':
                # In initial mode, only run uninitialized metrics
                if is_initialized:
                    logger.debug(f"Skipping already initialized metric: {metric_name}")
                    continue
            else:  # incremental mode
                # In incremental mode, only run initialized metrics
                if not is_initialized:
                    logger.warning(f"Skipping uninitialized metric: {metric_name} (run --initial first)")
                    continue
            
            # Get SQL files for this metric and mode
            files = config.get("files", {}).get(self.mode, [])
            if files:
                metrics_to_run.append({
                    "name": metric_name,
                    "files": files,
                    "description": config.get("description", ""),
                    "requires_summary": config.get("requires_summary")
                })
        
        # Sort by first filename to maintain execution order
        metrics_to_run.sort(key=lambda x: x["files"][0] if x["files"] else "")
        
        return metrics_to_run
    
    def run_metric(self, metric_info: Dict, metric_date: str, params: dict = None) -> bool:
        """Run all SQL files for a single metric"""
        metric_name = metric_info["name"]
        files = metric_info["files"]
        
        try:
            total_rows = 0
            for sql_file in files:
                # Load SQL from the appropriate mode directory
                sql_path = f"{self.mode}/{sql_file}"
                sql = self.sql.load(sql_path)
                
                # Merge default params with custom params
                exec_params = {
                    'metric_date': metric_date,
                    'cutoff': CUTOFF_DATE,
                    'timezone': TIMEZONE,
                    'mode': self.mode,
                    **(params or {})
                }
                
                rows = self.db.execute(sql, exec_params)
                total_rows += rows
                logger.info(f"  {sql_file}: {rows} row(s) affected")
            
            logger.info(f"{metric_name}: Total {total_rows} row(s) affected for {metric_date}")
            return True
            
        except Exception as e:
            logger.error(f"Failed to run {metric_name} for {metric_date}: {str(e)}")
            logger.exception(e)
            return False
    
    def run_all_metrics(self, metric_date: str) -> Dict[str, bool]:
        """Run all configured metrics for a specific date"""
        results = {}
        
        if not self.metric_order:
            logger.error(f"No metrics configured to run in {self.mode} mode")
            return results
        
        with self.db.transaction():
            logger.info(f"Starting {self.mode} metrics calculation for {metric_date}")
            
            for metric_info in self.metric_order:
                metric_name = metric_info["name"]
                success = self.run_metric(metric_info, metric_date)
                results[metric_name] = success
                
                # Mark metric as initialized after successful initial load
                if success and self.mode == 'initial':
                    self._mark_initialized(metric_name, metric_date)
            
            # Save config if any metrics were initialized
            if self.mode == 'initial' and any(results.values()):
                self._save_config()
            
            if all(results.values()):
                logger.info(f"Successfully completed all metrics for {metric_date}")
            else:
                failed = [k for k, v in results.items() if not v]
                logger.warning(f"Some metrics failed for {metric_date}: {failed}")
        
        return results
    
    def _mark_initialized(self, metric_name: str, initial_load_date: str):
        """Mark a metric as initialized in the configuration"""
        if metric_name in self.metrics_config.get("metrics", {}):
            self.metrics_config["metrics"][metric_name]["initialized"] = True
            self.metrics_config["metrics"][metric_name]["initial_load_date"] = initial_load_date
            logger.info(f"Marked {metric_name} as initialized (date: {initial_load_date})")
    
    def recover_date_range(self, start_date: str, end_date: Optional[str] = None) -> List[str]:
        """Recover metrics for a date range"""
        if end_date is None:
            end_date = date.today().strftime('%Y-%m-%d')
        
        logger.info(f"Starting recovery from {start_date} to {end_date}")
        
        start = datetime.strptime(start_date, '%Y-%m-%d').date()
        end = datetime.strptime(end_date, '%Y-%m-%d').date()
        
        failed_dates = []
        current = start
        
        while current <= end:
            date_str = current.strftime('%Y-%m-%d')
            
            try:
                results = self.run_all_metrics(date_str)
                if not all(results.values()):
                    failed_dates.append(date_str)
            except Exception as e:
                logger.error(f"Error processing {date_str}: {str(e)}")
                failed_dates.append(date_str)
            
            current += timedelta(days=1)
        
        if failed_dates:
            logger.warning(f"Failed dates: {', '.join(failed_dates)}")
        else:
            logger.info("Recovery completed successfully")
        
        return failed_dates
    
    def list_metrics(self):
        """List all discovered metrics with their status"""
        print(f"\n=== Metrics Configuration ({self.mode.upper()} mode) ===\n")
        
        all_metrics = self.metrics_config.get("metrics", {})
        
        if not all_metrics:
            print("No metrics configured")
            return
        
        # Metrics to run
        print("✅ Metrics to run:")
        running = [m["name"] for m in self.metric_order]
        if running:
            for idx, metric_info in enumerate(self.metric_order, 1):
                metric_name = metric_info["name"]
                config = all_metrics[metric_name]
                init_date = config.get("initial_load_date", "N/A")
                files_count = len(metric_info["files"])
                print(f"  {idx}. {metric_name}")
                print(f"     Description: {metric_info['description']}")
                print(f"     Files: {files_count} SQL file(s)")
                print(f"     Initialized: {init_date}")
        else:
            print("  None")
        
        print()
        
        # Metrics skipped
        skipped = []
        for metric_name, config in all_metrics.items():
            is_initialized = config.get("initialized", False)
            is_enabled = config.get("enabled", True)
            
            if not is_enabled:
                skipped.append((metric_name, "Disabled"))
            elif self.mode == 'initial' and is_initialized:
                skipped.append((metric_name, "Already initialized"))
            elif self.mode == 'incremental' and not is_initialized:
                skipped.append((metric_name, "Not initialized (run --initial first)"))
        
        if skipped:
            print("⏭️  Metrics skipped:")
            for metric_name, reason in skipped:
                print(f"  - {metric_name}: {reason}")
            print()