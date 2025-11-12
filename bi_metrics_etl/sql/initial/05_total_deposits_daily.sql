SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_daily(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
