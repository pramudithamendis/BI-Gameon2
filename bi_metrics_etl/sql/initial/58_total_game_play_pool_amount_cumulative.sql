USE gaming_app_bi;

SET @cutoff := '2025-09-27 18:30:00';

INSERT INTO total_game_play_pool_amount_cumulative (date_, coin_bet_amount, total_sessions)
SELECT 
    t.date_,
    t.coin_bet_amount,
    SUM(t.total_sessions) OVER (
        PARTITION BY t.coin_bet_amount 
        ORDER BY t.date_
    ) AS total_sessions
FROM (
    SELECT 
        DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
        gcb.amount AS coin_bet_amount,
        COUNT(DISTINCT gs.id) AS total_sessions
    FROM gaming_app_backend.game_session gs
    JOIN gaming_app_backend.user_game_session ugs 
        ON gs.id = ugs.game_session
    JOIN gaming_app_backend.game_coin_bet gcb 
        ON gs.game_coin_bet = gcb.id
    WHERE gs.created_at >= @cutoff
    GROUP BY DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')), gcb.amount
) AS t
ORDER BY t.coin_bet_amount, t.date_;

