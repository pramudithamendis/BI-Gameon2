insert into total_game_plays_without_AI_and Train_With_AI_cumulative(total_sessions)
SELECT 
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at > '2025-09-27'
    AND gs.game_session_mode NOT IN (3, 5);