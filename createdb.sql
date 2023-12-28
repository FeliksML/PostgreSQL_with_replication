CREATE SCHEMA store;
CREATE TABLE store.manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);

COPY store.manufacturers(manufacturer_name)
FROM '/etc/postgresql/init-script/csv/manufacturers.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

COPY store.categories( category_name )
FROM '/etc/postgresql/init-script/csv/categories.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.products (
    category_id BIGINT  NOT NULL,
    manufacturer_id BIGINT  NOT NULL,
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES store.categories (category_id),
    FOREIGN KEY (manufacturer_id) REFERENCES store.manufacturers (manufacturer_id)
);

COPY store.products(category_id, manufacturer_id, product_name)
FROM '/etc/postgresql/init-script/csv/products.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL
);

COPY store.stores(store_name)
FROM '/etc/postgresql/init-script/csv/stores.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_fname VARCHAR(100) NOT NULL,
    customer_lname VARCHAR(100) NOT NULL
);

COPY store.customers(customer_fname, customer_lname)
FROM '/etc/postgresql/init-script/csv/customers.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.price_change (
    product_id BIGINT NOT NULL PRIMARY KEY,
    price_change_ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES store.products (product_id)
);

COPY store.price_change(product_id, price_change_ts, new_price)
FROM '/etc/postgresql/init-script/csv/price_change.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.deliveries (
    store_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    delivery_date DATE NOT NULL,
    product_count BIGINT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store.stores (store_id),
    FOREIGN KEY (product_id) REFERENCES store.products (product_id)
);

COPY store.deliveries(store_id, product_id, delivery_date, product_count)
FROM '/etc/postgresql/init-script/csv/deliveries.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.purchases (
    store_id BIGINT NOT NULL,
    customer_id BIGINT  NOT NULL,
    purchase_id SERIAL PRIMARY KEY,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store.stores (store_id),
    FOREIGN KEY (customer_id) REFERENCES store.customers (customer_id)
);

COPY store.purchases(store_id, customer_id, purchase_date)
FROM '/etc/postgresql/init-script/csv/purchases.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE store.purchase_items (
    product_id BIGINT NOT NULL,
    purchase_id BIGINT  NOT NULL,
    product_count BIGINT NOT NULL,
    product_price NUMERIC(9,2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES store.products (product_id),
    FOREIGN KEY (purchase_id) REFERENCES store.purchases (purchase_id)
);

COPY store.purchase_items(product_id, purchase_id, product_count, product_price)
FROM '/etc/postgresql/init-script/csv/purchase_items.csv'
DELIMITER ',' CSV HEADER;

CREATE VIEW store_sales_summary AS
SELECT
    store_id,
    category_id,
    SUM(product_price * s.product_count) AS total_sales
FROM
    (SELECT * FROM store.products JOIN store.purchase_items USING (product_id)) s
JOIN
    store.deliveries USING (product_id)
GROUP BY
    store_id,
    category_id;
