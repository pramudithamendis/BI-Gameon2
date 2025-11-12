-- Get yesterday's date in Singapore timezone (UTC+8)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_play_comission_daily (
    date_,
    base_amount_100pct,
    developer_share_50pct,
    tax_18pct,
    remainder_you_keep_32pct
)
SELECT
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs
       ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2
       ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs
       ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active, 1) = 1
  AND DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE
    base_amount_100pct = VALUES(base_amount_100pct),
    developer_share_50pct = VALUES(developer_share_50pct),
    tax_18pct = VALUES(tax_18pct),
    remainder_you_keep_32pct = VALUES(remainder_you_keep_32pct),
    updated_at = CURRENT_TIMESTAMP;