USE gaming_app_bi;

SET @cutoff := '2025-09-27 18:30:00';

INSERT INTO total_game_play_pool_amount_cumulative (date_, coin_bet_amount, total_sessions)
SELECT 
    d.date_,
    d.coin_bet_amount,
    SUM(d.total_sessions) OVER (
        PARTITION BY d.coin_bet_amount 
        ORDER BY d.date_
    ) AS total_sessions
FROM total_game_play_pool_amount_daily d
ORDER BY d.date_;
