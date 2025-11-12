SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_plays_daily (date_, total_sessions)
SELECT 
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;