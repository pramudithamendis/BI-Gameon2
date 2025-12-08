

select * from user_gameplay_count_cumulative;

INSERT INTO user_gameplay_count_cumulative (date_, user_id, cumulative_count)
SELECT 
    date_,
    user_id,
    SUM(count) OVER (
        PARTITION BY user_id 
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_count
FROM user_gameplay_count_daily
ORDER BY user_id, date_;


select * from user_gameplay_count_cumulative;

