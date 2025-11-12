SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_cumulative(total_sessions)
SELECT 
COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
ON gs.id = ugs.game_session
where gs.created_at >= @cutoff;