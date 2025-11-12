SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_play_pool_amount_daily (date_, coin_bet_amount, total_sessions)
SELECT 
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    gcb.amount AS coin_bet_amount,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_, gcb.amount
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;