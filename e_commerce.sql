CREATE DATABASE IF NOT EXISTS clothing_ecommerce;
USE clothing_ecommerce;
-- 1. brand table (clothing brands only)
CREATE TABLE brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. product_category table (clothing categories only)
CREATE TABLE product_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(id) ON DELETE SET NULL
);

-- 3. size_category table (clothing sizes only)
CREATE TABLE size_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. size_option table (clothing sizes)
CREATE TABLE size_option (
    id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    value VARCHAR(20) NOT NULL,
    description VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(id) ON DELETE CASCADE
);

-- 5. color table
CREATE TABLE color (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. product table (clothing only)
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES product_category(id) ON DELETE RESTRICT
);

-- 7. product_item table (clothing variants)
CREATE TABLE product_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    color_id INT,
    size_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(id) ON DELETE SET NULL
);

-- 8. product_image table
CREATE TABLE product_image (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_item_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_item_id) REFERENCES product_item(id) ON DELETE CASCADE
);

-- Add indexes for better performance
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_item_product ON product_item(product_id);
CREATE INDEX idx_product_item_color ON product_item(color_id);
CREATE INDEX idx_product_item_size ON product_item(size_id);
CREATE INDEX idx_product_image_item ON product_image(product_item_id);

-- Insert clothing-specific sample data
INSERT INTO brand (name, description) VALUES 
('Nike', 'American athletic apparel company'),
('Zara', 'Spanish fast fashion retailer'),
('Levi''s', 'American denim clothing brand');

INSERT INTO product_category (name, description) VALUES 
('T-Shirts', 'Casual short-sleeved shirts'),
('Jeans', 'Denim pants'),
('Dresses', 'Women''s dresses'),
('Jackets', 'Outerwear jackets');

INSERT INTO size_category (name, description) VALUES 
('Standard', 'Standard clothing sizes'),
('Women''s', 'Women''s specific sizing'),
('Men''s', 'Men''s specific sizing');

INSERT INTO size_option (size_category_id, value, description) VALUES 
(1, 'XS', 'Extra Small'),
(1, 'S', 'Small'),
(1, 'M', 'Medium'),
(1, 'L', 'Large'),
(1, 'XL', 'Extra Large'),
(2, '4', 'Women''s Size 4'),
(2, '6', 'Women''s Size 6'),
(3, '32', 'Men''s Waist 32"'),
(3, '34', 'Men''s Waist 34"');

INSERT INTO color (name, hex_code) VALUES 
('Red', '#FF0000'),
('Navy Blue', '#000080'),
('Black', '#000000'),
('White', '#FFFFFF'),
('Dark Wash', '#191970'),
('Light Wash', '#87CEFA');

-- Sample clothing products
INSERT INTO product (name, description, base_price, brand_id, category_id) VALUES 
('Classic T-Shirt', '100% cotton crew neck t-shirt', 24.99, 1, 1),
('Slim Fit Jeans', 'Stretch denim slim fit jeans', 59.99, 3, 2),
('Summer Dress', 'Lightweight floral summer dress', 39.99, 2, 3),
('Denim Jacket', 'Classic blue denim jacket', 79.99, 3, 4);

-- Sample clothing variants
INSERT INTO product_item (product_id, sku, price, quantity_in_stock, color_id, size_id) VALUES 
(1, 'NIK-TS-RED-S', 24.99, 100, 1, 2),
(1, 'NIK-TS-BLK-M', 24.99, 85, 3, 3),
(2, 'LEV-JN-DW-32', 59.99, 50, 5, 8),
(2, 'LEV-JN-DW-34', 59.99, 60, 5, 9),
(3, 'ZAR-DR-FL-4', 39.99, 30, NULL, 6),
(3, 'ZAR-DR-FL-6', 39.99, 25, NULL, 7),
(4, 'LEV-JK-BL-L', 79.99, 40, 2, 4);

-- Sample product images
INSERT INTO product_image (product_item_id, image_url, alt_text, is_primary) VALUES 
(1, 'https://example.com/nike-tshirt-red.jpg', 'Nike Classic T-Shirt Red', TRUE),
(2, 'https://example.com/nike-tshirt-black.jpg', 'Nike Classic T-Shirt Black', TRUE),
(3, 'https://example.com/levis-jeans-darkwash.jpg', 'Levi''s Slim Fit Jeans Dark Wash', TRUE),
(7, 'https://example.com/levis-jacket-blue.jpg', 'Levi''s Denim Jacket Navy Blue', TRUE);
