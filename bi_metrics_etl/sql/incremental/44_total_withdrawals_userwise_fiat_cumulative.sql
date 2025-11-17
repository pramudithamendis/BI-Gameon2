 USE gaming_app_bi;

-- Get yesterday date in UTC+08:00 (same standard as other ETL jobs)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Insert or update cumulative values for each user
INSERT INTO total_withdrawals_userwise_fiat_cumulative (
    date_, user_id, email, first_name, last_name,
    total_completed_amount, total_transactions
)
SELECT
    @yesterday AS date_,
    d.user_id,
    d.email,
    d.first_name,
    d.last_name,

    -- cumulative = previous total + today's amount
    COALESCE(
        (
            SELECT total_completed_amount
            FROM total_withdrawals_userwise_fiat_cumulative
            WHERE user_id = d.user_id AND date_ < @yesterday
            ORDER BY date_ DESC
            LIMIT 1
        ),
        0
    ) + COALESCE(d.total_completed_amount, 0) AS total_completed_amount,

    COALESCE(
        (
            SELECT total_transactions
            FROM total_withdrawals_userwise_fiat_cumulative
            WHERE user_id = d.user_id AND date_ < @yesterday
            ORDER BY date_ DESC
            LIMIT 1
        ),
        0
    ) + COALESCE(d.total_transactions, 0) AS total_transactions

FROM total_withdrawals_userwise_fiat_daily d
WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    email = VALUES(email),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    updated_at = CURRENT_TIMESTAMP;

-- Debug output (optional)
SELECT * FROM total_withdrawals_userwise_fiat_cumulative ORDER BY date_, user_id;
