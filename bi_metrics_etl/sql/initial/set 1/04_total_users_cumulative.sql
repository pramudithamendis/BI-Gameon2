USE gaming_app_bi;

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_users_cumulative (date, value)
SELECT 
    date,
    SUM(value) OVER (ORDER BY date) AS value
FROM total_users_daily
WHERE date >= DATE(@cutoff)
ORDER BY date;