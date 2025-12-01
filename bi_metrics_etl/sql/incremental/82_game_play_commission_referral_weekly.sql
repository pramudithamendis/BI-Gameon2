USE gaming_app_bi;

-- Get last week number in ISO week format (Singapore timezone)
SET @last_week := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);

INSERT INTO game_play_commission_referral_weekly (
    year_week,
    week_start_date,
    week_end_date,
    coins_given
)
SELECT
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,
    MIN(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_start_date,
    MAX(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_end_date,
    SUM(w.coins_given) AS coins_given
FROM gaming_app_backend.platform_commission_issued w
WHERE YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week
GROUP BY year_week
ON DUPLICATE KEY UPDATE 
    coins_given = VALUES(coins_given),
    updated_at = CURRENT_TIMESTAMP;
