-- USE gaming_app_bi;

-- -- Get yesterday's date
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- -- Get the cumulative total up to the day before yesterday
-- SET @previous_total := COALESCE(
--     (SELECT total_completed_amount FROM total_deposits_fiat_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
--     0
-- );

-- -- Get yesterday's new user count
-- SET @yesterday_count := COALESCE(
--     (SELECT total_completed_amount FROM total_deposits_fiat_daily WHERE date_ = @yesterday),
--     0
-- );

-- -- Insert or update the cumulative total for yesterday
-- INSERT INTO total_deposits_fiat_cumulative (date_, total_completed_amount)
-- VALUES (@yesterday, @previous_total + @yesterday_count)
-- ON DUPLICATE KEY UPDATE 
--     total_completed_amount = @previous_total + @yesterday_count,
--     updated_at = CURRENT_TIMESTAMP;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_total := COALESCE(
    (
        SELECT total_completed_amount
        FROM total_deposits_fiat_cumulative
        WHERE date_ < @yesterday
        ORDER BY date_ DESC
        LIMIT 1
    ),
    0
);

-- Get cumulative transactions up to the day before yesterday (optional)
SET @previous_tx := COALESCE(
    (
        SELECT total_transactions
        FROM total_deposits_fiat_cumulative
        WHERE date_ < @yesterday
        ORDER BY date_ DESC
        LIMIT 1
    ),
    0
);

-- Get yesterday's total completed amount
SET @yesterday_amount := COALESCE(
    (
        SELECT total_completed_amount
        FROM total_deposits_fiat_daily
        WHERE date_ = @yesterday
    ),
    0
);

-- Get yesterday's total transactions
SET @yesterday_tx := COALESCE(
    (
        SELECT total_transactions
        FROM total_deposits_fiat_daily
        WHERE date_ = @yesterday
    ),
    0
);

-- Insert or update the cumulative total for yesterday
INSERT INTO total_deposits_fiat_cumulative (date_, total_completed_amount, total_transactions)
VALUES (
    @yesterday,
    @previous_total + @yesterday_amount,
    @previous_tx + @yesterday_tx
)
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

-- View the updated cumulative table
SELECT * 
FROM total_deposits_fiat_cumulative
ORDER BY date_ DESC;

--checked