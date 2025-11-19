INSERT INTO total_records_cumulative (date_, total_records)
SELECT 
    d.date_,
    SUM(d.total_records) OVER (ORDER BY d.date_) AS total_records
FROM total_records_daily d
ORDER BY d.date_;