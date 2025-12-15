-- select * from user;
-- select distinct(user) from user_game_session;
CREATE TABLE temp_user_leaderboard_daily_new (
    user_id BIGINT NOT NULL,
	date_ DATE NOT NULL,          
    total_played_games_count INT NOT NULL DEFAULT 0,
    total_finished_count INT NOT NULL DEFAULT 0,
    total_won_count INT NOT NULL DEFAULT 0,
    total_earnings BIGINT NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (date_,user_id)

--     CONSTRAINT fk_ugps_user
--         FOREIGN KEY (user_id)
--         REFERENCES user(id)
--         ON DELETE CASCADE
) ;

select * from temp_user_leaderboard_daily_new;

SET @isActive = 1;
INSERT INTO temp_user_leaderboard_daily_new (
	date_,
    user_id,
    total_played_games_count,
    total_finished_count,
    total_won_count,
    total_earnings
)
SELECT
	DATE(CONVERT_TZ(a.created_at, '+00:00', '+08:00')) AS date_,
    u.id,
    COUNT(a.id) AS totalPlayedGamesCount,
    SUM(CASE  WHEN a.is_game_finished = 1 THEN 1 ELSE 0 END) AS totalFinishedCount,
    SUM(CASE WHEN a.is_game_finished = 1 AND a.is_game_won = 1 THEN 1 ELSE 0 END) AS totalWonCount,
    SUM(CASE WHEN a.is_game_finished = 1 AND a.is_game_won = 1 AND ucat.code = 'CAPTURE' THEN (uca.coins * gs.no_of_players) ELSE 0 END ) AS totalEarnings
FROM
    gaming_app_backend.user_game_session a,
    gaming_app_backend.user u,
    gaming_app_backend.game_session gs,
    gaming_app_backend.game_session_mode gsm,
    gaming_app_backend.game_session_status gss,
    gaming_app_backend.user_coin_action uca,
    gaming_app_backend.user_coin_action_type ucat
WHERE
    a.is_active = @isActive
    AND a.user = u.id
    AND a.game_session = gs.id
    AND gs.game_session_mode = gsm.id
    AND gs.game_session_status = gss.id
    AND a.user_coin_action = uca.id
    AND uca.user_coin_action_type = ucat.id
    AND gss.code IN ('TERMINATED', 'FINISHED')
    AND gsm.code <> 'AICHALLENGE'
GROUP BY
    date_,u.id;

select * from temp_user_leaderboard_daily_new;


CREATE TABLE user_leaderboard_daily_new (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    user_id BIGINT NOT NULL,
    score DECIMAL(10,4) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_date_user (date_, user_id),
    KEY idx_user (user_id)
);
select * from user_leaderboard_daily_new;

INSERT INTO user_leaderboard_daily_new (date_, user_id, score)
SELECT 
    a.date_,
    a.user_id,
    SUM(
        COALESCE(
            (a.total_won_count / NULLIF(a.total_finished_count, 0)) * 0.7,
            0
        )
        + ((a.total_earnings / 1000) * 0.2)
        + (a.total_finished_count * 0.1)
    ) AS score
FROM temp_user_leaderboard_daily_new a
GROUP BY a.date_, a.user_id;


select * from user_leaderboard_daily_new;