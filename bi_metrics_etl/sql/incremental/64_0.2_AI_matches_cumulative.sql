
USE gaming_app_bi;

-- Get yesterday's date
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- Get the cumulative total up to the day before yesterday
SET @previous_total_ai_matches:= COALESCE(
    (SELECT total_ai_matches FROM 02_AI_matches_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- select @previous_total_ai_matche;
-- Get yesterday's new user count
SET @yesterday_total_ai_matches := COALESCE(
    (SELECT total_ai_matches FROM 02_AI_matches_daily WHERE date_ = @yesterday),
    0
);
-- select @yesterday_total_ai_matches;

-- Get the cumulative total up to the day before yesterday
SET @previous_player_wins:= COALESCE(
    (SELECT player_wins FROM 02_AI_matches_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- select @previous_player_win;
-- Get yesterday's new user count
SET @yesterday_player_wins := COALESCE(
    (SELECT player_wins FROM 02_AI_matches_daily WHERE date_ = @yesterday),
    0
);
-- select @yesterday_player_wins;

-- Get the cumulative total up to the day before yesterday
SET @previous_player_losses:= COALESCE(
    (SELECT player_losses FROM 02_AI_matches_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- select @previous_player_losse;
-- Get yesterday's new user count
SET @yesterday_player_losses := COALESCE(
    (SELECT player_losses FROM 02_AI_matches_daily WHERE date_ = @yesterday),
    0
);
-- select @yesterday_player_losses;

-- Get the cumulative total up to the day before yesterday
SET @previous_spend_amount_usd:= COALESCE(
    (SELECT spend_amount_usd FROM 02_AI_matches_cumulative WHERE date_ < @yesterday ORDER BY date_ DESC LIMIT 1),
    0
);
-- select @previous_spend_amount_us;
-- Get yesterday's new user count
SET @yesterday_spend_amount_usd := COALESCE(
    (SELECT spend_amount_usd FROM 02_AI_matches_daily WHERE date_ = @yesterday),
    0
);
-- select @yesterday_spend_amount_usd;

-- Insert or update the cumulative total for yesterday
INSERT INTO 02_AI_matches_cumulative (date_, total_ai_matches,player_wins,player_losses,spend_amount_usd)
VALUES (@yesterday, @previous_total_ai_matches+@yesterday_total_ai_matches,@previous_player_wins+@yesterday_player_wins,@previous_player_losses+@yesterday_player_losses,@previous_spend_amount_usd+@yesterday_spend_amount_usd)
ON DUPLICATE KEY UPDATE 
    total_ai_matches=VALUES(total_ai_matches),
    player_wins=VALUES(player_wins),
    player_losses=VALUES(player_losses),
    spend_amount_usd=VALUES(spend_amount_usd),
    updated_at = CURRENT_TIMESTAMP;

select * from 02_AI_matches_cumulative;
select * from 02_AI_matches_daily;