-- SET @cutoff := '2025-09-27 18:30:00';
-- insert into total_withdrawal_crypto_cumulative( total_completed_amount, total_transactions)
-- SELECT 
-- SUM(w.coins) AS total_completed_amount,
-- COUNT(*) AS total_transactions
-- FROM gaming_app_backend.user_coin_transaction w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE w.user_coin_transaction_method =9
-- and w.created_at >= @cutoff;


USE gaming_app_bi;

-- Seed cumulative totals for all crypto withdrawals
TRUNCATE TABLE total_withdrawal_crypto_cumulative;

INSERT INTO total_withdrawal_crypto_cumulative (date_, total_completed_amount, total_transactions)
SELECT 
    d.date_,
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount,
    SUM(d.total_transactions) OVER (ORDER BY d.date_) AS total_transactions
FROM total_withdrawal_crypto_daily d
ORDER BY d.date_;
