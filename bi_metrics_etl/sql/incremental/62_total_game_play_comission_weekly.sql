SET @last_week := YEARWEEK(DATE_SUB(NOW(), INTERVAL 1 WEEK), 1);

INSERT INTO total_game_play_comission_weekly (
    year_week,
    week_start_date,
    week_end_date,
    base_amount_100pct,
    developer_share_50pct,
    tax_18pct,
    remainder_you_keep_32pct
)
SELECT
    YEARWEEK(gs.created_at, 1) AS year_week,
    MIN(DATE(gs.created_at)) AS week_start_date,
    MAX(DATE(gs.created_at)) AS week_end_date,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND YEARWEEK(gs.created_at, 1) = @last_week
GROUP BY year_week
ON DUPLICATE KEY UPDATE
    base_amount_100pct      = VALUES(base_amount_100pct),
    developer_share_50pct   = VALUES(developer_share_50pct),
    tax_18pct               = VALUES(tax_18pct),
    remainder_you_keep_32pct= VALUES(remainder_you_keep_32pct),
    week_start_date         = VALUES(week_start_date),
    week_end_date           = VALUES(week_end_date),
    updated_at              = CURRENT_TIMESTAMP;