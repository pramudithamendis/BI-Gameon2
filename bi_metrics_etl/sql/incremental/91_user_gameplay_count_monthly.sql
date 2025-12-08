USE gaming_app_bi;


SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%%Y-%%m'
);

INSERT INTO user_gameplay_count_monthly (month_, user_id, count)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%%Y-%%m') AS month_,
    w.user AS user_id,
    COUNT(*) AS count
FROM gaming_app_backend.user_game_session w
WHERE DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%%Y-%%m') = @last_month
GROUP BY month_, user_id
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;


select * from user_gameplay_count_monthly;
