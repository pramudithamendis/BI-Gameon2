insert into wallet_balance_weekly(user_id,email,first_name,last_name,year_,week_number,week_label,total_balance,total_hold,available_balance)
SELECT 
    u.id AS user_id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    YEAR(uca.created_at) AS year_,
    WEEK(uca.created_at, 1) AS week_number,  -- ISO week (Mon–Sun)
    CONCAT(YEAR(uca.created_at), '-W', LPAD(WEEK(uca.created_at, 1), 2, '0')) AS week_label,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1
   AND uca.is_active = 1
WHERE u.is_active = 1
GROUP BY 
    user_id,
    email,
    first_name,
    last_name,
    year_,
    week_number,
    week_label,
    YEAR(uca.created_at),
    WEEK(uca.created_at, 1)
ORDER BY 
    year_ DESC,
    week_number DESC,
    available_balance DESC;