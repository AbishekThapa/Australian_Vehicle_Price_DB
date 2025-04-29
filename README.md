# Australian Vehicle Price Database

## 🚗 Project Overview

This project contains a **Vehicle Price Database** designed to store and manage information about vehicle brands, models, locations, engine specifications, and inventory in Australia. The database structure ensures relational integrity using foreign key constraints, which helps in maintaining data consistency and reducing redundancy.

## 🌐 Data Source

__The database and all its data were downloaded from **[Kaggle](https://www.kaggle.com/datasets/nelgiriyewithana/australian-vehicle-prices/data)** for practice. On Kaggle, the data was originally provided in a single table format, which I then split into normalized tables to improve data integrity and reduce redundancy.__

- **Data Transformation**: I randomly generated `brand_id`, `model_id`, `location_id`, and `engine_id` for each record to normalize the data into separate tables. The `vehicle_id` was in serial number form, and I used **Microsoft Excel** to generate all the individual IDs to ensure that data was properly normalized.
- **Server**: I used **PostgreSQL** as the server and connected it through **VSCode** for convenience and efficient database management.

## 🏗️ Database Schema

### 1. **brands** 
Stores information about vehicle brands.

- `brand_id` (Primary Key)
- `brand_name`

### 2. **models** 
Stores details of vehicle models associated with a brand.

- `model_id` (Primary Key)
- `brand_id` (Foreign Key referencing `brands`)
- `model_name`

### 3. **locations** 
Stores location details where vehicles are available.

- `location_id` (Primary Key)
- `location_name`

### 4. **engine_specs** 
Contains engine specifications for the vehicles.

- `engine_id` (Primary Key)
- `cylinders`
- `engine_size`
- `fuel_type`
- `fuel_consumption`
- `transmission_type`

### 5. **vehicle_inventory** 
Tracks inventory data of vehicles, including price and specifications.

- `vehicle_id` (Primary Key)
- `model_id` (Foreign Key referencing `models`)
- `location_id` (Foreign Key referencing `locations`)
- `engine_id` (Foreign Key referencing `engine_specs`)
- `title`
- `year`
- `price`

## 📊 Data Analysis

The `Data_Analysis.sql` file contains a collection of SQL queries designed to extract insights from the Australian Vehicle Price Database. These queries help analyze vehicle pricing trends, brand performance, and other key metrics. Below are some of the highlights:

- **Average Vehicle Price by Brand**: Calculates the average price and total vehicles for each brand.
```sql
SELECT 
    b.brand_name,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM brands AS b
JOIN models AS m ON b.brand_id = m.brand_id
JOIN vehicle_inventory AS v ON m.model_id = v.model_id
GROUP BY b.brand_name
HAVING COUNT(v.vehicle_id) >= 5
ORDER BY average_price DESC;
```
- **Price Distribution by Year**: Analyzes price trends over the years 2000 to 2025.
```sql
SELECT
    year,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price)::numeric, 2) AS average_price,
    COUNT(vehicle_id) AS total_vehicles
FROM vehicle_inventory
WHERE year BETWEEN 2000 AND 2025
GROUP BY year
ORDER BY year;
```
- **Top 5 Most Expensive Models by Location**: Identifies the most expensive models in each location.
```sql
WITH ranked_vehicles AS (
    SELECT 
        l.location_name,
        b.brand_name,
        m.model_name,
        v.price,
        RANK() OVER (PARTITION BY l.location_name ORDER BY v.price DESC) AS price_rank
    FROM vehicle_inventory v
    JOIN models AS m ON v.model_id = m.model_id
    JOIN brands AS b ON m.brand_id = b.brand_id
    JOIN locations AS l ON v.location_id = l.location_id
    WHERE v.price IS NOT NULL
)
SELECT *
FROM ranked_vehicles
WHERE price_rank <= 5
ORDER BY location_name, price DESC;
```
- **Price vs. Fuel Type Comparison**: Compares average prices across different fuel types.
```sql
SELECT
    e.fuel_type,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM vehicle_inventory AS v
JOIN engine_specs AS e ON e.engine_id = v.engine_id
WHERE e.fuel_type IS NOT NULL
    AND e.fuel_type <> '-'
GROUP BY e.fuel_type
ORDER BY average_price DESC; 
```
- **Price Correlation with Engine Size**: Examines the relationship between engine size and price.
```sql
SELECT
    e.engine_size,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM engine_specs AS e
JOIN vehicle_inventory AS v ON e.engine_id = v.engine_id
WHERE e.engine_size IS NOT NULL
    AND e.engine_size NOT IN ('-', '0 L')
GROUP BY e.engine_size
ORDER BY engine_size; 
```
- **Regional Price Variation**: Analyzing price variations across different regions.
```sql
SELECT
    b.brand_name,
    m.model_name,
    l.location_name,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM vehicle_inventory AS v
JOIN models AS m ON m.model_id = v.model_id
JOIN locations AS l ON l.location_id = v.location_id
JOIN brands AS b ON b.brand_id = m.brand_id
GROUP BY b.brand_name, m.model_name, l.location_name
HAVING COUNT(v.vehicle_id) >= 3
ORDER BY b.brand_name, m.model_name, average_price DESC;
```

### How to Use
1. Open your SQL client or terminal connected to the database.
2. Execute the queries in `Data_Analysis.sql` to generate insights and reports.
3. Modify or extend the queries as needed to suit your analysis requirements.

## 📋 Import Data

To load data into the PostgreSQL database, follow the sequence below. Ensure you **import data in the correct order** to respect foreign key relationships.

### 📁 SQL Import File

I have also uploaded a SQL file for easy import. You can find it in the Main directory of this repository.

### ⚠️ IMPORTANT: Data Import Order

1. **brands.csv**: Contains brand data (no dependencies).
2. **models.csv**: Contains model data (depends on `brands.brand_id`).
3. **locations.csv**: Contains location data (no dependencies).
4. **engine_specs.csv**: Contains engine specification data (no dependencies).
5. **vehicle_inventory.csv**: Contains vehicle inventory data (depends on `models.model_id`, `locations.location_id`, and `engine_specs.engine_id`).

### 🔧 How to Import

1. Open `psql` in your terminal and connect to the database:
```bash
psql -d Australian_Vehicle_Price_DB
```

2. You can either:
   - Use the provided SQL file: `load_csv_file.sql`
   - Or use the following commands to import each CSV file individually:

```sql
-- Import Brands
\copy brands FROM '/path/to/brands.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Import Models
\copy models FROM '/path/to/models.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Import Locations
\copy locations FROM '/path/to/locations.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Import Engine Specs
\copy engine_specs FROM '/path/to/engine_specs.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Import Vehicle Inventory
\copy vehicle_inventory FROM '/path/to/vehicle_inventory.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
```

## 🧑‍💻 Troubleshooting Tips

- **Missing Foreign Keys**: Ensure that `brand_id` in `models.csv` exists in `brands.csv`. Similarly, `model_id`, `location_id`, and `engine_id` in `vehicle_inventory.csv` must exist in their respective tables.

- **Missing Data**: If you encounter issues like foreign key constraint errors, check for missing or mismatched data between CSVs.

- **Data Validation**: Before importing, open your CSVs and ensure:
  - There are no blank cells in required fields (use "NA" for placeholders).
  - Data is properly encoded in UTF-8 format.

- **Correct Delimiters**: Make sure CSV files use commas (`,`), not semicolons or tabs.

## 📄 Files Included

- **`brands.csv`**: Contains brand details.
- **`models.csv`**: Contains model details.
- **`locations.csv`**: Contains location details.
- **`engine_specs.csv`**: Contains engine specifications.
- **`vehicle_inventory.csv`**: Contains vehicle inventory details.
- **`import_script.sql`**: SQL script for easy database import.


### 📌 Note:

- Always maintain the data import sequence to ensure smooth import and relational integrity.
- This schema is optimized for vehicle price management, so avoid adding or changing the structure without considering dependencies.
