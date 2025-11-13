insert into total_game_plays_without_AI_and_Train_With_AI_daily(session_date,total_sessions)
SELECT 
    DATE(gs.created_at) AS session_date,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at > '2025-09-27'
    AND gs.game_session_mode NOT IN (3, 5)
GROUP BY 
    DATE(gs.created_at)
ORDER BY 
    session_date ASC
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;