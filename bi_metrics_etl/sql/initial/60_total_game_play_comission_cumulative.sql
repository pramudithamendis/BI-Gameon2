insert into total_game_play_comission_cumulative(date_,base_amount_100pct,
developer_share_50pct,
tax_18pct,
remainder_you_keep_32pct)
SELECT
     d.date_,
     SUM(d.base_amount_100pct) OVER (ORDER BY d.date_) AS base_amount_100pct,                                        
     SUM(d.developer_share_50pct) OVER (ORDER BY d.date_) AS developer_share_50pct,                                        
     SUM(d.tax_18pct) OVER (ORDER BY d.date_) AS tax_18pct,                                        
     SUM(d.remainder_you_keep_32pct) OVER (ORDER BY d.date_) AS remainder_you_keep_32pct                                        
FROM total_game_play_comission_daily d
ORDER BY d.date_;