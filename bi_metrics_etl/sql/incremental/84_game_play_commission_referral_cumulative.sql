USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get cumulative total before yesterday
SET @previous_total := COALESCE(
    (
        SELECT game_play_commission
        FROM game_play_commission_referral_cumulative
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
        SELECT game_play_commission
        FROM game_play_commission_referral_daily
        WHERE date_ = @yesterday
    ),
    0
);
select @yesterday_amount;

-- Insert or update cumulative total for yesterday
INSERT INTO game_play_commission_referral_cumulative (date_, game_play_commission)
VALUES (
    @yesterday,
    @previous_total + @yesterday_amount
)
ON DUPLICATE KEY UPDATE 
    game_play_commission = VALUES(game_play_commission),
    updated_at = CURRENT_TIMESTAMP;
