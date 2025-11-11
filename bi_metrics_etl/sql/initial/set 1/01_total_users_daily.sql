USE gaming_app_bi;

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_users_daily (date, value)
SELECT 
    DATE(CONVERT_TZ(u.created_at, '+00:00', '+08:00')) AS date,
    COUNT(*) AS value
FROM gaming_app_backend.`user` u
WHERE u.created_at >= @cutoff
GROUP BY date
ORDER BY date;