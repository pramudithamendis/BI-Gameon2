
INSERT INTO wallet_balance_cumulative(id, email, first_name, last_name, total_balance, total_hold, available_balance, updated_at)
SELECT 
    u.id AS id,
    u.email AS email,
    u.first_name AS first_name,
    u.last_name AS last_name,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance,
    CURRENT_TIMESTAMP AS updated_at
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1  
   AND uca.is_active = 1             
WHERE u.is_active = 1
GROUP BY u.id, u.email, u.total_coins
ON DUPLICATE KEY UPDATE
    email = VALUES(email),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    total_balance = VALUES(total_balance),
    total_hold = VALUES(total_hold),
    available_balance = VALUES(available_balance),
    updated_at = CURRENT_TIMESTAMP;