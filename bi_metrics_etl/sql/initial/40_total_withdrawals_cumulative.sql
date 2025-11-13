SET @cutoff := '2025-09-27 18:30:00';
insert into total_withdrawals_cumulative(date_,total_completed_amount, total_transactions)
SELECT 
    d.date_,
    SUM(d.total_completed_amount) OVER (ORDER BY d.date_) AS total_completed_amount,
    SUM(d.total_transactions) OVER (ORDER BY d.date_) AS total_transactions
FROM total_withdrawals_daily d
ORDER by d.date_;

-- checked