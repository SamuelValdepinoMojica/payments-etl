-- Limpieza de tablas previas (Orden inverso por dependencias)
DROP TABLE IF EXISTS txn CASCADE;
DROP TABLE IF EXISTS terminal CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS account CASCADE;

-- 1. Tabla de Usuarios
CREATE TABLE account (
    account_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- 2. Tabla de Comercios
CREATE TABLE merchant (
    merchant_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50)
);

-- 3. Tabla de Terminales
CREATE TABLE terminal (
    terminal_id SERIAL PRIMARY KEY,
    merchant_id INT REFERENCES merchant(merchant_id),
    model VARCHAR(50)
);

-- 4. Tabla de Transacciones (Particionada por rango de fecha)
CREATE TABLE txn (
    txn_id SERIAL,
    account_id INT,
    terminal_id INT,
    amount DECIMAL(10, 2),
    created_at TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    PRIMARY KEY (txn_id, created_at)
) PARTITION BY RANGE (created_at);

-- Creación de particiones mensuales (Enero - Marzo 2025)
CREATE TABLE txn_2025_01 PARTITION OF txn FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
CREATE TABLE txn_2025_02 PARTITION OF txn FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');
CREATE TABLE txn_default PARTITION OF txn DEFAULT;

-- --- CARGA DE DATOS SINTÉTICOS (SEEDING) ---

-- Generar 100 Usuarios
INSERT INTO account (name, email)
SELECT 
    'Usuario ' || id, 
    'user' || id || '@example.com'
FROM generate_series(1, 100) AS id;

-- Generar 20 Comercios
INSERT INTO merchant (name, category)
SELECT 
    'Comercio ' || id, 
    CASE (id % 4) 
        WHEN 0 THEN 'Retail'
        WHEN 1 THEN 'Food'
        WHEN 2 THEN 'Electronics'
        ELSE 'Services'
    END
FROM generate_series(1, 20) AS id;

-- Generar 40 Terminales (2 por comercio aprox)
INSERT INTO terminal (merchant_id, model)
SELECT 
    (id % 20) + 1,
    'POS-X' || (id % 5)
FROM generate_series(1, 40) AS id;

-- Generar 1 Millón de Transacciones aleatorias
-- Rango de fechas: Enero y Febrero 2025 para probar particionamiento
INSERT INTO txn (account_id, terminal_id, amount, created_at, status)
SELECT 
    floor(random() * 100) + 1,           -- account_id (1-100)
    floor(random() * 40) + 1,            -- terminal_id (1-40)
    (random() * 1000)::decimal(10,2),    -- amount (0-1000)
    '2025-01-01'::timestamp + random() * (interval '59 days'), -- created_at
    CASE floor(random() * 3)
        WHEN 0 THEN 'approved'
        WHEN 1 THEN 'declined'
        ELSE 'pending'
    END
FROM generate_series(1, 1000000);