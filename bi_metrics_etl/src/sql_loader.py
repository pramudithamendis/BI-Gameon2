import os
from pathlib import Path
from typing import Dict

class SQLLoader:
    """Load and cache SQL queries from files"""
    
    def __init__(self, sql_dir: str = "sql"):
        self.sql_dir = Path(sql_dir)
        self._cache: Dict[str, str] = {}
    
    def load(self, filename: str) -> str:
        """
        Load SQL from file with caching.
        Supports subdirectories: e.g., 'initial/metric.sql' or 'incremental/metric.sql'
        """
        if filename not in self._cache:
            file_path = self.sql_dir / filename
            if not file_path.exists():
                raise FileNotFoundError(f"SQL file not found: {file_path}")
            
            with open(file_path, 'r', encoding='utf-8') as f:
                self._cache[filename] = f.read()
        
        return self._cache[filename]
    
    def load_all_metrics(self, mode: str = "incremental") -> Dict[str, str]:
        """Load all metric SQL files from specified mode directory"""
        metrics = {}
        mode_dir = self.sql_dir / mode
        
        if not mode_dir.exists():
            return metrics
            
        for sql_file in sorted(mode_dir.glob("*.sql")):
            metric_name = sql_file.stem
            metrics[metric_name] = self.load(f"{mode}/{sql_file.name}")
        return metrics