USE gaming_app_bi;

CREATE TABLE registration_referral_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,                    -- Local date (+08:00)
    total_completed_amount INT NOT NULL,    -- Count for the day
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (date_)              -- Prevent duplicate entries per day
);

select * from registration_referral_daily;

-- Set cutoff datetime
SET @cutoff := '2025-09-27 18:30:00';

-- Insert or update daily totals (Singapore timezone)
INSERT INTO registration_referral_daily (date_, total_completed_amount)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    count(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE 
    w.created_at >= @cutoff
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
select * from registration_referral_daily;
