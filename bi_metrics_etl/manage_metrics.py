#!/usr/bin/env python3
"""
Metrics Management CLI

Manage metric configurations without editing JSON directly.

Usage:
    python manage_metrics.py list                           # List all metrics
    python manage_metrics.py enable METRIC_NAME             # Enable a metric
    python manage_metrics.py disable METRIC_NAME            # Disable a metric
    python manage_metrics.py reset METRIC_NAME              # Reset initialization status
    python manage_metrics.py info METRIC_NAME               # Show metric details
"""

import sys
import json
from pathlib import Path
from datetime import datetime

CONFIG_FILE = Path("config/metrics_registry.json")

def load_config():
    """Load metrics configuration"""
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    return {"metrics": {}, "last_updated": None}

def save_config(config):
    """Save metrics configuration"""
    config["last_updated"] = datetime.now().isoformat()
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)
    print(f"✅ Configuration saved")

def list_metrics():
    """List all metrics with their status"""
    config = load_config()
    metrics = config.get("metrics", {})
    
    if not metrics:
        print("No metrics configured")
        return
    
    print("\n=== Metrics Registry ===\n")
    print(f"{'Metric':<30} {'Status':<15} {'Initialized':<12} {'Init Date':<12}")
    print("-" * 75)
    
    for name, info in sorted(metrics.items()):
        enabled = "Enabled" if info.get("enabled", True) else "Disabled"
        initialized = "Yes" if info.get("initialized", False) else "No"
        init_date = info.get("initial_load_date") or "N/A"
        print(f"{name:<30} {enabled:<15} {initialized:<12} {init_date:<12}")
    
    print()

def enable_metric(metric_name):
    """Enable a metric"""
    config = load_config()
    if metric_name in config["metrics"]:
        config["metrics"][metric_name]["enabled"] = True
        save_config(config)
        print(f"✅ Enabled: {metric_name}")
    else:
        print(f"❌ Metric not found: {metric_name}")

def disable_metric(metric_name):
    """Disable a metric"""
    config = load_config()
    if metric_name in config["metrics"]:
        config["metrics"][metric_name]["enabled"] = False
        save_config(config)
        print(f"⏸️  Disabled: {metric_name}")
    else:
        print(f"❌ Metric not found: {metric_name}")

def reset_metric(metric_name):
    """Reset metric initialization status"""
    config = load_config()
    if metric_name in config["metrics"]:
        config["metrics"][metric_name]["initialized"] = False
        config["metrics"][metric_name]["initial_load_date"] = None
        save_config(config)
        print(f"🔄 Reset: {metric_name} (will run in initial mode next time)")
    else:
        print(f"❌ Metric not found: {metric_name}")

def show_info(metric_name):
    """Show detailed info about a metric"""
    config = load_config()
    if metric_name in config["metrics"]:
        info = config["metrics"][metric_name]
        print(f"\n=== {metric_name} ===\n")
        print(f"Description: {info.get('description', 'N/A')}")
        print(f"Enabled: {info.get('enabled', True)}")
        print(f"Initialized: {info.get('initialized', False)}")
        print(f"Initial Load Date: {info.get('initial_load_date') or 'N/A'}")
        
        if info.get('requires_summary'):
            print(f"Requires Summary Table: {info['requires_summary']}")
        
        print("\nSQL Files:")
        files = info.get('files', {})
        print(f"  Initial: {', '.join(files.get('initial', []))}")
        print(f"  Incremental: {', '.join(files.get('incremental', []))}")
        print()
    else:
        print(f"❌ Metric not found: {metric_name}")

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    if command == "list":
        list_metrics()
    elif command == "enable" and len(sys.argv) == 3:
        enable_metric(sys.argv[2])
    elif command == "disable" and len(sys.argv) == 3:
        disable_metric(sys.argv[2])
    elif command == "reset" and len(sys.argv) == 3:
        reset_metric(sys.argv[2])
    elif command == "info" and len(sys.argv) == 3:
        show_info(sys.argv[2])
    else:
        print(__doc__)
        sys.exit(1)

if __name__ == "__main__":
    main()