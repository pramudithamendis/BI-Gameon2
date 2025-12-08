drop table user_gameplay_count_monthly;

CREATE TABLE user_gameplay_count_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL, -- format YYYY-MM
    user_id INT NOT NULL,
    count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY uq_date (month_,user_id) 
);

select * from user_gameplay_count_monthly;

SET @cutoff := '2025-09-27 18:30:00';
insert into user_gameplay_count_monthly(month_,user_id,count)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    w.user as user_id,
    count(*) AS count
FROM gaming_app_backend.user_game_session w
WHERE w.created_at >= @cutoff
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m'), user_id
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC;


select * from user_gameplay_count_monthly;
-- truncate table user_gameplay_count_monthly;