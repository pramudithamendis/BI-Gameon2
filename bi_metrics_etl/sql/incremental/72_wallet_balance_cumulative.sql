INSERT INTO wallet_balance_cumulative (
    id,
    email,
    first_name,
    last_name,
    date_,
    total_balance,
    total_hold,
    available_balance
)
SELECT 
    d.user_id AS id,
    d.email,
    d.first_name,
    d.last_name,
    d.date_,

    -- cumulative totals
    SUM(d.total_balance) OVER (
        PARTITION BY d.user_id 
        ORDER BY d.date_
    ) AS total_balance,

    SUM(d.total_hold) OVER (
        PARTITION BY d.user_id 
        ORDER BY d.date_
    ) AS total_hold,

    SUM(d.available_balance) OVER (
        PARTITION BY d.user_id 
        ORDER BY d.date_
    ) AS available_balance

FROM wallet_balance_daily d
ORDER BY d.user_id, d.date_

ON DUPLICATE KEY UPDATE
    email = VALUES(email),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),

    total_balance = VALUES(total_balance),
    total_hold = VALUES(total_hold),
    available_balance = VALUES(available_balance),
    updated_at = CURRENT_TIMESTAMP;