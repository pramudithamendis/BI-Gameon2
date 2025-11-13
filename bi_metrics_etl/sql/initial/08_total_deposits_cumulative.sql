-- SET @cutoff := '2025-09-27 18:30:00';
-- insert into total_deposits_cumulative(total_completed_amount, total_transactions)
-- SELECT 
-- SUM(w.coins) AS total_completed_amount,
-- COUNT(*) AS total_transactions
-- FROM gaming_app_backend.user_coin_transaction w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5);

USE gaming_app_bi;

TRUNCATE TABLE total_deposits_cumulative;

-- Seed the cumulative totals based on daily records
INSERT INTO total_deposits_cumulative (date_, total_completed_amount, total_transactions)
SELECT 
    d.date_,
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount,
    SUM(d.total_transactions) OVER (ORDER BY d.date_) AS total_transactions
FROM total_deposits_daily d
ORDER BY d.date_;
