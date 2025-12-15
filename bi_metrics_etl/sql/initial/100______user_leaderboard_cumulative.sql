DROP TABLE IF EXISTS user_earnings_cumulative;

CREATE TABLE user_earnings_cumulative (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    user_id INT NOT NULL,

    daily_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    cumulative_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_date_user (date_, user_id)
);

select * from user_earnings_cumulative;

INSERT INTO user_earnings_cumulative (
    date_,
    user_id,
    daily_amount,
    cumulative_amount
)
SELECT
    date_,
    user_id,
    amount AS daily_amount,

    SUM(amount) OVER (
        PARTITION BY user_id
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_amount
FROM user_earnings_daily
ON DUPLICATE KEY UPDATE
    daily_amount = VALUES(daily_amount),
    cumulative_amount = VALUES(cumulative_amount),
    updated_at = CURRENT_TIMESTAMP;

select * from user_earnings_cumulative;

DROP TABLE IF EXISTS user_leaderboard_cumulative;

CREATE TABLE user_leaderboard_cumulative (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    user_id INT NOT NULL,

    daily_score DECIMAL(10,4) NOT NULL DEFAULT 0,
    cumulative_score DECIMAL(10,4) NOT NULL DEFAULT 0,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_date_user (date_, user_id)
);



INSERT INTO user_leaderboard_cumulative (
    date_,
    user_id,
    daily_score,
    cumulative_score
)
SELECT
    date_,
    user_id,
    score AS daily_score,

    SUM(score) OVER (
        PARTITION BY user_id
        ORDER BY date_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_score
FROM user_leaderboard_daily
ON DUPLICATE KEY UPDATE
    daily_score = VALUES(daily_score),
    cumulative_score = VALUES(cumulative_score),
    updated_at = CURRENT_TIMESTAMP;

select * from user_leaderboard_cumulative;