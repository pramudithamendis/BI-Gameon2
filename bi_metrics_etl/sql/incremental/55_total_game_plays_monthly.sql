 USE gaming_app_bi;

-- Current month in UTC+8
SET @current_month := DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '+08:00'), '%Y-%m');

-- Get previous recorded total for this month
SET @previous_total := COALESCE(
    (SELECT total_sessions
     FROM total_game_plays_monthly
     WHERE month_ = @current_month
     LIMIT 1),
    0
);

-- Count fresh sessions for this month
SET @new_sessions := COALESCE(
    (
        SELECT COUNT(DISTINCT gs.id)
        FROM gaming_app_backend.game_session gs
        JOIN gaming_app_backend.user_game_session ugs
            ON gs.id = ugs.game_session
        WHERE DATE_FORMAT(gs.created_at, '%Y-%m') = @current_month
    ),
    0
);

-- Insert or update accumulated monthly total
INSERT INTO total_game_plays_monthly (month_, total_sessions)
VALUES (@current_month, @new_sessions)
ON DUPLICATE KEY UPDATE
    total_sessions = @new_sessions,
    updated_at = CURRENT_TIMESTAMP;

SELECT * FROM total_game_plays_monthly;
