select * from user_leaderboard_daily

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO user_earnings_daily (date_, user_id, amount) 
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    w.user AS user_id,
    SUM(gcb.amount) AS amount
FROM gaming_app_backend.user_game_session w
JOIN gaming_app_backend.game_session gs 
    ON w.game_session = gs.id
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE 
    w.is_game_won = 1
    AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_, user_id
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;

select * from user_earnings_daily;


USE gaming_app_bi;

INSERT INTO user_leaderboard_daily (date_, user_id, score) 
SELECT 
    ugpwrd.date_ AS date_,
    ugpwrd.user_id,

    AVG(
        (ugpwrd.win_rate_percentage * 0.7) +
        ((ued.amount / 1000) * 0.2) +
        (ugpwrd.total_games * 0.1)
    ) AS score

FROM user_earnings_daily ued
JOIN user_gameplay_winning_rate_daily ugpwrd 
    ON ued.user_id = ugpwrd.user_id
   AND ued.date_ = ugpwrd.date_

WHERE ugpwrd.date_ = @yesterday

GROUP BY date_, ugpwrd.user_id
ON DUPLICATE KEY UPDATE 
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;

select * from user_leaderboard_daily;