USE gaming_app_bi;

-- Get yesterday's date
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_total := COALESCE(
    (SELECT value FROM total_users_cumulative WHERE date < @yesterday ORDER BY date DESC LIMIT 1),
    0
);

-- Get yesterday's new user count
SET @yesterday_count := COALESCE(
    (SELECT value FROM total_users_daily WHERE date = @yesterday),
    0
);

-- Insert or update the cumulative total for yesterday
INSERT INTO total_users_cumulative (date, value)
VALUES (@yesterday, @previous_total + @yesterday_count)
ON DUPLICATE KEY UPDATE 
    value = @previous_total + @yesterday_count,
    updated_at = CURRENT_TIMESTAMP;


--checked 