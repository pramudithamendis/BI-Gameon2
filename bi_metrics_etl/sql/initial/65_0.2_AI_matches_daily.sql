insert into 02_AI_matches_daily (
    date_, total_ai_matches, player_wins, player_losses, spend_amount_usd
)
SELECT 
    DATE(gs.created_at) AS date_,  
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(
    SUM(
        CASE 
            WHEN ugp.is_game_finished = 1 
                    AND ugp.is_game_won = 1 THEN
                CASE 
                    WHEN gs.game_coin_bet = 12 THEN 0.10
                    WHEN gs.game_coin_bet = 13 THEN 0.20
                    ELSE 0
                END
            ELSE 0
        END
    ), 2
) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
WHERE 
    gs.game_session_mode = 5
    AND u_player.id NOT IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
GROUP BY 
    date_
ORDER BY 
    date_ DESC,
    spend_amount_usd DESC;