USE gaming_app_bi;

-- Get yesterday in SG timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO user_gameplay_count_cumulative (date_, user_id, cumulative_count)
SELECT 
    d.date_,
    d.user_id,
    COALESCE(c.cumulative_count, 0) + d.count AS cumulative_count
FROM user_gameplay_count_daily d

LEFT JOIN user_gameplay_count_cumulative c
    ON c.user_id = d.user_id
   AND c.date_ = DATE_SUB(d.date_, INTERVAL 1 DAY)

WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE 
    cumulative_count = VALUES(cumulative_count),
    updated_at = CURRENT_TIMESTAMP;



select * from user_gameplay_count_cumulative;