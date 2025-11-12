-- SET @cutoff := '2025-09-27 18:30:00';
-- insert into total_withdrawal_fiat_daily(date_,total_completed_amount, total_transactions)
-- SELECT 
-- 	   DATE(w.created_at) AS date_,
-- 	   SUM(w.coins) as total_completed_coins,
-- 	    COUNT(*) AS total_transactions
-- FROM gaming_app_backend.user_coin_transaction w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE w.user_coin_transaction_method = 3
-- and w.created_at >= @cutoff
-- GROUP BY DATE(w.created_at)
-- ORDER BY DATE(w.created_at) DESC;

USE gaming_app_bi;

-- Set cutoff datetime
SET @cutoff := '2025-09-27 18:30:00';

-- Insert or update daily totals for approved fiat withdrawals (Singapore timezone)
INSERT INTO total_withdrawal_fiat_daily (date_, total_completed_amount, total_transactions)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.amount_lkr) AS total_completed_amount,   -- using LKR field for fiat total
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_withdrawals w
JOIN gaming_app_backend.user u 
    ON w.user_id = u.id
WHERE 
    w.is_active = 1
    AND w.status = 'Approved'                           -- ✅ only approved withdrawals
    AND u.email NOT LIKE '%@gameonworld.ai%'            -- exclude internal/test users
    AND w.amount_lkr IS NOT NULL
    AND w.created_at >= @cutoff
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
