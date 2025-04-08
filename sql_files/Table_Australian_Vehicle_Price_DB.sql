-- Drop in correct dependency order
DROP TABLE IF EXISTS vehicle_inventory;
DROP TABLE IF EXISTS engine_specs;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS models;
DROP TABLE IF EXISTS brands;

-- Brands table
CREATE TABLE brands (
    brand_id VARCHAR(12) PRIMARY KEY,
    brand_name VARCHAR(20) NOT NULL
);

-- Models table
CREATE TABLE models (
    model_id  VARCHAR(15) PRIMARY KEY,
    brand_id  VARCHAR(12),
    model_name VARCHAR(20) NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

-- Locations table
CREATE TABLE locations (
    location_id  VARCHAR(15) PRIMARY KEY,
    location_name  VARCHAR(30) NOT NULL
);

-- Engine Specs table
CREATE TABLE engine_specs (
    engine_id  VARCHAR(15) PRIMARY KEY,
    cylinders  VARCHAR(12),
    engine_size  VARCHAR(15),
    fuel_type VARCHAR(12),
    fuel_consumption  VARCHAR(20),
    transmission_type VARCHAR(20)
);

-- Vehicle Inventory table
CREATE TABLE vehicle_inventory (
    vehicle_id  VARCHAR(12) PRIMARY KEY,
    model_id VARCHAR(15) NOT NULL,
    location_id VARCHAR(15) NOT NULL,
    engine_id VARCHAR(15) NOT NULL,
    title VARCHAR(120),
    year INT,
    used_or_new VARCHAR(20) NOT NULL,
    vehicle_type VARCHAR(15),
    doors VARCHAR(12),
    seats VARCHAR(12),
    colour_ext_int VARCHAR(90),
    kilometres INT,
    price DECIMAL(10,2),
    FOREIGN KEY (model_id) REFERENCES models(model_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (engine_id) REFERENCES engine_specs(engine_id)
);


