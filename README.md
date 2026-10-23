# 🍽️ Zomato Bangalore Restaurant Analysis

## 📌 Project Overview

This project analyzes Zomato restaurant data from Bangalore to understand
restaurant distribution across areas, pricing patterns, ratings, online
ordering and table booking, cuisine popularity, and restaurant type
performance.

**Workflow:** Raw Dataset → Python/Pandas (Google Colab) → MySQL → SQL
Analysis → Power BI Dashboard → Business Insights

## 🎯 Objectives

-   Identify areas with the most and the best-rated restaurants
-   Analyze the relationship between price and rating
-   Compare restaurants with and without online ordering and table booking
-   Find the most common and the best-rated cuisines
-   Compare restaurant types by cost and rating
-   Find the most popular restaurants by votes
-   Build an interactive Power BI dashboard

## 📂 Dataset

The project uses a Zomato Bangalore restaurants dataset containing
**51,717 raw records** and **15 original fields**. After cleaning and
removing duplicates, it contains **12,464 unique restaurants**.

Important fields include Name, Address, Location, Online Order, Book
Table, Rate, Votes, Restaurant Type, Cuisines, Dish Liked, Approx Cost
for Two People, Listed In (Type) and Listed In (City).

⚠️ **Limitations:** the dataset has no date column (no time trends), covers
Bangalore only, ratings are a single snapshot, and `dish_liked` is 54%
empty.

## 🛠️ Tools & Technologies

-   Python
-   Pandas
-   NumPy
-   Matplotlib
-   Google Colab
-   MySQL
-   MySQL Workbench
-   SQL
-   Power BI

## 🐍 Python Data Cleaning & Preparation

Python and Pandas were used to inspect, clean, and transform the
dataset.

### 🔍 Data inspection

``` python
df.shape
df.head()
df.info()
df.describe()
df.isnull().sum()
df.duplicated().sum()
```

### 🧹 Problems found and fixed

| Problem | Fix |
|---|---|
| `rate` stored as text (`4.1/5`, `NEW`, `-`) | Converted to numeric `rating`; `NEW` and `-` set to missing, `is_new_restaurant` flag kept |
| Cost stored as text with commas | Removed commas and converted to number |
| Broken characters (`CafÃ©`) nested several layers deep | Looped encoding fix |
| Same restaurant repeated for each listing type and area | Moved listing info to a separate table; kept one row per name + address |
| Missing values | Location filled from listing area, text columns labelled Unknown, cost filled with area median, rating left empty on purpose |
| Phone numbers with line breaks | Replaced with ` | ` |
| Multiple cuisines in one cell | Exploded into a separate `cuisines` table |
| Outliers in votes | Flagged with the IQR method, not removed |

### ❓ Missing values

Missing `cost_for_two` values were filled using the median cost of the
same location. Missing ratings were intentionally left empty, because
filling them would invent data and bias every average.

``` python
clean["cost_for_two"] = clean["cost_for_two"].fillna(
    clean.groupby("location")["cost_for_two"].transform("median"))
```

### 🏷️ Column standardization

Columns were renamed for SQL and Power BI compatibility, for example
`approx_cost(for two people)` to `cost_for_two`, `listed_in(type)` to
`listing_type`, and `listed_in(city)` to `listing_area`.

### ⚙️ Feature engineering

-   `price_category`: Budget, Mid, Premium, Luxury
-   `rating_category`: Poor, Average, Good, Excellent
-   `primary_cuisine`, `primary_rest_type`, `cuisine_count`
-   `is_high_votes_outlier`
-   `restaurant_id` to link the tables

### 🗃️ Output tables

Three tables were created from the cleaned data:

-   `restaurants`: one row per restaurant (12,464 rows)
-   `listings`: listing types and areas per restaurant (51,628 rows)
-   `cuisines`: one cuisine per row per restaurant (28,722 rows)

## 🗄️ MySQL Integration

The three cleaned CSV files were imported into the `zomato_db` database
using the MySQL Workbench Table Data Import Wizard.

``` sql
CREATE DATABASE zomato_db CHARACTER SET utf8mb4;
USE zomato_db;
```

Empty values were converted to real `NULL`, `rating` was converted to a
numeric type, and a primary key and indexes were added.

``` sql
UPDATE restaurants SET rating = NULL WHERE rating = '' OR rating = 'NaN';
ALTER TABLE restaurants MODIFY rating DOUBLE;
ALTER TABLE restaurants ADD PRIMARY KEY (restaurant_id);
CREATE INDEX idx_listings_rid ON listings (restaurant_id);
```

Row counts, missing values, duplicates, and orphan records were checked
after loading. One row (restaurant_id 3312) was skipped by the import
wizard, so SQL shows 12,463 restaurants while Power BI shows 12,464.

## 📊 SQL Analysis

The project contains **14 business questions**.

1.  **Total restaurants** --- counts all restaurants using `COUNT()`.
2.  **Top 10 areas by restaurant count** --- uses `GROUP BY`, `ORDER BY`
    and `LIMIT`.
3.  **Top 10 restaurants by votes** --- ranks restaurants by popularity.
4.  **Average rating and cost per area** --- uses `AVG()` and `HAVING` to
    keep areas with at least 20 restaurants.
5.  **Restaurants by price category** --- compares Budget, Mid, Premium
    and Luxury.
6.  **Online ordering vs rating** --- compares average rating for
    restaurants with 50 or more votes.
7.  **Rating bands** --- groups restaurants using `CASE WHEN`.
8.  **Top 10 cuisines** --- joins `cuisines` with `restaurants`.
9.  **Average rating per cuisine** --- uses a `JOIN` with a minimum sample
    size.
10. **Most common listing types** --- uses `COUNT(DISTINCT)` on
    `listings`.
11. **Rank restaurants within each area** --- uses the `RANK()` window
    function.
12. **Top 3 restaurants per area** --- uses a CTE and `ROW_NUMBER()`.
13. **Area share of all restaurants** --- calculates percentage using
    `SUM() OVER ()`.
14. **Areas with above-average cost** --- uses a subquery and `AVG()`.

Ratings are compared only for restaurants with **50 or more votes**, and
areas and cuisines need a minimum sample size, so small samples do not
distort results.

## 📈 Power BI Dashboard

The project includes an interactive **Zomato Bangalore Dashboard** 📊 with
three pages.

### 🔗 Data Model

`restaurants` is linked one-to-many to `listings` and `cuisines` on
`restaurant_id`.

### 🧮 DAX Measures

-   Total Restaurants
-   Avg Rating
-   Reliable Avg Rating (50+ votes)
-   Avg Cost for Two
-   Total Votes
-   Online Order %
-   Table Booking %
-   High Rated % (rating of 4.0 or more)

### 🎯 KPI Cards

-   🍴 **12.5K** --- Total Restaurants
-   ⭐ **3.62** --- Average Rating
-   💵 **₹487** --- Average Cost for Two
-   🛵 **52%** --- Online Order %

### 🖼️ Dashboard Visuals

**📄 Page 1: Overview**

-   Price category, online order and restaurant type slicers
-   Top 10 areas by number of restaurants
-   Restaurants by rating category
-   Share by price category

**📄 Page 2: Cuisines & Types**

-   Top 10 cuisines by number of restaurants
-   Average cost for two by restaurant type
-   Reliable average rating by restaurant type
-   Listing type slicer

**📄 Page 3: Area Deep-Dive**

-   Top areas by reliable average rating
-   Cost vs rating bubble chart by area
-   Top restaurants table (50+ votes)
-   Location slicer

### 💡 Dashboard Insights

-   📍 **Whitefield** has the most restaurants (885), followed by
    Electronic City and BTM.
-   🍔 **Quick Bites** are 41% of all restaurants.
-   💸 **41%** of restaurants are Budget and only **6%** are Luxury.
-   🏆 **Lavelle Road** and **Koramangala 5th Block** have the highest
    reliable area ratings (about 4.1).
-   🍰 **Dessert Parlors** and **Cafes** have the best ratings among
    restaurant types.
-   📊 Overall average rating is **3.62** and average cost for two is
    **₹487**.

## 💼 Business Insights

### 📍 Market Concentration

The top 5 areas hold about 30% of all restaurants, so dining supply is
heavily concentrated in a few hubs.

### 💰 Price and Rating

Luxury restaurants average a reliable rating of 4.16, compared with about
3.7 to 3.8 for other price bands. Across areas, average cost and rating
correlate at about 0.64.

### 📱 Table Booking and Online Ordering

Restaurants with table booking average 4.13 versus 3.75 without. Online
ordering shows no rating advantage once restaurants with fewer than 50
votes are excluded (3.79 with, 3.88 without). These are associations, not
proof of cause.

### 🍜 Cuisines

Japanese (4.21), Mediterranean (4.20) and European (4.19) cuisines rate
highest. Biryani is the 5th most common cuisine but rates low (3.52),
which suggests a crowded, mass-market segment.

### ⭐ Unrated Restaurants

24% of restaurants have no rating, and almost all of them have zero
votes, so they are mostly new or unreviewed listings.

📝 Full findings and recommendations are in
[reports/insights_and_recommendations.md](reports/insights_and_recommendations.md).

## 📁 Project Structure

``` text
zomato-bangalore-analysis/
│
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   ├── raw/
│   │   └── zomato_data.csv
│   └── cleaned/
│       ├── restaurants.csv
│       ├── listings.csv
│       └── cuisines.csv
├── notebooks/
│   ├── 01_data_inspection.ipynb
│   ├── 02_data_cleaning.ipynb
│   └── 03_eda.ipynb
├── sql/
│   ├── 01_setup.sql
│   ├── 02_data_checks.sql
│   └── 03_business_queries.sql
├── powerbi/
│   └── zomato_dashboard.pbix
├── images/
│   ├── dashboard_page1.png
│   ├── dashboard_page2.png
│   ├── dashboard_page3.png
│   └── data_model.png
└── reports/
    └── insights_and_recommendations.md
```

## 🧠 Skills Demonstrated

-   Python
-   Pandas
-   Data Cleaning
-   Exploratory Data Analysis
-   Feature Engineering
-   Handling Duplicates and Encoding Issues
-   MySQL
-   SQL
-   Aggregate Functions
-   Joins
-   Subqueries
-   CASE Statements
-   CTEs
-   Window Functions
-   Data Modelling
-   DAX
-   Power BI
-   Data Visualization
-   Business Analysis

## 🔄 Project Workflow

``` text
Zomato Raw Dataset
       ↓
Python / Pandas (Google Colab)
       ↓
Data Cleaning
       ↓
Feature Engineering
       ↓
MySQL
       ↓
SQL Business Analysis
       ↓
Power BI Dashboard
       ↓
Business Insights
```

## 👤 Author

**V. Lingamoorthy**

Data Analytics \| Python \| SQL \| Power BI

## ✅ Project Summary

This project demonstrates an end-to-end Data Analytics workflow, from
raw restaurant data through Python-based cleaning and feature
engineering, MySQL and SQL analysis, and Power BI visualization to
generate useful business insights for the Bangalore restaurant market.
