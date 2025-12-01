CREATE TABLE registration_referral_monthly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(7) NOT NULL,     -- Format: YYYY-MM
    total_completed_amount INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_month (month)
);

select * from registration_referral_monthly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO registration_referral_monthly (month, total_completed_amount)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    Count(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE w.created_at >= @cutoff
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
    
    select * from registration_referral_monthly;
