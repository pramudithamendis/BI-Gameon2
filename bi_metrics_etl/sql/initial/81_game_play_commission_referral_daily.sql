USE gaming_app_bi;


select * from game_play_commission_referral_daily;

-- Set cutoff datetime
SET @cutoff := '2025-09-27 18:30:00';

-- Insert or update daily totals (Singapore timezone)
INSERT INTO game_play_commission_referral_daily (date_, game_play_commission)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.coins_given) AS game_play_commission
FROM gaming_app_backend.platform_commission_issued w
WHERE 
    w.created_at >= @cutoff
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    game_play_commission = VALUES(game_play_commission),
    updated_at = CURRENT_TIMESTAMP;
select * from game_play_commission_referral_daily;
