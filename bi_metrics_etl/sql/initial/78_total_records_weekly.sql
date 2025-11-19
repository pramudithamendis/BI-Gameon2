insert into total_records_weekly(year_week, total_records)
SELECT 
    YEARWEEK(ugp.created_at, 1) AS year_week,
	count(*) as total_records
FROM gaming_app_backend.user_game_pool ugp
WHERE ugp.user_game_pool_status = 4
  AND ugp.created_at > '2025-08-26'
  AND ugp.user NOT IN (SELECT user_id FROM gaming_app_backend.bot)
GROUP BY YEARWEEK(ugp.created_at, 1)
ON DUPLICATE KEY UPDATE 
    total_records = VALUES(total_records),
    updated_at = CURRENT_TIMESTAMP;