drop table user_earnings_monthly ;
CREATE TEMPORARY TABLE user_earnings_monthly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(7) NOT NULL,     
    user_id INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (month, user_id)
);

select * from user_earnings_monthly;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_earnings_monthly (month, user_id, amount) 
select 
  -- *,
  DATE_FORMAT(w.created_at, '%Y-%m') AS month,
  w.user as user_id,
  sum(gcb.amount) as amount
FROM 
gaming_app_backend.user_game_session w,
gaming_app_backend.game_session gs,
gaming_app_backend.game_coin_bet gcb
WHERE 
w.created_at >= @cutoff
and w.is_game_won = 1
and w.game_session = gs.id and gs.game_coin_bet = gcb.id
GROUP BY month, user_id
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;

select * from user_earnings_monthly;


select * from user_gameplay_winning_rate_monthly;


select * from user_leaderboard_monthly;


SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_leaderboard_monthly (month, user_id,  score) 
SELECT 
    ugpwrd.month AS month,
    ugpwrd.user_id,
    AVG(
        (ugpwrd.win_rate_percentage * 0.7) +
        ((ued.amount / 1000) * 0.2) +
        (ugpwrd.total_games * 0.1)
    ) AS score
FROM user_earnings_monthly ued
JOIN user_gameplay_winning_rate_monthly ugpwrd 
    ON ued.user_id = ugpwrd.user_id
   AND ued.month = ugpwrd.month
GROUP BY month, ugpwrd.user_id
ON DUPLICATE KEY UPDATE 
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;


select * from user_leaderboard_monthly;
