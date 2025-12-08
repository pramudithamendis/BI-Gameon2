
USE gaming_app_bi;

-- ✅ Get LAST WEEK range in Singapore time
SET @week_start := DATE_SUB(
    DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')),
    INTERVAL (WEEKDAY(DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00'))) + 7) DAY
);

SET @week_end := DATE_ADD(@week_start, INTERVAL 7 DAY);

INSERT INTO user_gameplay_winning_rate_weekly (
    year_week,
    week_start,
    user_id,
    total_games,
    wins,
    losses,
    win_rate_percentage
)
SELECT 
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,

    @week_start AS week_start,

    w.user AS user_id,

    COUNT(*) AS total_games,

    SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN w.is_game_won = 0 THEN 1 ELSE 0 END) AS losses,

    ROUND(
        (SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS win_rate_percentage

FROM gaming_app_backend.user_game_session w

WHERE CONVERT_TZ(w.created_at, '+00:00', '+08:00') >= @week_start
  AND CONVERT_TZ(w.created_at, '+00:00', '+08:00') <  @week_end

GROUP BY year_week, user_id

ON DUPLICATE KEY UPDATE
    total_games         = VALUES(total_games),
    wins               = VALUES(wins),
    losses             = VALUES(losses),
    win_rate_percentage = VALUES(win_rate_percentage),
    updated_at         = CURRENT_TIMESTAMP;


select * from user_gameplay_winning_rate_weekly;