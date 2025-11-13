
USE gaming_app_bi;

-- Get yesterday's date
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_total := COALESCE(
    (SELECT total_sessions FROM total_game_plays_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
select @previous_total;
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get yesterday's new user count
SET @yesterday_count := COALESCE(
    (SELECT total_sessions FROM total_game_plays_daily WHERE date_ = @yesterday),
    0
);
select @yesterday_count;

-- Insert or update the cumulative total for yesterday
INSERT INTO total_game_plays_cumulative (date_, total_sessions)
VALUES (@yesterday, @previous_total + @yesterday_count)
ON DUPLICATE KEY UPDATE 
    total_sessions = @previous_total + @yesterday_count,
    updated_at = CURRENT_TIMESTAMP;
