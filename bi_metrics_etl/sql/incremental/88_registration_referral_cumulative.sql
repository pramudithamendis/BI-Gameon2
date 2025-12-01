USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get cumulative total before yesterday
SET @previous_total := COALESCE(
    (
        SELECT total_completed_amount
        FROM registration_referral_cumulative
        WHERE date_ < @yesterday
        ORDER BY date_ DESC
        LIMIT 1
    ),
    0
);

select @previous_total;

SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));
-- Get yesterday's new deposit amount and transactions
SET @yesterday_amount := COALESCE(
    (
        SELECT total_completed_amount
        FROM registration_referral_daily
        WHERE date_ = @yesterday    ),0);
select @yesterday_amount;

-- Insert or update cumulative total for yesterday
INSERT INTO registration_referral_cumulative (date_, total_completed_amount)
VALUES (
    @yesterday,
    @previous_total + @yesterday_amount
)
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
