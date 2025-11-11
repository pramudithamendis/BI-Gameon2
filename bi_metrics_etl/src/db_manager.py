import pymysql
import logging
from contextlib import contextmanager
from typing import Optional

logger = logging.getLogger(__name__)

class DatabaseManager:
    """Manage database connections and transactions"""
    
    def __init__(self, config: dict):
        self.config = config
        self._connection: Optional[pymysql.connections.Connection] = None
    
    def connect(self):
        """Establish database connection"""
        if self._connection is None or not self._connection.open:
            self._connection = pymysql.connect(
                **self.config,
                cursorclass=pymysql.cursors.DictCursor,
                client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS
            )
            logger.info("Database connection established")
        return self._connection
    
    def close(self):
        """Close database connection"""
        if self._connection and self._connection.open:
            self._connection.close()
            logger.info("Database connection closed")
    
    @contextmanager
    def transaction(self):
        """Context manager for safe transactions"""
        conn = self.connect()
        try:
            yield conn
            conn.commit()
            logger.debug("Transaction committed")
        except Exception as e:
            conn.rollback()
            logger.error(f"Transaction rolled back: {str(e)}")
            raise
    
    def execute(self, sql: str, params: dict = None) -> int:
        """Execute SQL and return affected rows"""
        conn = self.connect()
        with conn.cursor() as cursor:
            rows = cursor.execute(sql, params or {})
            return rows