insert into total_game_plays_daily(date_,total_sessions)
SELECT 
    DATE(gs.created_at) AS date_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(gs.created_at) = CURDATE()
GROUP BY DATE(gs.created_at)
ORDER BY DATE(gs.created_at);