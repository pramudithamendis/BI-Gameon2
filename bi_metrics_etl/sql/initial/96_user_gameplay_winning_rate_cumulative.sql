



select * from user_gameplay_winning_rate_cumulative;

INSERT INTO user_gameplay_winning_rate_cumulative (
    date_,
    user_id,
    cumulative_total_games,
    cumulative_wins,
    cumulative_losses,
    cumulative_win_rate_percentage
)
SELECT
    date_,
    user_id,
    SUM(total_games) OVER (
        PARTITION BY user_id 
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_total_games,
    SUM(wins) OVER (
        PARTITION BY user_id 
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_wins,
    SUM(losses) OVER (
        PARTITION BY user_id 
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_losses,
    ROUND(
        (
            SUM(wins) OVER (
                PARTITION BY user_id 
                ORDER BY date_
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
            /
            SUM(total_games) OVER (
                PARTITION BY user_id 
                ORDER BY date_
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
        ) * 100,
        2
    ) AS cumulative_win_rate_percentage
FROM user_gameplay_winning_rate_daily;

select * from user_gameplay_winning_rate_daily;
select * from user_gameplay_winning_rate_cumulative;
