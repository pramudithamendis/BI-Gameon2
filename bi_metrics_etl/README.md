BI Metrics ETL

Automated ETL pipeline for populating business intelligence metrics into the bi_metrics table.

📂 Project Structure
bi_metrics_etl/
├── config/
│   ├── __init__.py
│   └── database.py
├── sql/
│   ├── schema.sql
│   ├── total_users_after_cutoff.sql
│   ├── new_users_last_60d.sql
│   └── top_100_games_played.sql
├── src/
│   ├── __init__.py
│   ├── db_manager.py
│   ├── metric_runner.py
│   └── sql_loader.py
├── .env.example
├── .gitignore
├── requirements.txt
├── run_metrics.py
├── setup.sh
└── README.md

✨ Features

Auto-Discovery: Automatically detects all SQL files in the sql/ directory

No Code Changes: Just add your SQL file – no Python changes needed

Execution Order Control: Use numbered prefixes (01_, 02_) to control order

Idempotent: Safe to re-run – overwrites existing data for the same date

Recovery Mode: Backfill any date range

Transaction Safe: All-or-nothing execution with automatic rollback

⚙️ Setup
1. Install Dependencies
pip install -r requirements.txt

2. Configure Environment
cp .env.example .env
# Edit .env with your actual database credentials

3. Create Database Schema
mysql -u your_user -p your_database < sql/schema.sql

🚀 Usage
List Available Metrics
python list_metrics.py

Run for Today
python run_metrics.py

Run for Specific Date
python run_metrics.py 2025-01-15

Recover Date Range
python run_metrics.py 2025-01-01 2025-01-31

➕ Adding New Metrics
Simple Method (No Execution Order)

Create SQL file in sql/ (e.g., sql/daily_active_users.sql)

Example:

-- Metric: daily_active_users
-- Description: Count of unique users active on a given date
-- Data Type: card

INSERT INTO bi_metrics (metrics, data_type, f_list, value_list, metric_date, created_at)
SELECT 
    'daily_active_users' AS metrics,
    'card' AS data_type,
    JSON_OBJECT() AS f_list,
    JSON_OBJECT('count', COUNT(DISTINCT user_id)) AS value_list,
    %(metric_date)s AS metric_date,
    NOW() AS created_at
FROM user_activity
WHERE DATE(activity_date) = %(metric_date)s
ON DUPLICATE KEY UPDATE 
    value_list = VALUES(value_list),
    updated_at = NOW();


Verify with:

python list_metrics.py

Advanced Method (With Execution Order)

If dependencies exist between metrics, use numeric prefixes:

sql/
├── 01_base_users.sql
├── 02_user_activity.sql
├── 03_user_engagement.sql
└── 99_summary_report.sql

📑 SQL File Requirements

Must use INSERT ... ON DUPLICATE KEY UPDATE for idempotency

Must include parameter: %(metric_date)s

Follow bi_metrics table structure:

Column	Type	Description
id	BIGINT	Primary key
metrics	VARCHAR(100)	Metric identifier
data_type	VARCHAR(50)	Type: card, timeseries, ranking
f_list	JSON	Metadata and filters
value_list	JSON	Actual metric values
metric_date	DATE	Date this metric represents
created_at	TIMESTAMP	First insert time
updated_at	TIMESTAMP	Last update time

Unique Constraint: (metrics, metric_date) ensures one record per metric per date.

⏱️ Scheduling with Cron

Run daily at 1:00 AM:

0 1 * * * cd /path/to/bi_metrics_etl && /usr/bin/python3 run_metrics.py >> logs/cron.log 2>&1

📊 Monitoring and Logs

Logs written to: logs/metrics.log

View live logs:

tail -f logs/metrics.log

🛠️ Troubleshooting
Metric Not Running
# Check if SQL file is discovered
python list_metrics.py

# Validate SQL syntax
mysql -u user -p database < sql/your_metric.sql

Execution Order Issues
mv sql/metric_a.sql sql/01_metric_a.sql
mv sql/metric_b.sql sql/02_metric_b.sql

View Metric Results
-- See all metrics
SELECT DISTINCT metrics FROM bi_metrics ORDER BY metrics;

-- See specific metric
SELECT * FROM bi_metrics 
WHERE metrics = 'your_metric_name' 
ORDER BY metric_date DESC 
LIMIT 10;

📌 Best Practices

Use snake_case for filenames (daily_active_users.sql)

Add comments at the top of SQL files describing metrics

Test SQL files directly in MySQL before deploying

Always use ON DUPLICATE KEY UPDATE for safety

Add indexes on frequently queried columns

Use numeric prefixes only when dependencies exist

📜 License

Internal use only – Gaming App Backend BI System

✅ Now developers can simply drop SQL files into the sql/ folder and they’ll automatically run! No Python code modifications required. 🎉

Usage Guide
First Time Setup (Initial Load)
bash# Load historical data up to today
python run_metrics.py --initial

# Or load up to a specific date
python run_metrics.py --initial 2024-12-31
Daily Operations (Incremental)
bash# Run today's incremental load
python run_metrics.py

# Or specify a date
python run_metrics.py 2025-01-15

# Scheduled via cron (daily at 1 AM)
0 1 * * * cd /path/to/project && python3 run_metrics.py >> logs/cron.log 2>&1
List Available Metrics
bash# List incremental metrics
python list_metrics.py

# List initial load metrics
python list_metrics.py --initial

Summary of Optimization Strategy
Metric TypeInitial LoadIncremental LoadExampleCumulativeSum all historicalAdd yesterday + today's deltaTotal users, Total revenueSnapshotQuery for that dateQuery for that dateDaily active users, Current inventoryRolling WindowCalculate full windowSlide window (drop old + add new)Last 30 days revenueRankingsFull calculationCan be incremental or full based on data volumeTop 100 users