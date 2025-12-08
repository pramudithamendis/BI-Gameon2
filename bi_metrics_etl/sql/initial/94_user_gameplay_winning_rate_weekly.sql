

drop table user_gameplay_winning_rate_weekly;

CREATE TABLE user_gameplay_winning_rate_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

	year_week INT NOT NULL unique, 
    week_start DATE NOT NULL,
    user_id BIGINT NOT NULL,

    total_games INT NOT NULL,
    wins INT NOT NULL,
    losses INT NOT NULL,

    win_rate_percentage DECIMAL(5,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_week (week_start, user_id)
);
select * from user_gameplay_winning_rate_weekly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_gameplay_winning_rate_weekly (
	year_week,
    week_start,
    user_id,
    total_games,
    wins,
    losses,
    win_rate_percentage
)
SELECT 
	YEARWEEK(w.created_at, 1) AS year_week,
    DATE_SUB(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')),
        INTERVAL WEEKDAY(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) DAY
    ) AS week_start,

    w.user AS user_id,

    COUNT(*) AS total_games,

    SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN w.is_game_won = 0 THEN 1 ELSE 0 END) AS losses,

    ROUND(
        (SUM(CASE WHEN w.is_game_won = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS win_rate_percentage

FROM gaming_app_backend.user_game_session w
WHERE w.created_at >= @cutoff
GROUP BY year_week,week_start, user_id

ON DUPLICATE KEY UPDATE
    total_games = VALUES(total_games),
    wins = VALUES(wins),
    losses = VALUES(losses),
    win_rate_percentage = VALUES(win_rate_percentage),
    created_at = CURRENT_TIMESTAMP;

select * from user_gameplay_winning_rate_weekly;
truncate table user_gameplay_winning_rate_weekly;