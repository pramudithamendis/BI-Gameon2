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

CREATE TABLE total_deposits_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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