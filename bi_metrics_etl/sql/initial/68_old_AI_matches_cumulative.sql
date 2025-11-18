INSERT INTO old_AI_matches_cumulative (
date_,
     total_ai_matches,total_player_wins,total_player_losses,total_spent_in_usd
)
SELECT 
d.match_date as date_,
   SUM(d.total_ai_matches) OVER (ORDER BY d.match_date) AS total_ai_matches,
   SUM(d.total_player_wins) OVER (ORDER BY d.match_date) AS total_player_wins,
    SUM(d.total_player_losses) OVER (ORDER BY d.match_date) AS total_player_losses,
    SUM(d.total_spent_in_usd) OVER (ORDER BY d.match_date) AS total_spent_in_usd
FROM old_AI_matches_daily d
ORDER BY d.match_date;