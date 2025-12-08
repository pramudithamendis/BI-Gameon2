

drop table user_gameplay_winning_rate_cumulative;
CREATE TABLE user_gameplay_winning_rate_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    date_ DATE NOT NULL,
    user_id BIGINT NOT NULL,

    cumulative_total_games INT NOT NULL,
    cumulative_wins INT NOT NULL,
    cumulative_losses INT NOT NULL,

    cumulative_win_rate_percentage DECIMAL(5,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_date (date_, user_id)
);

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
-- truncate table user_gameplay_winning_rate_cumulative;