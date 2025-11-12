-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_plays_cumulative (date, total_sessions)
SELECT 
    @yesterday AS date,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;
