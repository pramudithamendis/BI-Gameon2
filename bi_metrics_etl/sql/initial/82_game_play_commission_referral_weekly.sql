CREATE TABLE game_play_commission_referral_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    year_week INT NOT NULL,              -- Example: 202452
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL,

    coins_given DECIMAL(18,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uniq_year_week (year_week)
);
select * from game_play_commission_referral_weekly;

SET @cutoff := '2025-09-27 18:30:00';
insert into game_play_commission_referral_weekly(
    year_week,
    week_start_date,
    week_end_date,
    coins_given
)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    SUM(w.coins_given) AS coins_given
FROM gaming_app_backend.platform_commission_issued w
WHERE w.created_at >= @cutoff
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    coins_given = VALUES(coins_given),
    updated_at = CURRENT_TIMESTAMP;
select * from game_play_commission_referral_weekly;