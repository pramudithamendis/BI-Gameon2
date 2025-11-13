
USE gaming_app_bi;

-- Get yesterday's date
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_base_amount_100pct:= COALESCE(
    (SELECT base_amount_100pct FROM total_game_play_comission_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- Get yesterday's new user count
SET @yesterday_base_amount_100pct := COALESCE(
    (SELECT base_amount_100pct FROM total_game_play_comission_daily WHERE date_ = @yesterday),
    0
);

-- Get the cumulative total up to the day before yesterday
SET @previous_developer_share_50pct:= COALESCE(
    (SELECT developer_share_50pct FROM total_game_play_comission_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- Get yesterday's new user count
SET @yesterday_developer_share_50pct := COALESCE(
    (SELECT developer_share_50pct FROM total_game_play_comission_daily WHERE date_ = @yesterday),
    0
);

-- Get the cumulative total up to the day before yesterday
SET @previous_tax_18pct:= COALESCE(
    (SELECT tax_18pct FROM total_game_play_comission_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- Get yesterday's new user count
SET @yesterday_tax_18pct := COALESCE(
    (SELECT tax_18pct FROM total_game_play_comission_daily WHERE date_ = @yesterday),
    0
);

-- Get the cumulative total up to the day before yesterday
SET @previous_remainder_you_keep_32pct:= COALESCE(
    (SELECT remainder_you_keep_32pct FROM total_game_play_comission_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- Get yesterday's new user count
SET @yesterday_remainder_you_keep_32pct := COALESCE(
    (SELECT remainder_you_keep_32pct FROM total_game_play_comission_daily WHERE date_ = @yesterday),
    0
);

-- Insert or update the cumulative total for yesterday
INSERT INTO total_game_play_comission_cumulative (date_, base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
VALUES (@yesterday, @previous_base_amount_100pct+@yesterday_base_amount_100pct,@previous_developer_share_50pct+@yesterday_developer_share_50pct,@previous_tax_18pct+@yesterday_tax_18pct,@previous_remainder_you_keep_32pct+@yesterday_remainder_you_keep_32pct)
ON DUPLICATE KEY UPDATE 
    base_amount_100pct=@previous_base_amount_100pct+@yesterday_base_amount_100pct,
    developer_share_50pct=@previous_developer_share_50pct+@yesterday_developer_share_50pct,
    tax_18pct=@previous_tax_18pct+@yesterday_tax_18pct,
    remainder_you_keep_32pct=@previous_remainder_you_keep_32pct+@yesterday_remainder_you_keep_32pct,
    updated_at = CURRENT_TIMESTAMP;

select * from total_game_play_comission_cumulative;
select * from total_game_play_comission_daily;