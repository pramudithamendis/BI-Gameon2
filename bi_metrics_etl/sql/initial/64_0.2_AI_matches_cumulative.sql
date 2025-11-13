INSERT INTO 02_AI_matches_cumulative (
date_,
    player_email, total_ai_matches, player_wins,
    player_losses, spend_amount_usd
)
SELECT 
d.date_,
    d.player_email AS player_email,
   COUNT(*) OVER (ORDER BY d.date_) AS total_ai_matches,
   SUM(d.player_wins) OVER (ORDER BY d.date_) AS player_wins,
    SUM(d.player_losses) OVER (ORDER BY d.date_) AS player_losses,
    SUM(d.spend_amount_usd) OVER (ORDER BY d.date_) AS spend_amount_usd
FROM 02_AI_matches_daily d
ORDER BY d.date_;
select * from 02_AI_matches_cumulative;