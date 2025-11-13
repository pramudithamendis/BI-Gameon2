SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_userwise_fiat_daily(user_id, email, first_name, last_name, date_, total_completed_amount, total_transactions) 
SELECT w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) AS date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
	WHERE w.user_coin_transaction_method = 3
    and w.created_at >= @cutoff 
GROUP BY w.user,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) ORDER BY date DESC,
    total_completed_amount DESC
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;