CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    order_data JSONB NOT NULL,
    total DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS menu_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

INSERT INTO menu_items (name, price, category) VALUES
    ('Cheese Burger', 299, 'burger'),
    ('Margherita Pizza', 449, 'pizza'),
    ('Pasta Alfredo', 349, 'pasta'),
    ('Caesar Salad', 249, 'salad');