-- =============================================
-- PAW CONNECT - Online Pet Purchase & Payment System
-- Database: pawconnect_db
-- =============================================

DROP DATABASE IF EXISTS pawconnect_db;
CREATE DATABASE pawconnect_db;
USE pawconnect_db;

-- =============================================
-- TABLE: admins
-- =============================================
CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(30) DEFAULT 'admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLE: users
-- =============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    profile_image VARCHAR(255) DEFAULT 'default-avatar.png',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLE: categories
-- =============================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABLE: pets
-- =============================================
CREATE TABLE pets (
    pet_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    breed VARCHAR(100),
    age VARCHAR(20),
    gender ENUM('Male', 'Female') NOT NULL,
    color VARCHAR(50),
    weight DECIMAL(5,2),
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    health_status VARCHAR(100) DEFAULT 'Healthy',
    vaccination_status BOOLEAN DEFAULT TRUE,
    location VARCHAR(100),
    image_url VARCHAR(255) DEFAULT 'default-pet.jpg',
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: pet_images
-- =============================================
CREATE TABLE pet_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: cart
-- =============================================
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    pet_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: wishlist
-- =============================================
CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    pet_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, pet_id)
);

-- =============================================
-- TABLE: orders
-- =============================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_address TEXT,
    shipping_city VARCHAR(50),
    shipping_state VARCHAR(50),
    shipping_pincode VARCHAR(10),
    order_status ENUM('Pending','Confirmed','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: order_items
-- =============================================
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    pet_id INT NOT NULL,
    pet_name VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: payments
-- =============================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('UPI','Credit Card','Debit Card','Net Banking','Wallet') NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    card_last_four VARCHAR(4),
    upi_id VARCHAR(100),
    payment_status ENUM('Pending','Success','Failed','Refunded') DEFAULT 'Pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: reviews
-- =============================================
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    pet_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: notifications
-- =============================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('Order','Payment','General','Promotion') DEFAULT 'General',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: pet_care_tips
-- =============================================
CREATE TABLE pet_care_tips (
    tip_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50),
    image_url VARCHAR(255),
    author VARCHAR(100) DEFAULT 'Paw Connect Team',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Admins (3 entries)
INSERT INTO admins (username, password, full_name, email, role) VALUES
('admin', 'admin123', 'Super Admin', 'admin@pawconnect.com', 'super_admin'),
('manager', 'manager123', 'Pet Manager', 'manager@pawconnect.com', 'admin'),
('support', 'support123', 'Support Staff', 'support@pawconnect.com', 'admin');

-- Categories (8 entries)
INSERT INTO categories (category_name, description, image_url) VALUES
('Dogs', 'Loyal and loving companions for families', 'dogs.jpg'),
('Cats', 'Independent and graceful feline friends', 'cats.jpg'),
('Birds', 'Colorful and melodious feathered pets', 'birds.jpg'),
('Fish', 'Beautiful aquatic pets for your home', 'fish.jpg'),
('Rabbits', 'Soft and cuddly small pets', 'rabbits.jpg'),
('Hamsters', 'Tiny adorable pocket pets', 'hamsters.jpg'),
('Turtles', 'Calm and long-living reptile pets', 'turtles.jpg'),
('Guinea Pigs', 'Friendly and social small pets', 'guinea_pigs.jpg');

-- Users (27 entries)
INSERT INTO users (full_name, email, password, phone, address, city, state, pincode) VALUES
('Rahul Sharma', 'rahul.sharma@email.com', 'pass123', '9876543210', '123 MG Road, Koramangala', 'Bangalore', 'Karnataka', '560034'),
('Priya Patel', 'priya.patel@email.com', 'pass123', '9876543211', '45 Jubilee Hills', 'Hyderabad', 'Telangana', '500033'),
('Amit Kumar', 'amit.kumar@email.com', 'pass123', '9876543212', '78 Connaught Place', 'New Delhi', 'Delhi', '110001'),
('Sneha Reddy', 'sneha.reddy@email.com', 'pass123', '9876543213', '12 Banjara Hills', 'Hyderabad', 'Telangana', '500034'),
('Vikram Singh', 'vikram.singh@email.com', 'pass123', '9876543214', '56 Civil Lines', 'Jaipur', 'Rajasthan', '302006'),
('Anjali Gupta', 'anjali.gupta@email.com', 'pass123', '9876543215', '89 Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010'),
('Karthik Nair', 'karthik.nair@email.com', 'pass123', '9876543216', '34 Marine Drive', 'Mumbai', 'Maharashtra', '400020'),
('Divya Iyer', 'divya.iyer@email.com', 'pass123', '9876543217', '67 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040'),
('Rajesh Verma', 'rajesh.verma@email.com', 'pass123', '9876543218', '90 Salt Lake', 'Kolkata', 'West Bengal', '700091'),
('Meera Joshi', 'meera.joshi@email.com', 'pass123', '9876543219', '23 FC Road', 'Pune', 'Maharashtra', '411004'),
('Suresh Babu', 'suresh.babu@email.com', 'pass123', '9876543220', '45 Whitefield', 'Bangalore', 'Karnataka', '560066'),
('Pooja Mishra', 'pooja.mishra@email.com', 'pass123', '9876543221', '12 Aundh', 'Pune', 'Maharashtra', '411007'),
('Arjun Das', 'arjun.das@email.com', 'pass123', '9876543222', '78 Park Street', 'Kolkata', 'West Bengal', '700016'),
('Lakshmi Menon', 'lakshmi.menon@email.com', 'pass123', '9876543223', '56 MG Road', 'Kochi', 'Kerala', '682016'),
('Nikhil Agarwal', 'nikhil.agarwal@email.com', 'pass123', '9876543224', '34 Hazratganj', 'Lucknow', 'Uttar Pradesh', '226001'),
('Ritu Saxena', 'ritu.saxena@email.com', 'pass123', '9876543225', '89 Malviya Nagar', 'Jaipur', 'Rajasthan', '302017'),
('Deepak Chauhan', 'deepak.chauhan@email.com', 'pass123', '9876543226', '12 Sector 17', 'Chandigarh', 'Punjab', '160017'),
('Swati Kulkarni', 'swati.kulkarni@email.com', 'pass123', '9876543227', '45 Dharampeth', 'Nagpur', 'Maharashtra', '440010'),
('Manoj Tiwari', 'manoj.tiwari@email.com', 'pass123', '9876543228', '78 Varanasi Cantt', 'Varanasi', 'Uttar Pradesh', '221002'),
('Kavitha Rao', 'kavitha.rao@email.com', 'pass123', '9876543229', '23 Jayanagar', 'Mysore', 'Karnataka', '570008'),
('Rohit Mehta', 'rohit.mehta@email.com', 'pass123', '9876543230', '56 CG Road', 'Ahmedabad', 'Gujarat', '380009'),
('Nandini Hegde', 'nandini.hegde@email.com', 'pass123', '9876543231', '89 Sadashivanagar', 'Bangalore', 'Karnataka', '560080'),
('Sanjay Dubey', 'sanjay.dubey@email.com', 'pass123', '9876543232', '12 MP Nagar', 'Bhopal', 'Madhya Pradesh', '462011'),
('Aisha Khan', 'aisha.khan@email.com', 'pass123', '9876543233', '34 Old City', 'Hyderabad', 'Telangana', '500002'),
('Vivek Jain', 'vivek.jain@email.com', 'pass123', '9876543234', '67 Mansarovar', 'Jaipur', 'Rajasthan', '302020'),
('Tanvi Deshmukh', 'tanvi.deshmukh@email.com', 'pass123', '9876543235', '90 Kothrud', 'Pune', 'Maharashtra', '411038'),
('Prakash Shetty', 'prakash.shetty@email.com', 'pass123', '9876543236', '23 Hampankatta', 'Mangalore', 'Karnataka', '575001');

-- Pets (32 entries)
INSERT INTO pets (pet_name, category_id, breed, age, gender, color, weight, price, description, health_status, vaccination_status, location, image_url) VALUES
-- Dogs (10)
('Buddy', 1, 'Golden Retriever', '2 years', 'Male', 'Golden', 30.00, 25000.00, 'Friendly and energetic Golden Retriever. Great with kids and other pets. Fully trained and house broken.', 'Excellent', TRUE, 'Bangalore', 'golden_retriever.jpg'),
('Bella', 1, 'Labrador Retriever', '1.5 years', 'Female', 'Chocolate', 28.00, 22000.00, 'Beautiful chocolate Labrador with a gentle temperament. Loves swimming and playing fetch.', 'Excellent', TRUE, 'Mumbai', 'labrador.jpg'),
('Max', 1, 'German Shepherd', '3 years', 'Male', 'Black & Tan', 35.00, 30000.00, 'Well-trained German Shepherd. Excellent guard dog and loyal companion. Knows basic commands.', 'Excellent', TRUE, 'Delhi', 'german_shepherd.jpg'),
('Daisy', 1, 'Beagle', '1 year', 'Female', 'Tricolor', 10.00, 18000.00, 'Adorable Beagle puppy with expressive eyes. Very playful and curious nature.', 'Good', TRUE, 'Pune', 'beagle.jpg'),
('Rocky', 1, 'Pomeranian', '8 months', 'Male', 'White', 3.50, 15000.00, 'Fluffy white Pomeranian. Small but full of personality. Perfect for apartment living.', 'Excellent', TRUE, 'Hyderabad', 'pomeranian.jpg'),
('Luna', 1, 'Siberian Husky', '2.5 years', 'Female', 'Grey & White', 25.00, 35000.00, 'Stunning Siberian Husky with blue eyes. Energetic and loves outdoor activities.', 'Excellent', TRUE, 'Bangalore', 'husky.jpg'),
('Bruno', 1, 'Pug', '1 year', 'Male', 'Fawn', 7.00, 12000.00, 'Cute little Pug with a wrinkly face. Very affectionate and loves to cuddle.', 'Good', TRUE, 'Chennai', 'pug.jpg'),
('Rosie', 1, 'Bulldog', '2 years', 'Female', 'White & Brown', 22.00, 28000.00, 'Gentle English Bulldog. Calm temperament, great for families. Low exercise needs.', 'Good', TRUE, 'Kolkata', 'bulldog.jpg'),
('Thor', 1, 'Rottweiler', '3 years', 'Male', 'Black & Mahogany', 45.00, 32000.00, 'Powerful and loyal Rottweiler. Well socialized and trained. Excellent protector.', 'Excellent', TRUE, 'Jaipur', 'rottweiler.jpg'),
('Coco', 1, 'Shih Tzu', '1.5 years', 'Female', 'Gold & White', 6.00, 20000.00, 'Beautiful Shih Tzu with long silky coat. Friendly, outgoing and loves attention.', 'Excellent', TRUE, 'Mumbai', 'shih_tzu.jpg'),

-- Cats (8)
('Whiskers', 2, 'Persian', '2 years', 'Male', 'White', 5.00, 18000.00, 'Gorgeous white Persian cat with blue eyes. Calm and regal personality. Loves being pampered.', 'Excellent', TRUE, 'Bangalore', 'persian_cat.jpg'),
('Mittens', 2, 'Siamese', '1 year', 'Female', 'Seal Point', 4.00, 15000.00, 'Elegant Siamese cat. Very vocal and affectionate. Bonds closely with her owner.', 'Good', TRUE, 'Delhi', 'siamese_cat.jpg'),
('Shadow', 2, 'Maine Coon', '3 years', 'Male', 'Brown Tabby', 8.00, 25000.00, 'Majestic Maine Coon with fluffy tail. Gentle giant who loves water and playing.', 'Excellent', TRUE, 'Mumbai', 'maine_coon.jpg'),
('Nala', 2, 'Bengal', '1.5 years', 'Female', 'Spotted', 5.50, 30000.00, 'Exotic Bengal cat with beautiful leopard-like spots. Active and intelligent.', 'Excellent', TRUE, 'Hyderabad', 'bengal_cat.jpg'),
('Oliver', 2, 'British Shorthair', '2 years', 'Male', 'Blue', 6.00, 22000.00, 'Charming British Shorthair with dense plush coat. Easy going and independent.', 'Good', TRUE, 'Pune', 'british_shorthair.jpg'),
('Lily', 2, 'Ragdoll', '1 year', 'Female', 'Blue Bicolor', 4.50, 28000.00, 'Docile and gentle Ragdoll cat. Goes limp when picked up. Perfect indoor companion.', 'Excellent', TRUE, 'Chennai', 'ragdoll.jpg'),
('Sphinx', 2, 'Sphynx', '2 years', 'Male', 'Pink', 4.00, 35000.00, 'Unique hairless Sphynx cat. Extremely affectionate and loves warmth. Hypoallergenic.', 'Good', TRUE, 'Bangalore', 'sphynx_cat.jpg'),
('Mochi', 2, 'Scottish Fold', '8 months', 'Female', 'Grey', 3.50, 32000.00, 'Adorable Scottish Fold with folded ears. Sweet and playful personality.', 'Excellent', TRUE, 'Delhi', 'scottish_fold.jpg'),

-- Birds (6)
('Kiwi', 3, 'Budgerigar', '1 year', 'Male', 'Green & Yellow', 0.03, 800.00, 'Cheerful little budgie. Can learn to talk and do tricks. Easy to care for.', 'Good', TRUE, 'Bangalore', 'budgie.jpg'),
('Sunny', 3, 'Cockatiel', '2 years', 'Female', 'Lutino', 0.09, 3500.00, 'Beautiful lutino cockatiel. Loves to whistle tunes and sit on your shoulder.', 'Excellent', TRUE, 'Mumbai', 'cockatiel.jpg'),
('Einstein', 3, 'African Grey Parrot', '5 years', 'Male', 'Grey', 0.40, 45000.00, 'Incredibly intelligent African Grey. Has vocabulary of 100+ words. Very social.', 'Excellent', TRUE, 'Hyderabad', 'african_grey.jpg'),
('Rio', 3, 'Macaw', '4 years', 'Male', 'Scarlet', 1.00, 55000.00, 'Magnificent Scarlet Macaw with vibrant plumage. Playful and loves interaction.', 'Excellent', TRUE, 'Delhi', 'macaw.jpg'),
('Peaches', 3, 'Lovebird', '6 months', 'Female', 'Peach-faced', 0.05, 2000.00, 'Sweet little lovebird. Best kept in pairs. Colorful and energetic.', 'Good', TRUE, 'Pune', 'lovebird.jpg'),
('Melody', 3, 'Canary', '1 year', 'Male', 'Yellow', 0.02, 1500.00, 'Beautiful singing canary. Fills your home with melodious songs every morning.', 'Excellent', TRUE, 'Chennai', 'canary.jpg'),

-- Fish (4)
('Goldie', 4, 'Goldfish', '6 months', 'Female', 'Orange', 0.01, 200.00, 'Classic orange goldfish. Hardy and easy to care for. Perfect starter pet.', 'Good', TRUE, 'Bangalore', 'goldfish.jpg'),
('Fighter', 4, 'Betta Fish', '1 year', 'Male', 'Blue & Red', 0.01, 500.00, 'Stunning male Betta with flowing fins. Vibrant colors that shimmer in light.', 'Excellent', TRUE, 'Mumbai', 'betta.jpg'),
('Nemo', 4, 'Clownfish', '8 months', 'Male', 'Orange & White', 0.01, 1200.00, 'Adorable clownfish. Needs saltwater tank. Very active and entertaining.', 'Good', TRUE, 'Hyderabad', 'clownfish.jpg'),
('Angel', 4, 'Angelfish', '1 year', 'Female', 'Silver & Black', 0.02, 800.00, 'Graceful freshwater angelfish. Beautiful long fins. Peaceful community fish.', 'Excellent', TRUE, 'Delhi', 'angelfish.jpg'),

-- Rabbits (2)
('Snowball', 5, 'Holland Lop', '6 months', 'Male', 'White', 1.80, 3500.00, 'Adorable white Holland Lop rabbit with floppy ears. Very gentle and loves to be held.', 'Good', TRUE, 'Bangalore', 'holland_lop.jpg'),
('Caramel', 5, 'Netherland Dwarf', '1 year', 'Female', 'Brown', 1.00, 4000.00, 'Tiny Netherland Dwarf rabbit. Super cute with small rounded ears. Very friendly.', 'Excellent', TRUE, 'Pune', 'netherland_dwarf.jpg'),

-- Hamsters (1)
('Nibbles', 6, 'Syrian Hamster', '4 months', 'Male', 'Golden', 0.15, 600.00, 'Cute golden Syrian hamster. Active at night. Loves running on his wheel.', 'Good', TRUE, 'Mumbai', 'hamster.jpg'),

-- Guinea Pig (1)
('Pepper', 8, 'Abyssinian Guinea Pig', '8 months', 'Female', 'Brown & White', 0.90, 1500.00, 'Friendly Abyssinian guinea pig with rosette fur. Very social and loves company.', 'Excellent', TRUE, 'Chennai', 'guinea_pig.jpg');

-- Orders (27 entries)
INSERT INTO orders (user_id, total_amount, shipping_address, shipping_city, shipping_state, shipping_pincode, order_status, order_date) VALUES
(1, 25000.00, '123 MG Road, Koramangala', 'Bangalore', 'Karnataka', '560034', 'Delivered', '2025-01-15 10:30:00'),
(2, 22000.00, '45 Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 'Delivered', '2025-01-20 14:15:00'),
(3, 30000.00, '78 Connaught Place', 'New Delhi', 'Delhi', '110001', 'Shipped', '2025-02-05 09:45:00'),
(4, 18000.00, '12 Banjara Hills', 'Hyderabad', 'Telangana', '500034', 'Delivered', '2025-02-10 16:20:00'),
(5, 35000.00, '56 Civil Lines', 'Jaipur', 'Rajasthan', '302006', 'Confirmed', '2025-02-18 11:00:00'),
(6, 15000.00, '89 Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010', 'Delivered', '2025-02-25 08:30:00'),
(7, 45000.00, '34 Marine Drive', 'Mumbai', 'Maharashtra', '400020', 'Shipped', '2025-03-01 13:45:00'),
(8, 28000.00, '67 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040', 'Delivered', '2025-03-08 10:10:00'),
(9, 12000.00, '90 Salt Lake', 'Kolkata', 'West Bengal', '700091', 'Pending', '2025-03-15 15:30:00'),
(10, 32000.00, '23 FC Road', 'Pune', 'Maharashtra', '411004', 'Delivered', '2025-03-20 09:00:00'),
(11, 20000.00, '45 Whitefield', 'Bangalore', 'Karnataka', '560066', 'Shipped', '2025-03-28 14:20:00'),
(12, 55000.00, '12 Aundh', 'Pune', 'Maharashtra', '411007', 'Confirmed', '2025-04-02 11:15:00'),
(13, 3500.00, '78 Park Street', 'Kolkata', 'West Bengal', '700016', 'Delivered', '2025-04-10 16:45:00'),
(14, 800.00, '56 MG Road', 'Kochi', 'Kerala', '682016', 'Delivered', '2025-04-15 08:00:00'),
(15, 25000.00, '34 Hazratganj', 'Lucknow', 'Uttar Pradesh', '226001', 'Shipped', '2025-04-22 12:30:00'),
(16, 18000.00, '89 Malviya Nagar', 'Jaipur', 'Rajasthan', '302017', 'Delivered', '2025-04-28 10:45:00'),
(17, 22000.00, '12 Sector 17', 'Chandigarh', 'Punjab', '160017', 'Pending', '2025-05-05 14:00:00'),
(18, 30000.00, '45 Dharampeth', 'Nagpur', 'Maharashtra', '440010', 'Confirmed', '2025-05-10 09:30:00'),
(19, 1500.00, '78 Varanasi Cantt', 'Varanasi', 'Uttar Pradesh', '221002', 'Delivered', '2025-05-15 11:20:00'),
(20, 35000.00, '23 Jayanagar', 'Mysore', 'Karnataka', '570008', 'Shipped', '2025-05-20 15:00:00'),
(21, 500.00, '56 CG Road', 'Ahmedabad', 'Gujarat', '380009', 'Delivered', '2025-05-25 08:45:00'),
(22, 4000.00, '89 Sadashivanagar', 'Bangalore', 'Karnataka', '560080', 'Delivered', '2025-05-30 13:10:00'),
(23, 28000.00, '12 MP Nagar', 'Bhopal', 'Madhya Pradesh', '462011', 'Confirmed', '2025-06-01 10:00:00'),
(24, 2000.00, '34 Old City', 'Hyderabad', 'Telangana', '500002', 'Delivered', '2025-06-05 16:30:00'),
(25, 15000.00, '67 Mansarovar', 'Jaipur', 'Rajasthan', '302020', 'Pending', '2025-06-10 09:15:00'),
(1, 18000.00, '123 MG Road, Koramangala', 'Bangalore', 'Karnataka', '560034', 'Delivered', '2025-06-15 14:45:00'),
(3, 35000.00, '78 Connaught Place', 'New Delhi', 'Delhi', '110001', 'Shipped', '2025-06-20 11:30:00');

-- Order Items (30 entries)
INSERT INTO order_items (order_id, pet_id, pet_name, price, quantity) VALUES
(1, 1, 'Buddy - Golden Retriever', 25000.00, 1),
(2, 2, 'Bella - Labrador Retriever', 22000.00, 1),
(3, 3, 'Max - German Shepherd', 30000.00, 1),
(4, 4, 'Daisy - Beagle', 18000.00, 1),
(5, 6, 'Luna - Siberian Husky', 35000.00, 1),
(6, 5, 'Rocky - Pomeranian', 15000.00, 1),
(7, 21, 'Einstein - African Grey Parrot', 45000.00, 1),
(8, 8, 'Rosie - Bulldog', 28000.00, 1),
(9, 7, 'Bruno - Pug', 12000.00, 1),
(10, 9, 'Thor - Rottweiler', 32000.00, 1),
(11, 10, 'Coco - Shih Tzu', 20000.00, 1),
(12, 22, 'Rio - Macaw', 55000.00, 1),
(13, 20, 'Sunny - Cockatiel', 3500.00, 1),
(14, 19, 'Kiwi - Budgerigar', 800.00, 1),
(15, 13, 'Shadow - Maine Coon', 25000.00, 1),
(16, 11, 'Whiskers - Persian', 18000.00, 1),
(17, 15, 'Oliver - British Shorthair', 22000.00, 1),
(18, 14, 'Nala - Bengal', 30000.00, 1),
(19, 24, 'Melody - Canary', 1500.00, 1),
(20, 17, 'Sphinx - Sphynx', 35000.00, 1),
(21, 26, 'Fighter - Betta Fish', 500.00, 1),
(22, 30, 'Caramel - Netherland Dwarf', 4000.00, 1),
(23, 16, 'Lily - Ragdoll', 28000.00, 1),
(24, 23, 'Peaches - Lovebird', 2000.00, 1),
(25, 5, 'Rocky - Pomeranian', 15000.00, 1),
(26, 12, 'Mittens - Siamese', 18000.00, 1),
(27, 6, 'Luna - Siberian Husky', 35000.00, 1),
(1, 19, 'Kiwi - Budgerigar', 800.00, 1),
(3, 20, 'Sunny - Cockatiel', 3500.00, 1),
(5, 23, 'Peaches - Lovebird', 2000.00, 1);

-- Payments (27 entries)
INSERT INTO payments (order_id, user_id, amount, payment_method, transaction_id, card_last_four, upi_id, payment_status, payment_date) VALUES
(1, 1, 25000.00, 'UPI', 'TXN20250115103001', NULL, 'rahul@upi', 'Success', '2025-01-15 10:30:01'),
(2, 2, 22000.00, 'Credit Card', 'TXN20250120141502', '4532', NULL, 'Success', '2025-01-20 14:15:02'),
(3, 3, 30000.00, 'Debit Card', 'TXN20250205094503', '8876', NULL, 'Success', '2025-02-05 09:45:03'),
(4, 4, 18000.00, 'Net Banking', 'TXN20250210162004', NULL, NULL, 'Success', '2025-02-10 16:20:04'),
(5, 5, 35000.00, 'UPI', 'TXN20250218110005', NULL, 'vikram@paytm', 'Success', '2025-02-18 11:00:05'),
(6, 6, 15000.00, 'Wallet', 'TXN20250225083006', NULL, NULL, 'Success', '2025-02-25 08:30:06'),
(7, 7, 45000.00, 'Credit Card', 'TXN20250301134507', '1234', NULL, 'Success', '2025-03-01 13:45:07'),
(8, 8, 28000.00, 'UPI', 'TXN20250308101008', NULL, 'divya@gpay', 'Success', '2025-03-08 10:10:08'),
(9, 9, 12000.00, 'Debit Card', 'TXN20250315153009', '5678', NULL, 'Pending', '2025-03-15 15:30:09'),
(10, 10, 32000.00, 'Net Banking', 'TXN20250320090010', NULL, NULL, 'Success', '2025-03-20 09:00:10'),
(11, 11, 20000.00, 'UPI', 'TXN20250328142011', NULL, 'suresh@phonepe', 'Success', '2025-03-28 14:20:11'),
(12, 12, 55000.00, 'Credit Card', 'TXN20250402111512', '9012', NULL, 'Success', '2025-04-02 11:15:12'),
(13, 13, 3500.00, 'Wallet', 'TXN20250410164513', NULL, NULL, 'Success', '2025-04-10 16:45:13'),
(14, 14, 800.00, 'UPI', 'TXN20250415080014', NULL, 'lakshmi@upi', 'Success', '2025-04-15 08:00:14'),
(15, 15, 25000.00, 'Debit Card', 'TXN20250422123015', '3456', NULL, 'Success', '2025-04-22 12:30:15'),
(16, 16, 18000.00, 'Net Banking', 'TXN20250428104516', NULL, NULL, 'Success', '2025-04-28 10:45:16'),
(17, 17, 22000.00, 'UPI', 'TXN20250505140017', NULL, 'deepak@gpay', 'Pending', '2025-05-05 14:00:17'),
(18, 18, 30000.00, 'Credit Card', 'TXN20250510093018', '7890', NULL, 'Success', '2025-05-10 09:30:18'),
(19, 19, 1500.00, 'Wallet', 'TXN20250515112019', NULL, NULL, 'Success', '2025-05-15 11:20:19'),
(20, 20, 35000.00, 'UPI', 'TXN20250520150020', NULL, 'kavitha@paytm', 'Success', '2025-05-20 15:00:20'),
(21, 21, 500.00, 'Debit Card', 'TXN20250525084521', '2345', NULL, 'Success', '2025-05-25 08:45:21'),
(22, 22, 4000.00, 'Net Banking', 'TXN20250530131022', NULL, NULL, 'Success', '2025-05-30 13:10:22'),
(23, 23, 28000.00, 'UPI', 'TXN20250601100023', NULL, 'sanjay@phonepe', 'Success', '2025-06-01 10:00:23'),
(24, 24, 2000.00, 'Credit Card', 'TXN20250605163024', '6789', NULL, 'Success', '2025-06-05 16:30:24'),
(25, 25, 15000.00, 'Wallet', 'TXN20250610091525', NULL, NULL, 'Pending', '2025-06-10 09:15:25'),
(26, 1, 18000.00, 'UPI', 'TXN20250615144526', NULL, 'rahul@gpay', 'Success', '2025-06-15 14:45:26'),
(27, 3, 35000.00, 'Debit Card', 'TXN20250620113027', '1122', NULL, 'Success', '2025-06-20 11:30:27');

-- Reviews (27 entries)
INSERT INTO reviews (user_id, pet_id, rating, review_text, created_at) VALUES
(1, 1, 5, 'Buddy is the best dog ever! Very friendly and well-behaved. My kids absolutely love him.', '2025-02-01 10:00:00'),
(2, 2, 4, 'Bella is a wonderful companion. She loves water and is great with other dogs.', '2025-02-05 14:00:00'),
(3, 3, 5, 'Max is incredibly loyal and protective. Best German Shepherd I have ever seen.', '2025-02-20 09:00:00'),
(4, 4, 4, 'Daisy is so cute and playful! She brings joy to our whole family.', '2025-02-25 16:00:00'),
(5, 6, 5, 'Luna is gorgeous with her blue eyes. Very energetic and loves long walks.', '2025-03-05 11:00:00'),
(6, 5, 3, 'Rocky is cute but very hyper. Needs a lot of grooming. Otherwise lovely pet.', '2025-03-10 08:00:00'),
(7, 21, 5, 'Einstein is truly the smartest bird! He already knows 50 words. Amazing!', '2025-03-20 13:00:00'),
(8, 8, 4, 'Rosie is so gentle and calm. Perfect for our small apartment.', '2025-03-25 10:00:00'),
(10, 9, 5, 'Thor is an incredible dog. Very well trained and loyal beyond measure.', '2025-04-05 09:00:00'),
(11, 10, 4, 'Coco is adorable and loves attention. Her coat is beautiful and silky.', '2025-04-10 14:00:00'),
(13, 20, 5, 'Sunny whistles beautifully! She learned our doorbell tune. So entertaining.', '2025-04-20 16:00:00'),
(14, 19, 4, 'Kiwi is a cheerful little budgie. Easy to care for and very friendly.', '2025-04-25 08:00:00'),
(15, 13, 5, 'Shadow is a majestic cat. He is huge but so gentle. Loves playing with water.', '2025-05-01 12:00:00'),
(16, 11, 4, 'Whiskers is beautiful but quite independent. Typical Persian behavior.', '2025-05-05 10:00:00'),
(17, 15, 3, 'Oliver is nice but a bit lazy. Does not play much. Good for quiet households.', '2025-05-15 14:00:00'),
(18, 14, 5, 'Nala is like having a mini leopard at home! So beautiful and active.', '2025-05-20 09:00:00'),
(19, 24, 4, 'Melody sings beautifully every morning. Wakes us up better than any alarm.', '2025-05-25 11:00:00'),
(20, 17, 5, 'Sphinx is unique and so affectionate. He always wants to be in your lap.', '2025-05-28 15:00:00'),
(21, 26, 4, 'Fighter is a beautiful betta. His colors are incredible. Easy to maintain.', '2025-06-01 08:00:00'),
(22, 30, 5, 'Caramel is the cutest rabbit ever! She loves being held and is very gentle.', '2025-06-05 13:00:00'),
(24, 23, 4, 'Peaches is lovely! So colorful and energetic. Best kept in pairs though.', '2025-06-10 16:00:00'),
(1, 12, 5, 'Mittens is very vocal and loving. She follows me everywhere. Wonderful cat!', '2025-06-20 10:00:00'),
(2, 16, 4, 'Lily goes completely limp when you pick her up. Such a unique and sweet cat.', '2025-06-22 14:00:00'),
(3, 18, 5, 'Mochi is absolutely adorable with her folded ears. So playful and sweet.', '2025-06-25 09:00:00'),
(5, 29, 4, 'Snowball is a fluffy bundle of joy. His floppy ears are irresistible!', '2025-06-28 11:00:00'),
(7, 25, 3, 'Goldie is a simple pet but my kids love watching her swim. Good starter pet.', '2025-07-01 08:00:00'),
(9, 31, 4, 'Nibbles is very active at night. Fun to watch on his wheel. Cute little guy.', '2025-07-05 15:00:00');

-- Notifications (28 entries)
INSERT INTO notifications (user_id, title, message, type, is_read, created_at) VALUES
(1, 'Order Confirmed', 'Your order #1 for Buddy has been confirmed and is being prepared for delivery.', 'Order', TRUE, '2025-01-15 10:31:00'),
(1, 'Payment Successful', 'Payment of ₹25,000 received via UPI for Order #1. Transaction ID: TXN20250115103001', 'Payment', TRUE, '2025-01-15 10:30:30'),
(2, 'Order Shipped', 'Your order #2 for Bella has been shipped. Expected delivery in 3-5 days.', 'Order', TRUE, '2025-01-22 09:00:00'),
(2, 'Order Delivered', 'Your order #2 has been delivered. Thank you for shopping with Paw Connect!', 'Order', TRUE, '2025-01-25 14:00:00'),
(3, 'Order Confirmed', 'Your order #3 for Max has been confirmed. We are preparing your furry friend!', 'Order', TRUE, '2025-02-05 09:46:00'),
(4, 'Welcome to Paw Connect!', 'Thank you for joining Paw Connect. Explore our amazing collection of pets!', 'General', TRUE, '2025-02-08 10:00:00'),
(5, 'New Arrivals!', 'Check out our new Siberian Husky puppies. Blue-eyed beauties waiting for you!', 'Promotion', FALSE, '2025-02-15 08:00:00'),
(6, 'Payment Successful', 'Payment of ₹15,000 received via Wallet for Order #6. Transaction ID: TXN20250225083006', 'Payment', TRUE, '2025-02-25 08:30:30'),
(7, 'Order Shipped', 'Your order #7 for Einstein has been shipped with special bird cage packaging.', 'Order', FALSE, '2025-03-03 09:00:00'),
(8, 'Order Delivered', 'Your order #8 for Rosie has been delivered. We hope she brings you joy!', 'Order', TRUE, '2025-03-12 14:00:00'),
(9, 'Payment Pending', 'Your payment for Order #9 is still pending. Please complete the payment.', 'Payment', FALSE, '2025-03-16 08:00:00'),
(10, 'Order Delivered', 'Thor has been delivered! Remember to schedule a vet visit within the first week.', 'Order', TRUE, '2025-03-25 10:00:00'),
(11, 'Special Offer!', 'Get 10% off on all cat accessories this weekend. Use code CATLOV10.', 'Promotion', FALSE, '2025-03-30 09:00:00'),
(12, 'Order Confirmed', 'Your order #12 for Rio the Macaw has been confirmed. Exotic beauty coming your way!', 'Order', TRUE, '2025-04-02 11:16:00'),
(13, 'Payment Successful', 'Payment of ₹3,500 received for Sunny. Enjoy your new feathered friend!', 'Payment', TRUE, '2025-04-10 16:46:00'),
(14, 'Pet Care Tip', 'New article: How to set up the perfect budgie cage. Read now on Paw Connect!', 'General', FALSE, '2025-04-18 08:00:00'),
(15, 'Order Shipped', 'Your order #15 for Shadow the Maine Coon is on its way!', 'Order', FALSE, '2025-04-24 09:00:00'),
(16, 'Order Delivered', 'Whiskers has arrived at your doorstep! Enjoy your new Persian companion.', 'Order', TRUE, '2025-05-02 14:00:00'),
(17, 'Payment Pending', 'Reminder: Please complete payment for Order #17 to confirm your purchase.', 'Payment', FALSE, '2025-05-07 08:00:00'),
(18, 'Order Confirmed', 'Your order for Nala the Bengal cat is confirmed. She will be with you soon!', 'Order', TRUE, '2025-05-10 09:31:00'),
(19, 'Order Delivered', 'Melody the Canary has been delivered. Enjoy her beautiful songs!', 'Order', TRUE, '2025-05-18 14:00:00'),
(20, 'Order Shipped', 'Your Sphynx cat order has been shipped with temperature-controlled packaging.', 'Order', FALSE, '2025-05-22 09:00:00'),
(21, 'Welcome Back!', 'We noticed you have not visited in a while. Check out our new fish collection!', 'Promotion', FALSE, '2025-05-28 10:00:00'),
(22, 'Order Delivered', 'Caramel the rabbit has arrived! Remember to keep her in a quiet space initially.', 'Order', TRUE, '2025-06-02 14:00:00'),
(23, 'Payment Successful', 'Payment of ₹28,000 received via UPI for your Ragdoll cat order.', 'Payment', TRUE, '2025-06-01 10:01:00'),
(24, 'Order Delivered', 'Your Lovebird Peaches has been delivered. Consider getting a companion bird!', 'Order', TRUE, '2025-06-08 14:00:00'),
(25, 'Payment Pending', 'Your wallet payment for Order #25 is pending. Please add funds and retry.', 'Payment', FALSE, '2025-06-11 08:00:00'),
(1, 'Flash Sale!', 'Flat 15% off on all bird species this weekend only! Limited stock available.', 'Promotion', FALSE, '2025-06-25 08:00:00');

-- Pet Care Tips (12 entries)
INSERT INTO pet_care_tips (title, content, category, image_url) VALUES
('How to Choose the Right Dog Breed', 'Choosing the right dog breed depends on your lifestyle, living space, and activity level. Active families should consider breeds like Labradors or Golden Retrievers. For apartment living, small breeds like Pugs or Shih Tzus are ideal. Research breed-specific health issues and grooming needs before making your decision.', 'Dogs', 'dog_breed_guide.jpg'),
('Essential Cat Care Tips for New Owners', 'New cat owners should ensure they have a litter box, scratching post, and proper food bowls ready. Cats need regular vet check-ups, proper nutrition, and mental stimulation. Provide climbing spaces and interactive toys. Remember, cats are independent but still need daily attention and love.', 'Cats', 'cat_care.jpg'),
('Setting Up Your First Aquarium', 'Start with a tank of at least 20 gallons for beginners. Cycle your tank for 4-6 weeks before adding fish. Invest in a good filter, heater, and thermometer. Test water parameters regularly. Start with hardy fish like guppies or tetras before moving to more sensitive species.', 'Fish', 'aquarium_setup.jpg'),
('Bird Nutrition: What to Feed Your Feathered Friend', 'A balanced bird diet includes quality seed mix, fresh fruits, and vegetables. Avoid avocado, chocolate, and caffeine as they are toxic to birds. Supplement with cuttlebone for calcium. Fresh water should be available at all times. Consult an avian vet for species-specific dietary needs.', 'Birds', 'bird_nutrition.jpg'),
('Vaccination Schedule for Puppies', 'Puppies need their first vaccines at 6-8 weeks of age, followed by boosters every 3-4 weeks until 16 weeks old. Core vaccines include Distemper, Parvovirus, Hepatitis, and Rabies. Non-core vaccines depend on your location and lifestyle. Keep a vaccination record and never miss scheduled boosters.', 'Dogs', 'puppy_vaccines.jpg'),
('Understanding Cat Body Language', 'A slowly blinking cat is showing affection. Flattened ears indicate fear or aggression. A raised tail means your cat is happy to see you. Kneading behavior shows comfort and contentment. Chattering at birds is a hunting instinct. Learn these signs to better communicate with your feline companion.', 'Cats', 'cat_language.jpg'),
('Rabbit Care 101: Housing and Diet', 'Rabbits need spacious enclosures with room to hop and stretch. Hay should make up 80% of their diet, supplemented with fresh vegetables and a small amount of pellets. They need exercise time outside their cage daily. Handle them gently and provide hiding spots for security.', 'Rabbits', 'rabbit_care.jpg'),
('Grooming Your Dog at Home', 'Regular grooming keeps your dog healthy and comfortable. Brush your dogs coat 2-3 times per week to prevent matting. Trim nails every 2-3 weeks. Clean ears weekly to prevent infections. Bathe your dog monthly or as needed. Use dog-specific shampoo and never human products.', 'Dogs', 'dog_grooming.jpg'),
('How to Train Your Parrot to Talk', 'Start training when your parrot is young and relaxed. Repeat simple words clearly and consistently. Use positive reinforcement with treats. Train for 10-15 minute sessions, multiple times daily. African Greys and Macaws are the best talkers. Be patient as it can take weeks to months for results.', 'Birds', 'parrot_training.jpg'),
('Hamster Care: Creating the Perfect Habitat', 'Choose a cage with at least 450 square inches of floor space. Provide a solid running wheel (not wire). Use paper-based bedding, not cedar or pine. Hamsters need hiding spots and tunnels. Feed a commercial hamster food mix supplemented with fresh vegetables. Clean the cage weekly.', 'Hamsters', 'hamster_habitat.jpg'),
('Signs Your Pet Needs a Vet Visit', 'Watch for these warning signs: loss of appetite, lethargy, vomiting or diarrhea, difficulty breathing, excessive thirst, sudden weight loss, lumps or bumps, limping, behavioral changes, and discharge from eyes or nose. Early detection of health issues can save your pets life and reduce treatment costs.', 'General', 'vet_visit.jpg'),
('Traveling with Your Pet: A Complete Guide', 'Prepare a pet travel kit with food, water, medications, and comfort items. Use a secure carrier or harness. Never leave pets in parked cars. For air travel, check airline pet policies well in advance. Ensure your pet has ID tags and is microchipped. Gradually acclimate your pet to travel.', 'General', 'pet_travel.jpg');

-- Additional pet images
INSERT INTO pet_images (pet_id, image_url, is_primary) VALUES
(1, 'golden_retriever_1.jpg', TRUE),
(1, 'golden_retriever_2.jpg', FALSE),
(2, 'labrador_1.jpg', TRUE),
(2, 'labrador_2.jpg', FALSE),
(3, 'german_shepherd_1.jpg', TRUE),
(3, 'german_shepherd_2.jpg', FALSE),
(4, 'beagle_1.jpg', TRUE),
(5, 'pomeranian_1.jpg', TRUE),
(6, 'husky_1.jpg', TRUE),
(6, 'husky_2.jpg', FALSE),
(7, 'pug_1.jpg', TRUE),
(8, 'bulldog_1.jpg', TRUE),
(9, 'rottweiler_1.jpg', TRUE),
(10, 'shih_tzu_1.jpg', TRUE),
(11, 'persian_1.jpg', TRUE),
(11, 'persian_2.jpg', FALSE),
(12, 'siamese_1.jpg', TRUE),
(13, 'maine_coon_1.jpg', TRUE),
(14, 'bengal_1.jpg', TRUE),
(14, 'bengal_2.jpg', FALSE),
(15, 'british_shorthair_1.jpg', TRUE),
(16, 'ragdoll_1.jpg', TRUE),
(17, 'sphynx_1.jpg', TRUE),
(18, 'scottish_fold_1.jpg', TRUE),
(19, 'budgie_1.jpg', TRUE),
(20, 'cockatiel_1.jpg', TRUE),
(21, 'african_grey_1.jpg', TRUE),
(22, 'macaw_1.jpg', TRUE),
(23, 'lovebird_1.jpg', TRUE),
(24, 'canary_1.jpg', TRUE),
(25, 'goldfish_1.jpg', TRUE),
(26, 'betta_1.jpg', TRUE);

-- Create indexes for better performance
CREATE INDEX idx_pets_category ON pets(category_id);
CREATE INDEX idx_pets_price ON pets(price);
CREATE INDEX idx_pets_location ON pets(location);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_reviews_pet ON reviews(pet_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_wishlist_user ON wishlist(user_id);

SELECT 'Paw Connect Database created successfully with all sample data!' AS Status;
