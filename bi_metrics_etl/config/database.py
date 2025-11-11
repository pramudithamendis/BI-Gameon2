import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "127.0.0.1"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "gameon_app"),
    "password": os.getenv("DB_PASS","Mng717648566@hdsGame"),
    "db": os.getenv("DB_NAME", "gaming_app_bi"),
    "charset": "utf8mb4",
    "autocommit": False,
}

# Application settings
TIMEZONE = os.getenv("TZ", "Asia/Singapore")  # Changed from Asia/Colombo
CUTOFF_DATE = os.getenv("CUTOFF_DATE", "2025-08-26 18:30:00")
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

# ETL Mode: 'initial' or 'incremental'
ETL_MODE = os.getenv("ETL_MODE", "incremental")
