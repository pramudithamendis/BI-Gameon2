

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_userwise_fiat_cumulative(date_,user_id,email,first_name,last_name,total_completed_amount,total_transactions) 
SELECT d.date_,d.user_id AS user_id, d.email, d.first_name, d.last_name, 
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount,
    SUM(d.total_transactions) OVER (ORDER BY d.date_) AS total_transactions
FROM total_withdrawals_userwise_fiat_daily d
ORDER BY d.date_;

select * from total_withdrawals_userwise_fiat_cumulative