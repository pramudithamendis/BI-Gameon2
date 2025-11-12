SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_userwise_weekly(user_id, email,first_name,last_name,year,week_number,week_label,total_completed_amount,total_transactions) 
SELECT w.user AS user_id,
 u.email, 
 u.first_name, 
 u.last_name, 
 YEAR(w.created_at) AS year, 
 WEEK(w.created_at, 1) AS week_number, 
 CONCAT(YEAR(w.created_at), '-W', 
 LPAD(WEEK(w.created_at, 1), 2, '0')) AS week_label, 
 SUM(w.coins) AS total_completed_amount, 
 COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 3 or w.user_coin_transaction_method = 9)
GROUP BY user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at), WEEK(w.created_at, 1), CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) 
ORDER BY year DESC, week_number DESC, total_completed_amount DESC;