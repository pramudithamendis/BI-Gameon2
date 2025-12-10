-- Last completed ISO week in Singapore timezone
SET @last_week := YEARWEEK(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'),
    1
);



INSERT INTO user_earnings_weekly (
    year_week,
    week_start_date,
    week_end_date,
    user_id,
    amount
)
SELECT 
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,

    MIN(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_start_date,

    MAX(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_end_date,

    w.user AS user_id,

    SUM(gcb.amount) AS amount
FROM gaming_app_backend.user_game_session w
JOIN gaming_app_backend.game_session gs 
    ON w.game_session = gs.id
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE 
    w.is_game_won = 1
AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week
GROUP BY year_week, user_id
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;


select * from user_earnings_weekly;

INSERT INTO user_leaderboard_weekly (
    year_week,
    user_id,
    score
)
SELECT 
    ued.year_week,

    ued.user_id,

    (ugpwrd.win_rate_percentage * 0.7 
     + @earningsWeight * 0.2 
     + ugpwrd.total_games * 0.1) AS score
FROM user_earnings_weekly ued
JOIN user_gameplay_winning_rate_weekly ugpwrd
    ON ued.user_id = ugpwrd.user_id
   AND ued.year_week = ugpwrd.year_week
WHERE ued.year_week = @last_week
ON DUPLICATE KEY UPDATE 
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;

