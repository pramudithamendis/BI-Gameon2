SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);
SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_deposits_userwise_fiat_weekly(user_id, email,first_name,last_name,year,week_number,week_label,total_completed_amount,total_transactions) 
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
	WHERE w.user_coin_transaction_method = 4 and w.created_at >= @cutoff   AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek
GROUP BY user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at), WEEK(w.created_at, 1), CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) 
ORDER BY year DESC, week_number DESC, total_completed_amount DESC
ON DUPLICATE KEY UPDATE 
    -- ONLY update amounts, not date ranges
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;