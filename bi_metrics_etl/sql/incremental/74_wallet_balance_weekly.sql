
-- Get last week's year and week number in Singapore timezone
SET @sg_now := CONVERT_TZ(NOW(), '+00:00', '+08:00');
SET @last_week_year  := YEAR(DATE_SUB(@sg_now, INTERVAL 1 WEEK));
SET @last_week_num   := WEEK(DATE_SUB(@sg_now, INTERVAL 1 WEEK), 1);

INSERT INTO wallet_balance_weekly (
    user_id, email, first_name, last_name,
    year_, week_number, week_label,
    total_balance, total_hold, available_balance
)
SELECT 
    u.id AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    @last_week_year AS year_,
    @last_week_num AS week_number,
    CONCAT(@last_week_year, '-W', LPAD(@last_week_num, 2, '0')) AS week_label,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1
   AND uca.is_active = 1
   AND YEAR(uca.created_at) = @last_week_year
   AND WEEK(uca.created_at, 1) = @last_week_num
WHERE u.is_active = 1
GROUP BY u.id
ON DUPLICATE KEY UPDATE 
    total_balance     = VALUES(total_balance),
    total_hold        = VALUES(total_hold),
    available_balance = VALUES(available_balance),
    updated_at        = CURRENT_TIMESTAMP;