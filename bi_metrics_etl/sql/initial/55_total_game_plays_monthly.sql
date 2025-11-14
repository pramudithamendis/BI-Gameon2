SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_monthly(month_,total_sessions)
SELECT 
    DATE_FORMAT(gs.created_at, '%%Y-%%m') AS month_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE gs.created_at >= @cutoff
GROUP BY DATE_FORMAT(gs.created_at, '%%Y-%%m')
ORDER BY month_;