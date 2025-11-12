
insert into old_AI_matches_weekly(year_, week_number, total_ai_matches,total_player_wins,total_player_losses,total_spent_in_usd)
SELECT 
    YEAR(gs.created_at) AS year_,
    WEEK(gs.created_at, 1) AS week_number,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(gs.created_at) BETWEEN '2025-10-07' AND '2025-10-16'
GROUP BY 
    year_, week_number
ORDER BY 
    year_, week_number;