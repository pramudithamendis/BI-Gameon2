#!/usr/bin/env python3
"""
BI Metrics ETL Runner

Usage:
    # Incremental mode (daily runs)
    python run_metrics.py                           # Run for today
    python run_metrics.py 2025-01-15                # Run for specific date
    python run_metrics.py 2025-01-01 2025-01-15    # Recover date range
    
    # Initial load mode (first-time setup)
    python run_metrics.py --initial                 # Load all historical data
    python run_metrics.py --initial 2025-01-15      # Load for specific date
"""

import sys
import logging
from datetime import date
from pathlib import Path

from config.database import DB_CONFIG, LOG_LEVEL, ETL_MODE
from src.db_manager import DatabaseManager
from src.sql_loader import SQLLoader
from src.metric_runner import MetricRunner

# Ensure logs directory exists
Path('logs').mkdir(exist_ok=True)

# Configure logging
logging.basicConfig(
    level=getattr(logging, LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/metrics.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

def print_usage():
    """Print usage instructions"""
    print(__doc__)

def main():
    # Check for mode flag
    mode = ETL_MODE  # Default from config
    args = sys.argv[1:]
    
    # Check if --initial flag is present
    if '--initial' in args:
        mode = 'initial'
        args.remove('--initial')
    elif '--incremental' in args:
        mode = 'incremental'
        args.remove('--incremental')
    
    # Initialize components
    db_manager = DatabaseManager(DB_CONFIG)
    sql_loader = SQLLoader()
    runner = MetricRunner(db_manager, sql_loader, mode=mode)
    
    try:
        if len(args) == 0:
            # No arguments: run for today
            today = date.today().strftime('%Y-%m-%d')
            logger.info(f"Running {mode} metrics for today: {today}")
            results = runner.run_all_metrics(today)
            success = all(results.values())
            sys.exit(0 if success else 1)
            
        elif len(args) == 1:
            # One argument: run for specific date
            metric_date = args[0]
            logger.info(f"Running {mode} metrics for date: {metric_date}")
            results = runner.run_all_metrics(metric_date)
            success = all(results.values())
            sys.exit(0 if success else 1)
            
        elif len(args) == 2:
            # Two arguments: recover date range
            start_date = args[0]
            end_date = args[1]
            logger.info(f"Running {mode} recovery for date range: {start_date} to {end_date}")
            failed = runner.recover_date_range(start_date, end_date)
            sys.exit(0 if not failed else 1)
            
        else:
            print_usage()
            sys.exit(1)
            
    except Exception as e:
        logger.error(f"Fatal error: {str(e)}", exc_info=True)
        sys.exit(1)
        
    finally:
        db_manager.close()

if __name__ == "__main__":
    main()
