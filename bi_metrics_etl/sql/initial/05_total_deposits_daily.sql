-- SET @cutoff := '2025-09-27 18:30:00';
-- insert into total_deposits_daily(date_,total_completed_amount, total_transactions)
-- SELECT 
-- 	   DATE(w.created_at) AS date_,
-- 	   SUM(w.coins) as total_completed_coins,
-- 	    COUNT(*) AS total_transactions
-- FROM gaming_app_backend.user_coin_transaction w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
-- GROUP BY DATE(w.created_at)
-- ORDER BY DATE(w.created_at) DESC;

-- select * from total_deposits_daily;  

USE gaming_app_bi;

-- Set cutoff datetime
SET @cutoff := '2025-09-27 18:30:00';

-- Insert or update daily totals (Singapore timezone)
INSERT INTO total_deposits_daily (date_, total_completed_amount, total_transactions)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u 
    ON w.user = u.id
WHERE 
    w.created_at >= @cutoff
    AND w.user_coin_transaction_method IN (4, 5)
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
