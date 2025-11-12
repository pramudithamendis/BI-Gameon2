SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_play_pool_amount_daily(date_, coin_bet_amount,total_sessions)
SELECT 
    DATE(gs.created_at) AS date_,
    gcb.amount AS coin_bet_amount,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE DATE(gs.created_at) = '2025-10-19'
and gs.created_at >= @cutoff
GROUP BY DATE(gs.created_at), gcb.amount
ORDER BY gcb.amount;