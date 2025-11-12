SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_deposits_userwise_crypto_cumulative(user_id,email,first_name,last_name,total_completed_amount,total_transactions) 
SELECT w.user AS user_id, u.email, u.first_name, u.last_name, SUM(w.coins) AS total_completed_amount, COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w

JOIN gaming_app_backend.user u ON w.user = u.id 
WHERE w.user_coin_transaction_method = 5 and w.created_at >= @cutoff 
GROUP BY w.user, u.email, u.first_name, u.last_name 
ORDER BY total_completed_amount DESC;