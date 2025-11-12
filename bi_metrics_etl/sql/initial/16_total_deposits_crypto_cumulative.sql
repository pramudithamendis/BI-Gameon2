USE gaming_app_bi;

-- Seed cumulative totals for crypto deposits based on daily data
TRUNCATE TABLE total_deposits_crypto_cumulative;

INSERT INTO total_deposits_crypto_cumulative (date_, total_completed_amount, total_transactions)
SELECT 
    d.date_,
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount,
    SUM(d.total_transactions) OVER (ORDER BY d.date_) AS total_transactions
FROM total_deposits_crypto_daily d
ORDER BY d.date_;
