SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);
SET @cutoff := '2025-09-27 18:30:00';
insert into total_withdrawal_fiat_weekly(year_week,week_start_date,week_end_date,total_completed_amount, total_transactions)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 3
and w.created_at >= @cutoff   AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    -- ONLY update amounts, not date ranges
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;