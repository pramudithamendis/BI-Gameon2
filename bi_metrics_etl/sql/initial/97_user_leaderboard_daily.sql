drop table user_earnings_daily ;
CREATE TEMPORARY TABLE user_earnings_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,                    
    user_id INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (date_, user_id)
);

select * from user_earnings_daily;

SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_earnings_daily (date_, user_id, amount) 
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
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
GROUP BY date_, user_id
ON DUPLICATE KEY UPDATE 
    amount = VALUES(amount),
    updated_at = CURRENT_TIMESTAMP;

select * from user_earnings_daily;

select * from user_gameplay_winning_rate_daily;

drop table user_leaderboard_daily;
CREATE TABLE user_leaderboard_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,                    
    user_id INT NOT NULL,
    score DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_date (date_, user_id)
);

select * from user_leaderboard_daily;


SET @cutoff := '2025-09-27 18:30:00';
INSERT INTO user_leaderboard_daily (date_, user_id, score) 
SELECT 
    DATE(CONVERT_TZ(ugpwrd.date_, '+00:00', '+08:00')) AS date_,
    ugpwrd.user_id,

    AVG(
        (ugpwrd.win_rate_percentage * 0.7) +
        ((ued.amount / 1000) * 0.2) +
        (ugpwrd.total_games * 0.1)
    ) AS score

FROM user_earnings_daily ued
JOIN user_gameplay_winning_rate_daily ugpwrd 
    ON ued.user_id = ugpwrd.user_id
   AND ued.date_ = ugpwrd.date_

GROUP BY date_, ugpwrd.user_id
ON DUPLICATE KEY UPDATE 
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;



select * from user_leaderboard_daily;
