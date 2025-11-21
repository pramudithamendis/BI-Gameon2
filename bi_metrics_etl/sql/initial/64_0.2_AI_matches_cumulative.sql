INSERT INTO 02_AI_matches_cumulative (
date_,
    total_ai_matches, player_wins,
    player_losses, spend_amount_usd
)
select distinct(t.date__),t.total_ai_matches,t.player_wins,t.player_losses,t.spend_amount_usd from
(SELECT 
d.date_ as date__,
SUM(d.total_ai_matches) OVER (ORDER BY d.date_) AS total_ai_matches,
   SUM(d.player_wins) OVER (ORDER BY d.date_) AS player_wins,
    SUM(d.player_losses) OVER (ORDER BY d.date_) AS player_losses,
    SUM(d.spend_amount_usd) OVER (ORDER BY d.date_) AS spend_amount_usd
FROM 02_AI_matches_daily d
ORDER BY d.date_) as t;
