
select * from game_play_commission_referral_cumulative;

-- Seed the cumulative totals based on daily records
INSERT INTO game_play_commission_referral_cumulative(date_, game_play_commission)
SELECT 
    d.date_,
    SUM(d.game_play_commission) OVER (ORDER BY d.date_) AS game_play_commission
FROM game_play_commission_referral_daily d
ORDER BY d.date_;

select * from game_play_commission_referral_cumulative;