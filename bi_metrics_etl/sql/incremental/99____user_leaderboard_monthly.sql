-- Last completed month in Singapore timezone
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%%Y-%%m'
);

INSERT INTO user_earnings_monthly (month, user_id, amount)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%%Y-%%m') AS month,
    w.user AS user_id,
    SUM(gcb.amount) AS amount
FROM gaming_app_backend.user_game_session w
JOIN gaming_app_backend.game_session gs 
    ON w.game_session = gs.id
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE w.is_game_won = 1
  AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%%Y-%%m') = @last_month
GROUP BY month, user_id
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;



-- Last completed month in Singapore timezone
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%%Y-%%m'
);

INSERT INTO user_leaderboard_monthly (month, user_id, score)
SELECT
    ugpwrd.month AS month,
    ugpwrd.user_id,
    AVG(
        (ugpwrd.win_rate_percentage * 0.7) +
        ((ued.amount / 1000) * 0.2) +
        (ugpwrd.total_games * 0.1)
    ) AS score
FROM user_earnings_monthly ued
JOIN user_gameplay_winning_rate_monthly ugpwrd
    ON ued.user_id = ugpwrd.user_id
   AND ued.month = ugpwrd.month
WHERE ugpwrd.month = @last_month
GROUP BY month, ugpwrd.user_id
ON DUPLICATE KEY UPDATE
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;

