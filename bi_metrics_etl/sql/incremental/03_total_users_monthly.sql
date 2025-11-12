USE gaming_app_bi;

-- Get current month in Singapore timezone
SET @current_month := DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '+08:00'), '%%Y-%%m');

INSERT INTO total_users_monthly (month, value)
SELECT 
    DATE_FORMAT(date, '%%Y-%%m') AS month,
    SUM(value) AS value
FROM total_users_daily
WHERE DATE_FORMAT(date, '%%Y-%%m') = @current_month
GROUP BY month
ON DUPLICATE KEY UPDATE 
    value = VALUES(value),
    updated_at = CURRENT_TIMESTAMP;