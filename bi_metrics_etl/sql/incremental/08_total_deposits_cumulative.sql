-- USE gaming_app_bi;

-- -- Get yesterday's date
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- -- Get the cumulative total up to the day before yesterday
-- SET @previous_total := COALESCE(
--     (SELECT total_completed_amount FROM total_deposits_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
--     0
-- );

-- -- Get yesterday's new user count
-- SET @yesterday_count := COALESCE(
--     (SELECT total_completed_amount FROM total_deposits_daily WHERE date_ = @yesterday),
--     0
-- );

-- -- Insert or update the cumulative total for yesterday
-- INSERT INTO total_deposits_cumulative (date_, total_completed_amount)
-- VALUES (@yesterday, @previous_total + @yesterday_count)
-- ON DUPLICATE KEY UPDATE 
--     total_completed_amount = @previous_total + @yesterday_count,
--     updated_at = CURRENT_TIMESTAMP;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get cumulative total before yesterday
SET @previous_total := COALESCE(
    (
        SELECT total_completed_amount
        FROM total_deposits_cumulative
        WHERE date_ < @yesterday
        ORDER BY date_ DESC
        LIMIT 1
    ),
    0
);

-- Get cumulative transactions before yesterday (optional)
SET @previous_tx := COALESCE(
    (
        SELECT total_transactions
        FROM total_deposits_cumulative
        WHERE date_ < @yesterday
        ORDER BY date_ DESC
        LIMIT 1
    ),
    0
);

-- Get yesterday's new deposit amount and transactions
SET @yesterday_amount := COALESCE(
    (
        SELECT total_completed_amount
        FROM total_deposits_daily
        WHERE date_ = @yesterday
    ),
    0
);

SET @yesterday_tx := COALESCE(
    (
        SELECT total_transactions
        FROM total_deposits_daily
        WHERE date_ = @yesterday
    ),
    0
);

-- Insert or update cumulative total for yesterday
INSERT INTO total_deposits_cumulative (date_, total_completed_amount, total_transactions)
VALUES (
    @yesterday,
    @previous_total + @yesterday_amount,
    @previous_tx + @yesterday_tx
)
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

-- Verify
SELECT 
    @yesterday AS yesterday_sgt,
    @previous_total AS prev_amount,
    @yesterday_amount AS new_amount,
    @previous_tx AS prev_tx,
    @yesterday_tx AS new_tx;

SELECT * 
FROM total_deposits_cumulative
WHERE date_ >= DATE_SUB(@yesterday, INTERVAL 2 DAY)
ORDER BY date_;


select * from total_deposits_cumulative;
select * from total_deposits_cumulative;
---checked