
insert into total_game_play_comission_monthly(month_,base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
SELECT
DATE_FORMAT(gs.created_at, '%%Y-%%m') AS month_,
SUM(pc.received_coins) AS base_amount_100pct,
0.50 * SUM(pc.received_coins) AS developer_share_50pct,
0.18 * SUM(pc.received_coins) AS tax_18pct,
0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND gs.created_at >= '2025-09-27'
GROUP BY DATE_FORMAT(gs.created_at, '%%Y-%%m')
ORDER BY DATE_FORMAT(gs.created_at, '%%Y-%%m') DESC;