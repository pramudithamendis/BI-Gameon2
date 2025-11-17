 USE gaming_app_bi;

-- Get yesterday date based on UTC+08
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Insert or update cumulative data per user
INSERT INTO total_withdrawals_userwise_cumulative (
    date_,
    user_id,
    email,
    first_name,
    last_name,
    total_completed_amount,
    total_transactions
)
SELECT 
    @yesterday AS date_,
    d.user_id,
    d.email,
    d.first_name,
    d.last_name,
    COALESCE(prev.total_completed_amount, 0) + COALESCE(d.total_completed_amount, 0) AS total_completed_amount,
    COALESCE(prev.total_transactions, 0) + COALESCE(d.total_transactions, 0) AS total_transactions
FROM total_withdrawals_userwise_daily d
LEFT JOIN (
    SELECT user_id, total_completed_amount, total_transactions
    FROM total_withdrawals_userwise_cumulative
    WHERE date_ < @yesterday
    ORDER BY date_ DESC
) prev ON prev.user_id = d.user_id
WHERE d.date_ = @yesterday
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions     = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

-- Debug checks (optional)
SELECT * FROM total_withdrawals_userwise_cumulative ORDER BY date_, user_id;
SELECT * FROM total_withdrawals_userwise_daily ORDER BY date_, user_id;
