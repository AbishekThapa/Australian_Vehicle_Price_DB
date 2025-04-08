--‼️⚠️MUST READ ⚠️‼️

/* 
You must import data in dependency order to respect foreign key relationships.

👨‍💻 STEP 1: Launch PostgreSQL and connect to the database:

    psql -d Australian_Vehicle_Price_DB

📂 STEP 2: Navigate to your CSV file directory:
Make sure all your CSVs are correctly

🧩 STEP 3: Import data in THIS STRICT ORDER:
⬇️⬇️⬇️
*/

-- 1️⃣ Brands: No dependencies
\copy brands FROM '/path/brands.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 2️⃣ Models: Depends on brands.brand_id
\copy models FROM '/path/models.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 3️⃣ Locations: No dependencies
\copy locations FROM '/path/locations.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 4️⃣ Engine Specs: No dependencies
\copy engine_specs FROM '/path/engine_specs.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 5️⃣ Vehicle Inventory: Depends on model_id, location_id, engine_id
\copy vehicle_inventory FROM '/path/vehicle_inventory.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

/*
✅ TIP: Before importing, make sure:
- All CSVs are UTF-8 encoded
- There are NO missing values in NOT NULL columns
- brand_id in models.csv EXISTS in brands.csv
- model_id, engine_id, and location_id in vehicle_inventory.csv EXIST in their respective tables

🧼 RECOMMENDED:
Use NA instead of blank cells in Excel for NOT NULL fields.

🆘 TROUBLESHOOT:
If you get a foreign key error, check:
SELECT * FROM models WHERE brand_id NOT IN (SELECT brand_id FROM brands);
*/
