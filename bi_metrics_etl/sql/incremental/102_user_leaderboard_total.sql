USE gaming_app_bi;

select * from gaming_app_bi.game_c_finish_c_won_c_earnings;
-- Yesterday in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));
SET @isActive := 1;
INSERT INTO gaming_app_bi.game_c_finish_c_won_c_earnings (
    user_id,
    total_played_games_count,
    total_finished_count,
    total_won_count,
    total_earnings
)
SELECT
    u.id,
    COUNT(a.id) AS totalPlayedGamesCount,
    SUM(
        CASE 
            WHEN a.is_game_finished = 1 THEN 1 
            ELSE 0 
        END
    ) AS totalFinishedCount,
    SUM(
        CASE 
            WHEN a.is_game_finished = 1 
             AND a.is_game_won = 1 
            THEN 1 
            ELSE 0 
        END
    ) AS totalWonCount,
    SUM(
        CASE 
            WHEN a.is_game_finished = 1
             AND a.is_game_won = 1
             AND ucat.code = 'CAPTURE'
            THEN (uca.coins * gs.no_of_players)
            ELSE 0
        END
    ) AS totalEarnings

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
    AND DATE(CONVERT_TZ(a.created_at, '+00:00', '+08:00')) = @yesterday
    AND a.user = u.id
    AND a.game_session = gs.id
    AND gs.game_session_mode = gsm.id
    AND gs.game_session_status = gss.id
    AND a.user_coin_action = uca.id
    AND uca.user_coin_action_type = ucat.id
    AND gss.code IN ('TERMINATED', 'FINISHED')
    AND gsm.code <> 'AICHALLENGE'
GROUP BY
    u.id
ON DUPLICATE KEY UPDATE
    total_played_games_count = total_played_games_count + VALUES(total_played_games_count),
    total_finished_count     = total_finished_count + VALUES(total_finished_count),
    total_won_count          = total_won_count + VALUES(total_won_count),
    total_earnings           = total_earnings + VALUES(total_earnings),
    updated_at               = CURRENT_TIMESTAMP;

select * from gaming_app_bi.game_c_finish_c_won_c_earnings;

select * from gaming_app_bi.user_leaderboard_total;

INSERT INTO gaming_app_bi.user_leaderboard_total (user_id, score)
SELECT 
    a.user_id,
    (
        COALESCE(a.total_won_count / NULLIF(a.total_finished_count, 0), 0) * 0.7
        + ((a.total_earnings / 1000) * 0.2)
        + (a.total_finished_count * 0.1)
    ) AS score
FROM gaming_app_bi.game_c_finish_c_won_c_earnings a
ON DUPLICATE KEY UPDATE
    score = VALUES(score),
    updated_at = CURRENT_TIMESTAMP;

select * from gaming_app_bi.user_leaderboard_total;
