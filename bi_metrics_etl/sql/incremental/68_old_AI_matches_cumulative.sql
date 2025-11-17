USE gaming_app_bi;

-- Get yesterday's date (converted to +08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));


-- Previous total_ai_matches
SET @previous_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `old_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

-- Yesterday total_ai_matches
SET @yesterday_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `old_AI_matches_daily`
     WHERE match_date = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


SET @previous_player_wins := COALESCE(
    (SELECT total_player_wins 
     FROM `old_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_player_wins := COALESCE(
    (SELECT total_player_wins 
     FROM `old_AI_matches_daily`
     WHERE match_date = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


SET @previous_player_losses := COALESCE(
    (SELECT total_player_losses 
     FROM `old_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_player_losses := COALESCE(
    (SELECT total_player_losses 
     FROM `old_AI_matches_daily`
     WHERE match_date = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


SET @previous_spend_amount_usd := COALESCE(
    (SELECT total_spent_in_usd 
     FROM `old_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);

SET @yesterday_spend_amount_usd := COALESCE(
    (SELECT total_spent_in_usd 
     FROM `old_AI_matches_daily`
     WHERE match_date = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);


INSERT INTO `old_AI_matches_cumulative`
    (date_,total_ai_matches, total_player_wins, total_player_losses, total_spent_in_usd)
VALUES
    (
        @yesterday,
        @previous_total_ai_matches + @yesterday_total_ai_matches,
        @previous_player_wins + @yesterday_player_wins,
        @previous_player_losses + @yesterday_player_losses,
        @previous_spend_amount_usd + @yesterday_spend_amount_usd
    )
ON DUPLICATE KEY UPDATE
    total_ai_matches = VALUES(total_ai_matches),
    total_player_wins = VALUES(total_player_wins),
    total_player_losses = VALUES(total_player_losses),
    total_spent_in_usd = VALUES(total_spent_in_usd),
    updated_at = CURRENT_TIMESTAMP;


SELECT * FROM `old_AI_matches_cumulative` ORDER BY date_ DESC;

