USE gaming_app_bi;

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_users_weekly (week, value)
SELECT 
    DATE_FORMAT(CONVERT_TZ(u.created_at, '+00:00', '+08:00'), '%%x-W%%v') AS week,
    COUNT(*) AS value
FROM gaming_app_backend.`user` u
WHERE u.created_at >= @cutoff
GROUP BY week
ORDER BY week;