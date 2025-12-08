
-- drop table user_gameplay_count_daily;
CREATE TABLE user_gameplay_count_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,                    -- Local date (+08:00)
    user_id INT NOT NULL,
    count INT NOT NULL,    -- Count for the day
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (date_,user_id)              -- Prevent duplicate entries per day
);

select * from user_gameplay_count_daily;

-- Set cutoff datetime
SET @cutoff := '2025-09-27 18:30:00';

-- Insert or update daily totals (Singapore timezone)
INSERT INTO user_gameplay_count_daily (date_, user_id, count)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    w.user as user_id,
    count(*) as count
FROM gaming_app_backend.user_game_session w
WHERE 
    w.created_at >= @cutoff
GROUP BY date_, user_id
ON DUPLICATE KEY UPDATE 
    count = VALUES(count),
    updated_at = CURRENT_TIMESTAMP;

select * from user_gameplay_count_daily;

-- truncate table user_gameplay_count_daily;