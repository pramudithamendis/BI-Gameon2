insert into total_game_plays_without_AI_and_Train_With_AI_cumulative(total_sessions)
SELECT 
    d.session_date,
    SUM(d.total_sessions) OVER (ORDER BY d.session_date) AS total_sessions
FROM total_game_plays_without_AI_and_Train_With_AI_daily d
ORDER BY d.session_date;