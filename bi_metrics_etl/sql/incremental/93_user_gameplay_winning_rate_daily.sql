




USE gaming_app_bi;

-- Get yesterday in Singapore timezone
SET @yesterday := DATE(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00')
);

INSERT INTO user_gameplay_winning_rate_daily (
    date_,
    user_id,
    total_games,
    wins,
    losses,
    win_rate_percentage
)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    w.user AS user_id,

    COUNT(*) AS total_games,

    SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN w.is_game_won = 0 THEN 1 ELSE 0 END) AS losses,

    ROUND(
        (SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS win_rate_percentage

FROM gaming_app_backend.user_game_session w

WHERE DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday

GROUP BY date_, user_id

ON DUPLICATE KEY UPDATE 
    total_games = VALUES(total_games),
    wins = VALUES(wins),
    losses = VALUES(losses),
    win_rate_percentage = VALUES(win_rate_percentage),
    updated_at = CURRENT_TIMESTAMP;


select * from user_gameplay_winning_rate_daily;