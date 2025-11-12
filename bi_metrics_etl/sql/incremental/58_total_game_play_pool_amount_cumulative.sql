
USE gaming_app_bi;

-- Get yesterday's date
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_total := COALESCE(
    (SELECT coin_bet_amount FROM total_game_play_pool_amount_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);


-- Get yesterday's new user count
SET @yesterday_count := COALESCE(
    (SELECT coin_bet_amount FROM total_game_play_pool_amount_daily WHERE date_ = @yesterday),
    0
);


SET @total_sessions := COALESCE(
    (SELECT total_sessions FROM total_game_play_pool_amount_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);


-- Get yesterday's new user count
SET @yesterday_total_sessions := COALESCE(
    (SELECT total_sessions FROM total_game_play_pool_amount_daily WHERE date_ = @yesterday),
    0
);


-- Insert or update the cumulative total for yesterday
INSERT INTO total_game_play_pool_amount_cumulative (date_, coin_bet_amount,total_sessions)
VALUES (@yesterday, @previous_total + @yesterday_count,@total_sessions+@yesterday_total_sessions)
ON DUPLICATE KEY UPDATE 
    coin_bet_amount = @previous_total + @yesterday_count,
    total_sessions = @total_sessions+@yesterday_total_sessions,
    updated_at = CURRENT_TIMESTAMP;