-- drop table user_gameplay_winning_rate_daily;
CREATE TABLE user_gameplay_winning_rate_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    date_ DATE NOT NULL,
    user_id BIGINT NOT NULL,

    total_games INT NOT NULL,
    wins INT NOT NULL,
    losses INT NOT NULL,

    win_rate_percentage DECIMAL(5,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_date (date_, user_id)
);

select * from user_gameplay_winning_rate_daily;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_gameplay_winning_rate_daily (
    date_,
    user_id,
    total_games,
    wins,
    losses,
    win_rate_percentage
)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
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
GROUP BY date_, user_id;

select * from user_gameplay_winning_rate_daily;
-- truncate table user_gameplay_winning_rate_daily;