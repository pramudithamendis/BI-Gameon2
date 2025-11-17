 USE gaming_app_bi;

-- Determine yesterday date in UTC+08:00
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Insert or update cumulative values user-by-user
INSERT INTO total_withdrawals_userwise_crypto_cumulative (
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
    COALESCE((
        SELECT total_completed_amount
        FROM total_withdrawals_userwise_crypto_cumulative c
        WHERE c.user_id = d.user_id
          AND c.date_ < @yesterday
        ORDER BY c.date_ DESC
        LIMIT 1
    ),0)
    + COALESCE(d.total_completed_amount,0) AS total_completed_amount,
    
    COALESCE((
        SELECT total_transactions
        FROM total_withdrawals_userwise_crypto_cumulative c
        WHERE c.user_id = d.user_id
          AND c.date_ < @yesterday
        ORDER BY c.date_ DESC
        LIMIT 1
    ),0)
    + COALESCE(d.total_transactions,0) AS total_transactions
FROM total_withdrawals_userwise_crypto_daily d
WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

select * from total_withdrawals_userwise_crypto_cumulative;