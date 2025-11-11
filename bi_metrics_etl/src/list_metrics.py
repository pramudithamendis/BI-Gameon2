#!/usr/bin/env python3
"""
List all available metrics

Usage:
    python list_metrics.py              # List incremental metrics
    python list_metrics.py --initial    # List initial load metrics
"""

import sys
from pathlib import Path

from config.database import DB_CONFIG, ETL_MODE
from src.db_manager import DatabaseManager
from src.sql_loader import SQLLoader
from src.metric_runner import MetricRunner

def main():
    # Check for mode flag
    mode = ETL_MODE
    if '--initial' in sys.argv:
        mode = 'initial'
    elif '--incremental' in sys.argv:
        mode = 'incremental'
    
    print("\n" + "="*50)
    print(f"BI Metrics - Available Metrics ({mode.upper()} mode)")
    print("="*50)
    
    # Initialize components
    db_manager = DatabaseManager(DB_CONFIG)
    sql_loader = SQLLoader()
    runner = MetricRunner(db_manager, sql_loader, mode=mode)
    
    # List all metrics
    runner.list_metrics()
    
    # Show execution order note
    print("Note: Metrics are executed in alphabetical order.")
    print("To control execution order, prefix filenames with numbers:")
    print(f"  Example: sql/{mode}/01_users.sql, sql/{mode}/02_revenue.sql")
    print()
    
    # Show mode switching
    print("To switch modes:")
    print(f"  python run_metrics.py --initial       # Run initial load")
    print(f"  python run_metrics.py --incremental   # Run incremental")
    print()

if __name__ == "__main__":
    main()