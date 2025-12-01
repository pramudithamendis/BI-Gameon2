USE gaming_app_bi;

-- Get last month in YYYY-MM format (Singapore timezone)
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%Y-%m'
);

INSERT INTO registration_referral_monthly (month, total_completed_amount)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') AS month,
    COUNT(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY month
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
