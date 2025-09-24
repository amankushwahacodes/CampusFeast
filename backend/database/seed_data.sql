-- Seed data for Campus Feast Database
USE campus_feast;

-- Insert sample users
INSERT INTO users (id, name, email, phone, campus_id, user_type, wallet_balance, password_hash) VALUES
('user1', 'John Student', 'john@campus.edu', '9876543210', 'CS2021001', 'student', 500.00, '$2b$10$example_hash_1'),
('user2', 'Jane Staff', 'jane@campus.edu', '9876543211', 'ST2021001', 'staff', 1000.00, '$2b$10$example_hash_2'),
('vendor1', 'Ballu Bhai', 'ballu@campus.edu', '9876543212', 'VD2021001', 'vendor', 0.00, '$2b$10$example_hash_3'),
('vendor2', 'South Corner Owner', 'south@campus.edu', '9876543213', 'VD2021002', 'vendor', 0.00, '$2b$10$example_hash_4'),
('vendor3', 'Quick Bites Owner', 'quick@campus.edu', '9876543214', 'VD2021003', 'vendor', 0.00, '$2b$10$example_hash_5'),
('vendor4', 'Spicy Corner Owner', 'spicy@campus.edu', '9876543215', 'VD2021004', 'vendor', 0.00, '$2b$10$example_hash_6'),
('admin1', 'Campus Admin', 'admin@campus.edu', '9876543216', 'AD2021001', 'admin', 0.00, '$2b$10$example_hash_7');

-- Insert sample vendors
INSERT INTO vendors (id, user_id, name, description, image, location, is_open, rating, review_count, opening_hours, vendor_type, specialties) VALUES
('1', 'vendor1', 'Ballu Bhai Canteen', 'Authentic North Indian food with the best tea on campus', 'https://pixabay.com/get/gdbcad6acde791c5a5adeaf9f02aa1cb609e50fe2dd0cc2e02dfacf0478ed5b54034103864acbdf9080c565ef76c5b2fb07ef99112d05353647955a826c56198b_1280.jpg', 'Main Building Ground Floor', TRUE, 4.5, 234, '7:00 AM - 8:00 PM', 'canteen', '["Tea", "Samosa", "Paratha", "Dal Rice"]'),
('2', 'vendor2', 'South Corner Stall', 'Crispy dosas and authentic South Indian breakfast', 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg', 'Engineering Block Canteen', TRUE, 4.3, 189, '6:30 AM - 11:00 AM, 4:00 PM - 7:00 PM', 'stall', '["Dosa", "Idli", "Vada", "Sambhar"]'),
('3', 'vendor3', 'Quick Bites Cafe', 'Fast food and quick snacks for busy students', 'https://pixabay.com/get/ga3ee3f3f776a0a8cbce52a83fb8a6f832216ac7d9ef936a9b0bb1542fc702f8db239c7f9e8384e4ee3f3291bb2e8fa93808860a234a51065d52545cebf661ff2_1280.jpg', 'Library Building', FALSE, 4.1, 156, '9:00 AM - 6:00 PM', 'cafe', '["Sandwich", "Burger", "Fries", "Cold Coffee"]'),
('4', 'vendor4', 'Spicy Corner', 'Chinese and Indo-Chinese specialties', 'https://pixabay.com/get/g5b45123dff23cd9e98bf1db31cf95c8ab2103289d03cbc2e0bc1e75723b4d0c515109afd46ca17af4edae9074d0a38d0249f1e095b20dd24cc926a55d6e11376_1280.jpg', 'Hostel Block Canteen', TRUE, 4.2, 278, '11:00 AM - 10:00 PM', 'stall', '["Noodles", "Fried Rice", "Manchurian", "Momos"]');

-- Insert sample menu items
INSERT INTO menu_items (id, vendor_id, name, description, image, price, wallet_discount, is_available, is_vegetarian, category, preparation_time) VALUES
-- Ballu Bhai Canteen items
('1', '1', 'Masala Tea', 'Hot and refreshing masala tea with perfect spice blend', 'https://pixabay.com/get/g019115e23d2bcc1932f736182fd228781e260f96c974a17d7979af09e90e9b4af473638deca9c5333873f5b0b0d30834b78e3bbc3077f83b1a325321faf3eff9_1280.jpg', 10.00, 1.00, TRUE, TRUE, 'beverages', 5),
('2', '1', 'Aloo Samosa', 'Crispy golden samosa filled with spiced potato', 'https://pixabay.com/get/gdbcad6acde791c5a5adeaf9f02aa1cb609e50fe2dd0cc2e02dfacf0478ed5b54034103864acbdf9080c565ef76c5b2fb07ef99112d05353647955a826c56198b_1280.jpg', 20.00, 2.00, TRUE, TRUE, 'snacks', 8),
('3', '1', 'Dal Rice', 'Homestyle dal with steamed rice and pickle', 'https://pixabay.com/get/ga99ba75deaf157b8d166045170acf1e187d63187ff2aacc3f5e745841bd9619ae6278e80601f70da2def782fe13576fb2e5f0fc4d97985f513c29f8c4c04136f_1280.jpg', 60.00, 5.00, TRUE, TRUE, 'meals', 15),

-- South Corner Stall items
('4', '2', 'Plain Dosa', 'Crispy South Indian crepe served with sambhar and chutney', 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg', 40.00, 3.00, TRUE, TRUE, 'meals', 12),
('5', '2', 'Masala Dosa', 'Dosa filled with spiced potato curry', 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg', 50.00, 4.00, TRUE, TRUE, 'meals', 15),

-- Quick Bites Cafe items
('6', '3', 'Veg Sandwich', 'Grilled sandwich with fresh vegetables and cheese', 'https://pixabay.com/get/ga3ee3f3f776a0a8cbce52a83fb8a6f832216ac7d9ef936a9b0bb1542fc702f8db239c7f9e8384e4ee3f3291bb2e8fa93808860a234a51065d52545cebf661ff2_1280.jpg', 45.00, 3.00, TRUE, TRUE, 'snacks', 10),
('7', '3', 'Veg Burger', 'Delicious vegetarian burger with crispy patty', 'https://pixabay.com/get/gd51567bab0da3b2cd0b02bb3afbc56a631b657a8ba5d18cbf69f0dd342ad6f650e561be1c8d590c08567497a82c8cb27117e00585ee6e5521a98a818b2b1f491_1280.jpg', 65.00, 5.00, FALSE, TRUE, 'fastFood', 15),

-- Spicy Corner items
('8', '4', 'Veg Hakka Noodles', 'Stir-fried noodles with fresh vegetables and sauces', 'https://pixabay.com/get/g5b45123dff23cd9e98bf1db31cf95c8ab2103289d03cbc2e0bc1e75723b4d0c515109afd46ca17af4edae9074d0a38d0249f1e095b20dd24cc926a55d6e11376_1280.jpg', 70.00, 6.00, TRUE, TRUE, 'meals', 18);

-- Insert sample orders
INSERT INTO orders (id, user_id, vendor_id, subtotal, discount, total, status, pickup_time, payment_method) VALUES
('ORD001', 'user1', '1', 40.00, 4.00, 36.00, 'ready', DATE_ADD(NOW(), INTERVAL 5 MINUTE), 'wallet'),
('ORD002', 'user1', '2', 40.00, 3.00, 37.00, 'completed', DATE_SUB(NOW(), INTERVAL 2 HOUR), 'wallet');

-- Insert sample order items
INSERT INTO order_items (order_id, menu_item_id, name, price, discount, quantity) VALUES
('ORD001', '1', 'Masala Tea', 10.00, 1.00, 2),
('ORD001', '2', 'Aloo Samosa', 20.00, 2.00, 1),
('ORD002', '4', 'Plain Dosa', 40.00, 3.00, 1);

-- Insert sample transactions
INSERT INTO transactions (user_id, order_id, transaction_type, amount, description, payment_method) VALUES
('user1', 'ORD001', 'debit', 36.00, 'Order payment - Ballu Bhai Canteen', 'wallet'),
('user1', 'ORD002', 'debit', 37.00, 'Order payment - South Corner Stall', 'wallet'),
('user1', NULL, 'credit', 500.00, 'Wallet top-up', 'admin_credit');
