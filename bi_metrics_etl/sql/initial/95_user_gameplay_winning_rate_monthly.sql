
select * from user_gameplay_winning_rate_monthly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_gameplay_winning_rate_monthly (
    month,
    user_id,
    total_games,
    wins,
    losses,
    win_rate_percentage
)
SELECT 
    DATE_FORMAT(w.created_at, '%%Y-%%m') AS month,

    w.user AS user_id,

    COUNT(*) AS total_games,

    SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN w.is_game_won = 0 THEN 1 ELSE 0 END) AS losses,

    ROUND(
        (SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS win_rate_percentage

FROM gaming_app_backend.user_game_session w
WHERE w.created_at >= @cutoff
GROUP BY month, user_id

ON DUPLICATE KEY UPDATE
    total_games = VALUES(total_games),
    wins = VALUES(wins),
    losses = VALUES(losses),
    win_rate_percentage = VALUES(win_rate_percentage),
    created_at = CURRENT_TIMESTAMP;


select * from user_gameplay_winning_rate_monthly;
truncate table user_gameplay_winning_rate_monthly;