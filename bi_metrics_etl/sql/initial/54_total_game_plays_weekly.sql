SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_weekly(week_start, week_end, total_sessions)
SELECT 
    MIN(DATE(gs.created_at)) AS week_start,
    MAX(DATE(gs.created_at)) AS week_end,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE YEARWEEK(gs.created_at, 1) = YEARWEEK(CURDATE(), 1)
and gs.created_at >= @cutoff;