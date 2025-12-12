drop table user_earnings_weekly;
CREATE TEMPORARY TABLE user_earnings_weekly (
    id INT AUTO_INCREMENT PRIMARY KEY,
	year_week INT NOT NULL ,                       -- e.g., 202544 (YYYYWW format)
	week_start_date DATE NOT NULL,                -- first date of the week
	week_end_date DATE NOT NULL,                  -- last date of the week
	user_id INT NOT NULL,                    
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (year_week,user_id) 
);

select * from user_earnings_weekly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_earnings_weekly (year_week,week_start_date,week_end_date,user_id, amount) 
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    w.user AS user_id,
    SUM(
        CASE 
            WHEN w.is_game_won = 1 THEN gcb.amount
            ELSE 0
        END
    ) AS amount
FROM gaming_app_backend.user_game_session w
JOIN gaming_app_backend.game_session gs 
    ON w.game_session = gs.id
JOIN gaming_app_backend.game_coin_bet gcb 
    ON gs.game_coin_bet = gcb.id
WHERE w.created_at >= @cutoff
GROUP BY YEARWEEK(w.created_at, 1), user_id
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;
    
select * from user_earnings_weekly;

select * from user_leaderboard_weekly;
-- truncate table user_leaderboard_weekly;
SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_leaderboard_weekly (year_week, user_id,  score) 
select 
ued.year_week as year_week, 
ued.user_id as user_id,
(ugpwrd.win_rate_percentage * 0.7 + (ued.amount / 1000) * 0.2 + ugpwrd.total_games * 0.1) as score
from 
user_earnings_weekly ued,
user_gameplay_winning_rate_weekly ugpwrd
where ued.user_id = ugpwrd.user_id and ued.year_week = ugpwrd.year_week;

select * from user_leaderboard_weekly;