USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00')
);

INSERT INTO user_gameplay_count_daily (date_, user_id, count)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    w.user AS user_id,
    COUNT(*) AS count
FROM gaming_app_backend.user_game_session w
WHERE DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_, user_id
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;


select * from user_gameplay_count_daily;
