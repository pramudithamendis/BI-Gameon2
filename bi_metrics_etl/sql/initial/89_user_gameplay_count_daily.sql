


select * from user_gameplay_count_daily;


SET @cutoff := '2025-09-27 18:30:00';


INSERT INTO user_gameplay_count_daily (date_, user_id, count)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    w.user as user_id,
    count(*) as count
FROM gaming_app_backend.user_game_session w
WHERE 
    w.created_at >= @cutoff
GROUP BY date_, user_id
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;

select * from user_gameplay_count_daily;

