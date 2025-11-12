
insert into wallet_balance_cumulative(id,email,first_name,last_name,total_balance,total_hold,available_balance)
SELECT 
    u.id as id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1  
   AND uca.is_active = 1             
WHERE u.is_active = 1
GROUP BY u.id, u.email, u.total_coins
ORDER BY available_balance DESC;