
-- Get last completed ISO week (Singapore timezone)
SET @last_week_label := CONCAT(
    YEAR(DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'))),
    '-W',
    LPAD(WEEK(DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00')), 1), 2, '0')
);

INSERT INTO 02_AI_matches_weekly(
    week_label, 
    player_name, 
    player_email,
    total_ai_matches, 
    player_wins, 
    player_losses, 
    spend_amount_usd
)
SELECT 
    @last_week_label AS week_label,
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    u_player.id NOT IN (1109,1110,1111,1112,1113)
    AND u_opponent.id IN (1109,1110,1111,1112,1113)
    AND CONCAT(YEAR(gs.created_at), '-W', LPAD(WEEK(gs.created_at, 1), 2, '0')) = @last_week_label
GROUP BY u_player.id
ON DUPLICATE KEY UPDATE 
    total_ai_matches = VALUES(total_ai_matches),
    player_wins = VALUES(player_wins),
    player_losses = VALUES(player_losses),
    spend_amount_usd = VALUES(spend_amount_usd),
    updated_at = CURRENT_TIMESTAMP;