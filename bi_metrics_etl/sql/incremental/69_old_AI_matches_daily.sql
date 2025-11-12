
-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO old_AI_matches_daily (
    match_date,
    total_ai_matches,
    total_player_wins,
    total_player_losses,
    total_spent_in_usd
)
SELECT 
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS match_date,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b 
    ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY 
    match_date
ON DUPLICATE KEY UPDATE
    total_ai_matches     = VALUES(total_ai_matches),
    total_player_wins    = VALUES(total_player_wins),
    total_player_losses  = VALUES(total_player_losses),
    total_spent_in_usd   = VALUES(total_spent_in_usd),
    updated_at           = CURRENT_TIMESTAMP;