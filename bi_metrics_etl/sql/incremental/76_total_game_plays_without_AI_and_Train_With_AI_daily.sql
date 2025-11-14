USE gaming_app_bi;

-- Set cutoff date (do not process sessions older than this)
SET @cutoff := '2025-09-27';

-- Calculate yesterday's date (Singapore time +08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Insert or update yesterday’s data
INSERT INTO total_game_plays_without_AI_and_Train_With_AI_daily (session_date, total_sessions)
SELECT 
    DATE(gs.created_at) AS session_date,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at >= @cutoff
    AND DATE(gs.created_at) = @yesterday
    AND gs.game_session_mode NOT IN (3, 5)
GROUP BY 
    DATE(gs.created_at)
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;