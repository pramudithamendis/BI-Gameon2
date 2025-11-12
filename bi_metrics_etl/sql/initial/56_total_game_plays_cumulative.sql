USE gaming_app_bi;

SET @cutoff := '2025-09-27 18:30:00';

-- Step 1: Insert cumulative total sessions
INSERT INTO total_game_plays_cumulative (date_, total_sessions)
SELECT 
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    SUM(COUNT(DISTINCT gs.id)) OVER (ORDER BY DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'))) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE gs.created_at >= @cutoff
GROUP BY DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'))
ORDER BY date_;