SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_fiat_monthly(month_,total_completed_amount,total_transactions)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 4
and w.created_at >= @cutoff
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC;