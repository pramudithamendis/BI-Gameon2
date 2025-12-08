-- drop table user_gameplay_count_cumulative;
CREATE TABLE user_gameplay_count_cumulative (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    user_id INT NOT NULL,
    cumulative_count INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_date_user (date_, user_id)
);

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
-- TRUNCATE TABLE user_gameplay_count_cumulative;
