
-- Define last week in ISO week format (Monday–Sunday)
SET @last_week := YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 1 WEEK), 1);

-- Calculate week start + week end for last week (Singapore time +08:00)
SET @week_start := DATE_SUB(
    DATE_FORMAT(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '%Y-%m-%d'),
    INTERVAL (WEEKDAY(CONVERT_TZ(CURDATE(), '+00:00', '+08:00')) + 7) DAY
);
SET @week_end := DATE_ADD(@week_start, INTERVAL 6 DAY);

INSERT INTO total_game_plays_weekly (week_start, week_end, total_sessions)
SELECT
    @week_start AS week_start,
    @week_end AS week_end,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE YEARWEEK(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'), 1) = @last_week
ON DUPLICATE KEY UPDATE
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;