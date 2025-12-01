
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