USE gaming_app_bi;

-- Get yesterday in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO user_gameplay_winning_rate_cumulative (
    date_,
    user_id,
    cumulative_total_games,
    cumulative_wins,
    cumulative_losses,
    cumulative_win_rate_percentage
)
SELECT
    d.date_,
    d.user_id,

    -- Add yesterday totals to previous cumulative values
    COALESCE(p.cumulative_total_games, 0) + d.total_games AS cumulative_total_games,
    COALESCE(p.cumulative_wins, 0) + d.wins AS cumulative_wins,
    COALESCE(p.cumulative_losses, 0) + d.losses AS cumulative_losses,

    -- Recalculate cumulative win rate
    ROUND(
        (
            (COALESCE(p.cumulative_wins, 0) + d.wins) /
            NULLIF(COALESCE(p.cumulative_total_games, 0) + d.total_games, 0)
        ) * 100,
        2
    ) AS cumulative_win_rate_percentage

FROM user_gameplay_winning_rate_daily d

-- Get previous day's cumulative record
LEFT JOIN user_gameplay_winning_rate_cumulative p
    ON p.user_id = d.user_id
   AND p.date_ = DATE_SUB(@yesterday, INTERVAL 1 DAY)

WHERE d.date_ = @yesterday

ON DUPLICATE KEY UPDATE
    cumulative_total_games = VALUES(cumulative_total_games),
    cumulative_wins = VALUES(cumulative_wins),
    cumulative_losses = VALUES(cumulative_losses),
    cumulative_win_rate_percentage = VALUES(cumulative_win_rate_percentage),
    updated_at = CURRENT_TIMESTAMP;



select * from user_gameplay_winning_rate_cumulative;