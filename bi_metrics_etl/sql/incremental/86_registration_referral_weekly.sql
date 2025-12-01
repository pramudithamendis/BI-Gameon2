USE gaming_app_bi;

-- Get last week's year_week based on Singapore timezone
SET @last_week := YEARWEEK(DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')) - INTERVAL 1 WEEK, 1);

INSERT INTO registration_referral_weekly (
    year_week,
    week_start_date,
    week_end_date,
    total_completed_amount
)
SELECT 
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,
    MIN(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_start_date,
    MAX(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_end_date,
    COUNT(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week
GROUP BY year_week
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    week_start_date = VALUES(week_start_date),
    week_end_date = VALUES(week_end_date),
    updated_at = CURRENT_TIMESTAMP;
