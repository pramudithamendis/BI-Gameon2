CREATE TABLE game_play_commission_referral_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(7) NOT NULL,                 -- Format: YYYY-MM
    coins_given DECIMAL(18, 4) NOT NULL,       -- Total coins per month
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY unique_month (month)
);
-- drop table game_play_commission_referral_monthly;
select * from game_play_commission_referral_monthly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO game_play_commission_referral_monthly (month, coins_given)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    SUM(w.coins_given) AS coins_given
FROM gaming_app_backend.platform_commission_issued w
WHERE w.created_at >= @cutoff
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC
ON DUPLICATE KEY UPDATE 
    coins_given = VALUES(coins_given),
    updated_at = CURRENT_TIMESTAMP;
select * from game_play_commission_referral_monthly;
