USE gaming_app_bi;


SET @last_week_start := DATE(
    SUBDATE(
        CONVERT_TZ(NOW(), '+00:00', '+08:00'),
        WEEKDAY(CONVERT_TZ(NOW(), '+00:00', '+08:00')) + 7
    )
);

SET @last_week_end := DATE_ADD(@last_week_start, INTERVAL 6 DAY);

INSERT INTO user_gameplay_count_weekly (
    year_week,
    week_start_date,
    week_end_date,
    user_id,
    count
)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    @last_week_start AS week_start_date,
    @last_week_end AS week_end_date,
    w.user AS user_id,
    COUNT(*) AS count
FROM gaming_app_backend.user_game_session w
WHERE DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))
      BETWEEN @last_week_start AND @last_week_end
GROUP BY YEARWEEK(w.created_at, 1), w.user
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;


select * from user_gameplay_count_weekly;



