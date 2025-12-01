
select * from registration_referral_cumulative ;

-- Seed the cumulative totals based on daily records
INSERT INTO registration_referral_cumulative (date_, total_completed_amount)
SELECT 
    d.date_,
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount
FROM registration_referral_daily d
ORDER BY d.date_;

select * from registration_referral_cumulative ;