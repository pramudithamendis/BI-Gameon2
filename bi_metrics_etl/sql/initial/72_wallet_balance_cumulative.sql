
insert into wallet_balance_cumulative(id,email,first_name,last_name,total_balance,total_hold,available_balance)
SELECT 
d.date_,
    d.user_id as id,
    d.email as email,
    d.first_name as first_name,
    d.last_name as last_name,
    SUM(d.total_coins) OVER (ORDER BY d.date_) AS total_balance,
    SUM(d.total_hold) OVER (ORDER BY d.date_) AS total_hold,
    SUM(d.available_balance) OVER (ORDER BY d.date_) AS available_balance
FROM wallet_balance_daily d
ORDER BY d.date_;