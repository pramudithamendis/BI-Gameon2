USE gaming_app_bi;

-- Get yesterday's date (converted to +08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

--------------------------------------------------------------------------------
-- Helper: A safe subquery wrapper to force only 1 row
--------------------------------------------------------------------------------

-- Previous total_ai_matches
SET @previous_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

-- Yesterday total_ai_matches
SET @yesterday_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


--------------------------------------------------------------------------------
-- player_wins
--------------------------------------------------------------------------------
SET @previous_player_wins := COALESCE(
    (SELECT player_wins 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_player_wins := COALESCE(
    (SELECT player_wins 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


--------------------------------------------------------------------------------
-- player_losses
--------------------------------------------------------------------------------
SET @previous_player_losses := COALESCE(
    (SELECT player_losses 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_player_losses := COALESCE(
    (SELECT player_losses 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


--------------------------------------------------------------------------------
-- spend_amount_usd
--------------------------------------------------------------------------------
SET @previous_spend_amount_usd := COALESCE(
    (SELECT spend_amount_usd 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_spend_amount_usd := COALESCE(
    (SELECT spend_amount_usd 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


--------------------------------------------------------------------------------
-- Insert cumulative
--------------------------------------------------------------------------------
INSERT INTO `02_AI_matches_cumulative`
    (date_,player_email, total_ai_matches, player_wins, player_losses, spend_amount_usd)
VALUES
    (
        @yesterday,
        null,
        @previous_total_ai_matches + @yesterday_total_ai_matches,
        @previous_player_wins + @yesterday_player_wins,
        @previous_player_losses + @yesterday_player_losses,
        @previous_spend_amount_usd + @yesterday_spend_amount_usd
    )
ON DUPLICATE KEY UPDATE
    total_ai_matches = VALUES(total_ai_matches),
    player_wins = VALUES(player_wins),
    player_losses = VALUES(player_losses),
    spend_amount_usd = VALUES(spend_amount_usd),
    updated_at = CURRENT_TIMESTAMP;


--------------------------------------------------------------------------------
-- View tables
--------------------------------------------------------------------------------
SELECT * FROM `02_AI_matches_cumulative` ORDER BY date_ DESC;
SELECT * FROM `02_AI_matches_daily` ORDER BY date_ DESC;
