#!/usr/bin/env python3
"""
Test database connection and verify setup

Usage:
    python test_connection.py
"""

import sys
from pathlib import Path

try:
    from config.database import DB_CONFIG
    import pymysql
except ImportError as e:
    print(f"❌ Import Error: {e}")
    print("\nPlease run: pip install -r requirements.txt")
    sys.exit(1)

def test_connection():
    """Test database connection"""
    print("=== Testing Database Connection ===\n")
    
    # Display configuration (hide password)
    print("Configuration:")
    for key, value in DB_CONFIG.items():
        if key == 'password':
            print(f"  {key}: {'*' * len(str(value)) if value else 'NOT SET'}")
        else:
            print(f"  {key}: {value}")
    print()
    
    # Test connection
    try:
        print("Connecting to database...")
        conn = pymysql.connect(**DB_CONFIG)
        print("✅ Connection successful!\n")
        
        # Test query
        print("Testing query execution...")
        with conn.cursor() as cursor:
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()
            print(f"✅ MySQL Version: {version}\n")
            
            # Check if bi_metrics table exists
            cursor.execute("""
                SELECT COUNT(*) as count 
                FROM information_schema.tables 
                WHERE table_schema = %s 
                AND table_name = 'bi_metrics'
            """, (DB_CONFIG['db'],))
            
            result = cursor.fetchone()
            if result['count'] > 0:
                print("✅ bi_metrics table exists\n")
                
                # Check table structure
                cursor.execute("DESCRIBE bi_metrics")
                columns = cursor.fetchall()
                print("Table structure:")
                for col in columns:
                    print(f"  - {col['Field']}: {col['Type']}")
                print()
                
                # Check record count
                cursor.execute("SELECT COUNT(*) as count FROM bi_metrics")
                count = cursor.fetchone()
                print(f"📊 Current records in bi_metrics: {count['count']}\n")
                
                # Show latest metrics
                cursor.execute("""
                    SELECT metrics, metric_date, created_at 
                    FROM bi_metrics 
                    ORDER BY created_at DESC 
                    LIMIT 5
                """)
                latest = cursor.fetchall()
                
                if latest:
                    print("Latest metrics:")
                    for row in latest:
                        print(f"  - {row['metrics']} ({row['metric_date']})")
                    print()
                
            else:
                print("⚠️  bi_metrics table does NOT exist")
                print("   Run: mysql -u user -p database < sql/schema.sql\n")
        
        conn.close()
        print("=== All Tests Passed! ===")
        return True
        
    except pymysql.err.OperationalError as e:
        print(f"❌ Connection failed: {e}\n")
        print("Troubleshooting:")
        print("  1. Check your .env file has correct credentials")
        print("  2. Verify MySQL server is running")
        print("  3. Confirm user has access to the database")
        print("  4. Check firewall settings")
        return False
        
    except Exception as e:
        print(f"❌ Error: {e}\n")
        return False

def check_files():
    """Check if all required files exist"""
    print("=== Checking Project Files ===\n")
    
    required_files = [
        'config/__init__.py',
        'config/database.py',
        'src/__init__.py',
        'src/db_manager.py',
        'src/sql_loader.py',
        'src/metric_runner.py',
        'sql/schema.sql',
        # 'sql/total_users_after_cutoff.sql',
        # 'sql/new_users_last_60d.sql',
        # 'sql/top_100_games_played.sql',
        'run_metrics.py',
        # '.env',
        'requirements.txt',
    ]
    
    all_exist = True
    for file_path in required_files:
        exists = Path(file_path).exists()
        status = "✅" if exists else "❌"
        print(f"{status} {file_path}")
        if not exists:
            all_exist = False
    
    print()
    if all_exist:
        print("✅ All required files present\n")
    else:
        print("⚠️  Some files are missing\n")
    
    return all_exist

def main():
    print("\n" + "="*50)
    print("BI Metrics ETL - Connection Test")
    print("="*50 + "\n")
    
    # Check files
    files_ok = check_files()
    
    if not files_ok:
        print("Please ensure all files are in place before testing connection.")
        sys.exit(1)
    
    # Test connection
    connection_ok = test_connection()
    
    if connection_ok:
        print("\n🎉 Setup verified! You're ready to run metrics.")
        print("\nNext steps:")
        print("  python run_metrics.py")
        sys.exit(0)
    else:
        print("\n⚠️  Please fix the issues above and try again.")
        sys.exit(1)

if __name__ == "__main__":
    main()