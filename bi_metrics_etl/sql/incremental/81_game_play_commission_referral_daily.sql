USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00')
);

INSERT INTO game_play_commission_referral_daily (date_, game_play_commission)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.coins_given) AS game_play_commission
FROM gaming_app_backend.platform_commission_issued w
WHERE 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    game_play_commission = VALUES(game_play_commission),
    updated_at = CURRENT_TIMESTAMP;
