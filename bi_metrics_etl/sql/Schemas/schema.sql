-- Create table for daily totals
CREATE TABLE total_users_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create table for weekly totals
CREATE TABLE total_users_weekly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    week VARCHAR(10) NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create table for monthly totals
CREATE TABLE total_users_monthly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(10) NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

  ALTER TABLE total_users_daily ADD UNIQUE KEY idx_date (date);
  ALTER TABLE total_users_weekly ADD UNIQUE KEY idx_week (week);
  ALTER TABLE total_users_monthly ADD UNIQUE KEY idx_month (month);

  -- Create table for cumulative total users
CREATE TABLE total_users_cumulative (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

  ALTER TABLE total_users_cumulative ADD UNIQUE KEY idx_date (date);

  CREATE TABLE total_deposits_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 7
CREATE TABLE total_deposits_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 8
CREATE TABLE total_deposits_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 9
CREATE TABLE total_deposits_fiat_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 10
CREATE TABLE total_deposits_fiat_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 11
CREATE TABLE total_deposits_fiat_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 12
CREATE TABLE total_deposits_fiat_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 13
CREATE TABLE total_deposits_crypto_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 14
CREATE TABLE total_deposits_crypto_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 15
CREATE TABLE total_deposits_crypto_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 16
CREATE TABLE total_deposits_crypto_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 17
CREATE TABLE total_deposits_userwise_fiat_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 18
CREATE TABLE total_deposits_userwise_fiat_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 19
CREATE TABLE total_deposits_userwise_fiat_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 20
CREATE TABLE total_deposits_userwise_fiat_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 21
CREATE TABLE total_deposits_userwise_crypto_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 22
CREATE TABLE total_deposits_userwise_crypto_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 23
CREATE TABLE total_deposits_userwise_crypto_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 24
CREATE TABLE total_deposits_userwise_crypto_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 25
CREATE TABLE total_deposits_userwise_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 26
CREATE TABLE total_deposits_userwise_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 27
CREATE TABLE total_deposits_userwise_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 28
CREATE TABLE total_deposits_both_total_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 29
CREATE TABLE total_withdrawal_fiat_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 30
CREATE TABLE total_withdrawal_fiat_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 31
CREATE TABLE total_withdrawal_fiat_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 32
CREATE TABLE total_withdrawal_fiat_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 33
CREATE TABLE total_withdrawal_crypto_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 34
CREATE TABLE total_withdrawal_crypto_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 35
CREATE TABLE total_withdrawal_crypto_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 36
CREATE TABLE total_withdrawal_crypto_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 37
CREATE TABLE total_withdrawals_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 38
CREATE TABLE total_withdrawals_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 39
CREATE TABLE total_withdrawals_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 40
CREATE TABLE total_withdrawals_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 41
CREATE TABLE total_withdrawals_userwise_fiat_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 42
CREATE TABLE total_withdrawals_userwise_fiat_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 43
CREATE TABLE total_withdrawals_userwise_fiat_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 44
CREATE TABLE total_withdrawals_userwise_fiat_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 45
CREATE TABLE total_withdrawals_userwise_crypto_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 46
CREATE TABLE total_withdrawals_userwise_crypto_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 47
CREATE TABLE total_withdrawals_userwise_crypto_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 48
CREATE TABLE total_withdrawals_userwise_crypto_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 49
CREATE TABLE total_withdrawals_userwise_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    email VARCHAR(255) NOT NULL ,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE KEY unique_user_email (user_id, email,date_ )  -- ✅ Composite unique constraint
);

-- 50
CREATE TABLE total_withdrawals_userwise_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,week_label )
);

-- 51
CREATE TABLE total_withdrawals_userwise_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (user_id, email,month_ )
);

-- 52
CREATE TABLE total_withdrawals_userwise_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL unique,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 53
CREATE TABLE total_game_plays_daily(
    date_ DATE NOT NULL PRIMARY KEY unique,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 54
CREATE TABLE total_game_plays_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    week_start DATE NOT NULL unique,
    week_end DATE NOT NULL,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 55
CREATE TABLE total_game_plays_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique,   -- format: YYYY-MM
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 56
CREATE TABLE total_game_plays_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_sessions BIGINT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 57
CREATE TABLE total_game_plays_without_AI_and Train_With_AI_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_sessions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 58
CREATE TABLE total_game_play_pool_amount_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    coin_bet_amount DECIMAL(18, 2) NOT NULL,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 59
CREATE TABLE total_game_play_pool_amount_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    coin_bet_amount DECIMAL(10,2) NOT NULL,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email (date_, coin_bet_amount )
);


-- 60
CREATE TABLE total_game_play_comission_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    summary_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    base_amount_100pct DECIMAL(18,2) NOT NULL,
    developer_share_50pct DECIMAL(18,2) NOT NULL,
    tax_18pct DECIMAL(18,2) NOT NULL,
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 61
CREATE TABLE total_game_play_comission_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL unique,
    base_amount_100pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    developer_share_50pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    tax_18pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    remainder_you_keep_32pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 62
CREATE TABLE total_game_play_comission_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    year_week INT NOT NULL unique,                         -- e.g. 202540 (ISO week format)
    week_start_date DATE NOT NULL,                  -- Monday of the week
    week_end_date DATE NOT NULL,                    -- Sunday of the week

    base_amount_100pct DECIMAL(18,2) NOT NULL,      -- Total received_coins
    developer_share_50pct DECIMAL(18,2) NOT NULL,   -- 50% of base amount
    tax_18pct DECIMAL(18,2) NOT NULL,               -- 18% of base amount
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,-- Remaining 32%

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 63
  CREATE TABLE total_game_play_comission_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ CHAR(7) NOT NULL unique,  -- Format: YYYY-MM
    base_amount_100pct DECIMAL(18,2) NOT NULL,
    developer_share_50pct DECIMAL(18,2) NOT NULL,
    tax_18pct DECIMAL(18,2) NOT NULL,
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 64
CREATE TABLE 0.2_AI_matches_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 65
CREATE TABLE 0.2_AI_matches_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    player_name VARCHAR(150),
    player_email VARCHAR(150) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(date_,player_email)
);

-- 66
CREATE TABLE 0.2_AI_matches_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    week_label VARCHAR(10) NOT NULL ,        -- e.g. 2025-W05
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(week_label,player_email)
);


-- 67
CREATE TABLE 0.2_AI_matches_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL,                              -- Format: YYYY-MM
    player_id BIGINT NOT NULL,                              -- Reference to user table
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,   -- 0.20 per loss
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(month_,player_id)
   );

-- 68
CREATE TABLE old_AI_matches_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_ai_matches INT NOT NULL DEFAULT 0,
    total_player_wins INT NOT NULL DEFAULT 0,
    total_player_losses INT NOT NULL DEFAULT 0,
    total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 69
CREATE TABLE old_AI_matches_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    match_date DATE NOT NULL UNIQUE,  -- One row per day

    total_ai_matches INT NOT NULL DEFAULT 0,
    total_player_wins INT NOT NULL DEFAULT 0,
    total_player_losses INT NOT NULL DEFAULT 0,
    total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 70
CREATE TABLE old_AI_matches_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    year_ INT NOT NULL,
    week_number INT NOT NULL unique,
    total_ai_matches INT DEFAULT 0,
    total_player_wins INT DEFAULT 0,
    total_player_losses INT DEFAULT 0,
    total_spent_in_usd DECIMAL(12,2) DEFAULT 0,       
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 71
CREATE TABLE old_AI_matches_monthly (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
year_ INT NOT NULL,
month_number INT NOT NULL unique,
month_name VARCHAR(20) NOT NULL,
total_ai_matches INT NOT NULL DEFAULT 0,
total_player_wins INT NOT NULL DEFAULT 0,
total_player_losses INT NOT NULL DEFAULT 0,
total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 72
CREATE TABLE wallet_balance_cumulative(
    id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    total_balance BIGINT NOT NULL DEFAULT 0,
    total_hold BIGINT NOT NULL DEFAULT 0,
    available_balance BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- 73
CREATE TABLE wallet_balance_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),

    date_ DATE ,

    total_balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_hold DECIMAL(18,2) NOT NULL DEFAULT 0,
    available_balance DECIMAL(18,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,date_)
);

-- 74
CREATE TABLE wallet_balance_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    year_ INT ,
    week_number INT,
    week_label VARCHAR(10),         -- e.g. "2025-W06"
    total_balance DECIMAL(18,2) NOT NULL,    -- u.total_coins
    total_hold DECIMAL(18,2) NOT NULL,       -- SUM(uca.coins)
    available_balance DECIMAL(18,2) NOT NULL,-- total_balance - total_hold
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,week_label)
);


-- 75
CREATE TABLE wallet_balance_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id                BIGINT NOT NULL,
    email                  VARCHAR(255) NOT NULL,
    first_name             VARCHAR(150),
    last_name              VARCHAR(150),
    month_                  CHAR(7),             -- format: YYYY-MM
    total_balance          DECIMAL(18,2) NOT NULL,       -- u.total_coins
    total_hold             DECIMAL(18,2) NOT NULL,       -- SUM(uca.coins)
    available_balance      DECIMAL(18,2) NOT NULL,       -- total_balance - total_hold
    created_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,month_)
 );


