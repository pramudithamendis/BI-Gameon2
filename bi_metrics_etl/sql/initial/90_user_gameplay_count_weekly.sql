-- drop table user_gameplay_count_weekly;
CREATE TABLE user_gameplay_count_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL ,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    user_id INT NOT NULL,
    count INT NOT NULL DEFAULT 0, -- sum of actual_amount
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_date (year_week,user_id) 
);

select * from user_gameplay_count_weekly;
SET @cutoff := '2025-09-27 18:30:00';
insert into user_gameplay_count_weekly(year_week,week_start_date,week_end_date,user_id, count)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
	w.user as user_id,
    count(*) AS count
FROM gaming_app_backend.user_game_session w
WHERE w.created_at >= @cutoff
GROUP BY YEARWEEK(w.created_at, 1),user_id
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;
select * from user_gameplay_count_weekly;
-- truncate table user_gameplay_count_weekly;