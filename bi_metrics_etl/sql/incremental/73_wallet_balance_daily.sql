
-- Compute yesterday in Singapore timezone (UTC+8)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO wallet_balance_daily(
    user_id,
    email,
    first_name,
    last_name,
    date_,
    total_balance,
    total_hold,
    available_balance
)
SELECT 
    u.id AS user_id,
    u.email AS email,
    u.first_name AS first_name,
    u.last_name AS last_name,
    @yesterday AS date_,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1   
   AND uca.is_active = 1
   AND DATE(CONVERT_TZ(uca.created_at, '+00:00', '+08:00')) = @yesterday
WHERE u.is_active = 1
GROUP BY 
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    u.total_coins
ON DUPLICATE KEY UPDATE
    total_balance = VALUES(total_balance),
    total_hold = VALUES(total_hold),
    available_balance = VALUES(available_balance),
    updated_at = CURRENT_TIMESTAMP;