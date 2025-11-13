USE gaming_app_bi;

SET @cutoff := '2025-09-27 18:30:00';

-- Step 1: Insert cumulative total sessions
INSERT INTO total_game_plays_cumulative (date_, total_sessions)
SELECT 
    d.date_ AS date_,
    SUM(d.total_sessions) OVER (ORDER BY d.date_) AS total_sessions
FROM total_game_plays_daily d
ORDER BY d.date_;