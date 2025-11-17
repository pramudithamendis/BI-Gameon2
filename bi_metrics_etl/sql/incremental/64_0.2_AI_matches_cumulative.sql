USE gaming_app_bi;

-- Get yesterday's date (converted to +08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

SELECT 
    tt.tam,
    tt.pw,
    tt.pl,
    tt.sau
INTO 
    @tam,
    @pw,
    @pl,
    @sau
from
(select distinct(t.date__) as d,t.total_ai_matches tam,t.player_wins pw,t.player_losses pl,t.spend_amount_usd sau from
(SELECT 
d.date_ as date__,
   COUNT(*) OVER (ORDER BY d.date_) AS total_ai_matches,
   SUM(d.player_wins) OVER (ORDER BY d.date_) AS player_wins,
    SUM(d.player_losses) OVER (ORDER BY d.date_) AS player_losses,
    SUM(d.spend_amount_usd) OVER (ORDER BY d.date_) AS spend_amount_usd
FROM 02_AI_matches_daily d
ORDER BY d.date_) as t) as tt
where tt.d = @yesterday;



-- Previous total_ai_matches
SET @previous_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);
-- select @previous_total_ai_matches;

-- Yesterday total_ai_matches
SET @yesterday_total_ai_matches := COALESCE(
    (SELECT total_ai_matches 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);
-- select @yesterday_total_ai_matches;


SET @previous_player_wins := COALESCE(
    (SELECT player_wins 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);
-- select @previous_player_wins;

SET @yesterday_player_wins := COALESCE(
    (SELECT player_wins 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);
-- select @yesterday_player_wins;


SET @previous_player_losses := COALESCE(
    (SELECT player_losses 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);
-- select @previous_player_losses;
SET @yesterday_player_losses := COALESCE(
    (SELECT player_losses 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);
-- select @yesterday_player_losses;


SET @previous_spend_amount_usd := COALESCE(
    (SELECT spend_amount_usd 
     FROM `02_AI_matches_cumulative`
     WHERE date_ < @yesterday
     ORDER BY date_ DESC, id DESC
     LIMIT 1),
    0
);
-- select @previous_spend_amount_usd;
SET @yesterday_spend_amount_usd := COALESCE(
    (SELECT spend_amount_usd 
     FROM `02_AI_matches_daily`
     WHERE date_ = @yesterday
     ORDER BY id DESC
     LIMIT 1),
    0
);
-- select @yesterday_spend_amount_usd;


   
    
INSERT INTO `02_AI_matches_cumulative`
    (date_,total_ai_matches, player_wins, player_losses, spend_amount_usd)
VALUES
    (
        @yesterday,
        @tam,
         @pw,
       @pl,
         @sau
    )
ON DUPLICATE KEY UPDATE
    total_ai_matches = VALUES(total_ai_matches),
    player_wins = VALUES(player_wins),
    player_losses = VALUES(player_losses),
    spend_amount_usd = VALUES(spend_amount_usd),
    updated_at = CURRENT_TIMESTAMP;


SELECT * FROM `02_AI_matches_cumulative` ORDER BY date_ DESC;
SELECT * FROM `02_AI_matches_daily` ORDER BY date_ DESC;
