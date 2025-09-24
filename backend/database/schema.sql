-- Campus Feast Database Schema
-- MySQL Database for Flutter Food Ordering App

-- Create database
CREATE DATABASE IF NOT EXISTS campus_feast;
USE campus_feast;

-- Users table
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    campus_id VARCHAR(50) NOT NULL,
    user_type ENUM('student', 'staff', 'vendor', 'admin') NOT NULL DEFAULT 'student',
    wallet_balance DECIMAL(10,2) DEFAULT 0.00,
    profile_image VARCHAR(255) DEFAULT '',
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_user_type (user_type)
);

-- Vendors table
CREATE TABLE vendors (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    location VARCHAR(200) NOT NULL,
    is_open BOOLEAN DEFAULT TRUE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    opening_hours VARCHAR(100),
    vendor_type ENUM('canteen', 'stall', 'cafe', 'restaurant') NOT NULL,
    specialties JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_vendor_type (vendor_type),
    INDEX idx_is_open (is_open)
);

-- Menu items table
CREATE TABLE menu_items (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vendor_id VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    price DECIMAL(8,2) NOT NULL,
    wallet_discount DECIMAL(8,2) DEFAULT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    is_vegetarian BOOLEAN DEFAULT TRUE,
    category ENUM('beverages', 'snacks', 'meals', 'desserts', 'fastFood') NOT NULL,
    preparation_time INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    INDEX idx_vendor_id (vendor_id),
    INDEX idx_category (category),
    INDEX idx_is_available (is_available)
);

-- Orders table
CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    vendor_id VARCHAR(36) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('placed', 'accepted', 'preparing', 'ready', 'completed', 'rejected', 'cancelled') DEFAULT 'placed',
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pickup_time TIMESTAMP NULL,
    payment_method ENUM('wallet', 'upi', 'cash') DEFAULT 'wallet',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_vendor_id (vendor_id),
    INDEX idx_status (status),
    INDEX idx_order_time (order_time)
);

-- Order items table
CREATE TABLE order_items (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id VARCHAR(36) NOT NULL,
    menu_item_id VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    discount DECIMAL(8,2) DEFAULT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

-- Transactions table
CREATE TABLE transactions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    order_id VARCHAR(36) NULL,
    transaction_type ENUM('credit', 'debit', 'refund') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),
    payment_method ENUM('wallet', 'upi', 'cash', 'admin_credit') DEFAULT 'wallet',
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_transaction_type (transaction_type),
    INDEX idx_created_at (created_at)
);

-- Reviews table
CREATE TABLE reviews (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    vendor_id VARCHAR(36) NOT NULL,
    order_id VARCHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_order_review (user_id, order_id),
    INDEX idx_vendor_id (vendor_id),
    INDEX idx_rating (rating)
);

-- Pickup slots table
CREATE TABLE pickup_slots (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vendor_id VARCHAR(36) NOT NULL,
    slot_time TIME NOT NULL,
    max_orders INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    INDEX idx_vendor_id (vendor_id),
    INDEX idx_slot_time (slot_time)
);

-- Discounts table
CREATE TABLE discounts (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vendor_id VARCHAR(36) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(8,2) NOT NULL,
    min_order_amount DECIMAL(8,2) DEFAULT 0.00,
    max_discount_amount DECIMAL(8,2) DEFAULT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    usage_limit INT DEFAULT NULL,
    used_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    INDEX idx_vendor_id (vendor_id),
    INDEX idx_is_active (is_active),
    INDEX idx_dates (start_date, end_date)
);
