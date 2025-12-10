USE gaming_app_bi;

SET @yesterday := DATE(
  CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 5 DAY), '+00:00', '+08:00')
);

INSERT INTO user_earnings_cumulative (
    date_,
    user_id,
    daily_amount,
    cumulative_amount
)
SELECT
    d.date_,
    d.user_id,
    d.amount AS daily_amount,

    COALESCE(p.cumulative_amount, 0) + d.amount AS cumulative_amount

FROM user_earnings_daily d

LEFT JOIN user_earnings_cumulative p
    ON p.user_id = d.user_id
   AND p.date_ = DATE_SUB(d.date_, INTERVAL 1 DAY)

WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE
    daily_amount = VALUES(daily_amount),
    cumulative_amount = VALUES(cumulative_amount),
    updated_at = CURRENT_TIMESTAMP;

USE gaming_app_bi;

SET @yesterday := DATE(
  CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00')
);

INSERT INTO user_leaderboard_cumulative (
    date_,
    user_id,
    daily_score,
    cumulative_score
)
SELECT
    d.date_,
    d.user_id,
    d.score AS daily_score,

    COALESCE(p.cumulative_score, 0) + d.score AS cumulative_score

FROM user_leaderboard_daily d

LEFT JOIN user_leaderboard_cumulative p
    ON p.user_id = d.user_id
   AND p.date_ = DATE_SUB(d.date_, INTERVAL 1 DAY)

WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE
    daily_score = VALUES(daily_score),
    cumulative_score = VALUES(cumulative_score),
    updated_at = CURRENT_TIMESTAMP;