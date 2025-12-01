

select * from registration_referral_weekly;

SET @cutoff := '2025-09-27 18:30:00';
insert into registration_referral_weekly(    year_week,    week_start_date,    week_end_date,    total_completed_amount)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    count(*) AS total_completed_amount
FROM gaming_app_backend.share_code_usage w
WHERE w.created_at >= @cutoff
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    updated_at = CURRENT_TIMESTAMP;
    
select * from registration_referral_weekly;
