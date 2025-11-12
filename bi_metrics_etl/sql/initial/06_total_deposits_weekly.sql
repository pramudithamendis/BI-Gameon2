SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_weekly(year_week,week_start_date,week_end_date,total_completed_amount, total_transactions)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC;