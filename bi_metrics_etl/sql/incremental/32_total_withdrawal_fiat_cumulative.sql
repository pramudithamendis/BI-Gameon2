-- USE gaming_app_bi;

-- -- Get yesterday's date
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- -- Get the cumulative total up to the day before yesterday
-- SET @previous_total := COALESCE(
--     (SELECT total_completed_amount FROM total_withdrawal_fiat_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
--     0
-- );

-- -- Get yesterday's new user count
-- SET @yesterday_count := COALESCE(
--     (SELECT total_completed_amount FROM total_deposits_fiat_daily WHERE date_ = @yesterday),
--     0
-- );

-- -- Insert or update the cumulative total for yesterday
-- INSERT INTO total_withdrawal_fiat_cumulative (date_, total_completed_amount)
-- VALUES (@yesterday, @previous_total + @yesterday_count)
-- ON DUPLICATE KEY UPDATE 
--     total_completed_amount = @previous_total + @yesterday_count,
--     updated_at = CURRENT_TIMESTAMP;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get cumulative totals up to the day before yesterday
SET @previous_total := COALESCE(
    (SELECT total_completed_amount 
     FROM total_withdrawal_fiat_cumulative 
     WHERE date_ < @yesterday 
     ORDER BY date_ DESC 
     LIMIT 1),
    0
);

SET @previous_txns := COALESCE(
    (SELECT total_transactions 
     FROM total_withdrawal_fiat_cumulative 
     WHERE date_ < @yesterday 
     ORDER BY date_ DESC 
     LIMIT 1),
    0
);

-- Get yesterday's approved daily totals
SET @yesterday_amount := COALESCE(
    (SELECT total_completed_amount 
     FROM total_withdrawal_fiat_daily 
     WHERE date_ = @yesterday),
    0
);

SET @yesterday_txns := COALESCE(
    (SELECT total_transactions 
     FROM total_withdrawal_fiat_daily 
     WHERE date_ = @yesterday),
    0
);

-- Insert or update cumulative total for yesterday
INSERT INTO total_withdrawal_fiat_cumulative (date_, total_completed_amount, total_transactions)
VALUES (
    @yesterday, 
    @previous_total + @yesterday_amount, 
    @previous_txns + @yesterday_txns
)
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

-- Verify
SELECT 
    @yesterday AS yesterday_sgt,
    @previous_total AS previous_amount,
    @yesterday_amount AS new_amount,
    @previous_txns AS previous_tx,
    @yesterday_txns AS new_tx;

SELECT * 
FROM total_withdrawal_fiat_cumulative
WHERE date_ >= DATE_SUB(@yesterday, INTERVAL 2 DAY)
ORDER BY date_;

select * from total_withdrawal_fiat_cumulative;
select * from total_withdrawal_fiat_daily;
