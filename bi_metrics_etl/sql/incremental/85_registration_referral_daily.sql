USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(
    CONVERT_TZ(
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        '+00:00',
        '+08:00'
    )
);

INSERT INTO registration_referral_daily (date_, total_completed_amount)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    COUNT(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
