USE gaming_app_bi;

-- Get yesterday's date (in +08:00 timezone)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Insert or update cumulative total per user
INSERT INTO total_deposits_userwise_fiat_cumulative (date_, user_id, total_completed_amount, updated_at)
SELECT 
    @yesterday AS date_,
    tduf.user_id,
    COALESCE(prev.total_completed_amount, 0) + COALESCE(tduf.total_completed_amount, 0) AS total_completed_amount,
    CURRENT_TIMESTAMP AS updated_at
FROM total_deposits_userwise_fiat_daily tduf
LEFT JOIN (
    SELECT user_id, total_completed_amount
    FROM total_deposits_userwise_fiat_cumulative
    WHERE date_ < @yesterday
    ORDER BY date_ DESC
) prev ON prev.user_id = tduf.user_id
WHERE tduf.date_ = @yesterday
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = VALUES(updated_at);


--not done