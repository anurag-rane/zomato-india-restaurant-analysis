# Zomato India — Restaurant Intelligence Analysis

## Business Problem

Bangalore's restaurant industry is one of the most competitive in India — 56,000+ listed restaurants across dozens of neighbourhoods, cuisines, and price points. For a new restaurant operator, the data holds answers to questions that directly determine success or failure:

- Which locations have the highest customer satisfaction but lowest restaurant density — signalling unmet demand?
- Which cuisines drive the best ratings and at what price points?
- Does offering online ordering or table booking correlate with higher ratings?
- What does a "best value" restaurant look like — high rating, accessible price?
- Which neighbourhoods are oversaturated vs underserved?

As a former restaurant founder, I approached this dataset with firsthand understanding of the operational drivers behind ratings, retention, and cost structure.

---

## 📊 Interactive Tableau Dashboard

**[View Live Dashboard on Tableau Public](https://public.tableau.com/app/profile/anurag.rane/viz/ZomatoRestaurantIntelligenceBangalore/ZomatoRestaurantIntelligence)**

The dashboard includes:
- **Rating Distribution** — bell curve of restaurant ratings across Bangalore
- **Top Locations** — highest rated neighbourhoods by avg rating
- **Cuisine Analysis** — volume vs rating by cuisine type (orange-blue diverging)
- **Price Segments** — cost tier vs avg rating correlation
- **Online Order Impact** — does online ordering correlate with better ratings?

All panels are connected to a single **Location filter** — select any neighbourhood to update all 5 charts simultaneously.

---

## Dataset

- **Source:** Zomato Bangalore Restaurants Dataset — [Kaggle](https://www.kaggle.com/datasets/himanshupoddar/zomato-bangalore-restaurants)
- **Volume:** 56,251 rows | 17 columns | deduplicated to 12,137 unique restaurant-location combinations
- **Coverage:** Bangalore, India — multiple neighbourhoods, cuisine types, and restaurant formats

| Column | Description |
|--------|-------------|
| name | Restaurant name |
| location | Neighbourhood / area |
| rate | Customer rating out of 5 |
| votes | Number of votes/reviews |
| cuisines | Cuisine type(s) |
| approx_cost(for two people) | Approximate cost for two (₹) |
| online_order | Whether online ordering is available (Yes/No) |
| book_table | Whether table booking is available (Yes/No) |
| rest_type | Restaurant type (Casual Dining, Café, Quick Bites, etc.) |

---

## SQL Analysis — 6 Sections, 20+ Queries

### Section I — Data Exploration & Cleaning
- Total restaurant count and null audit
- Unique location and restaurant type distribution
- Online order and table booking availability breakdown

### Section II — Ratings Analysis
- Overall rating distribution across all restaurants
- Average rating by location (top 10 neighbourhoods)
- Top 10 highest rated restaurants (min 100 votes)
- Rating vs online order availability

### Section III — Cuisine Analysis
- Top 15 most popular cuisines by restaurant count
- Top cuisines by average rating with cost context
- Cuisine distribution within top 5 locations

### Section IV — Cost Analysis
- Average cost for two by location
- Cost vs rating correlation — price segment analysis using CASE WHEN
- Best value restaurants — high rating (≥4.0), low cost (≤₹400)

### Section V — Location Intelligence
- Restaurant density + rating + cost + digital adoption by neighbourhood
- Underserved locations — high avg rating, low restaurant count
- Online ordering adoption rate by location

### Section VI — Advanced Analysis (CTEs & Window Functions)
- Location ranking by avg rating — RANK() window function
- Cuisine popularity ranking within each location — RANK() OVER PARTITION BY
- Restaurant performance tier classification — Elite / High Performer / Solid / Average
- Cost percentile ranking by location — PERCENT_RANK()

---

## Key Findings

- **Rajarajeshwari Nagar and Jayanagar** lead in avg rating among high-volume locations
- **Fine Dining (₹1000+)** rates highest at 3.97 — but only a small fraction of restaurants
- **Online ordering correlates with higher ratings** — Yes (3.65) vs No (3.59)
- **North Indian dominates volume** (200+ restaurants) but rates lower (3.58) — most saturated cuisine
- **Continental and Desserts** rate significantly higher despite lower volumes — less competition, higher quality
- **Rating bell curve peaks at 3.7–3.9** — most restaurants cluster in this range

---

## Actionable Recommendations

1. **Target underserved high-rating neighbourhoods** — strong demand signals with low competition
2. **Enable online ordering from day one** — positive correlation with ratings and visibility
3. **Fine dining or specialty cuisines offer better rating outcomes** — less competition, higher margins
4. **North Indian is safe for volume but hard to differentiate** — need strong execution to stand out
5. **Mid-range pricing (₹300–600) is the volume sweet spot** — most restaurants, most customers

---

## Tools Used

| Tool | Purpose |
|------|---------|
| SQL (MySQL) | Data cleaning, aggregations, CTEs, window functions |
| Tableau Public | Interactive 5-panel dashboard with location filter |

---

## SQL Techniques Demonstrated

- `REPLACE()` + `CAST()` for inline data cleaning
- `SUBSTRING_INDEX()` to extract primary cuisine from comma-separated values
- `CASE WHEN` for price segment bucketing and performance tier classification
- CTE for modular query structure
- `RANK() OVER (ORDER BY)` and `RANK() OVER (PARTITION BY)`
- `PERCENT_RANK()` for cost percentile analysis
- `HAVING` for post-aggregation filtering

---

## Files

```
zomato-india-restaurant-analysis/
│
├── README.md
├── zomato_restaurant_analysis.sql    ← 20+ queries across 6 sections
├── dashboard_preview.png             ← Dashboard screenshot
└── data/
    └── data_source.txt               ← Dataset reference
```

---

## About

As a former restaurant founder (The Bhookha Beirdo, 2015–2019), I built this analysis with a practitioner's lens — the questions here are ones I genuinely needed answers to when running a food business. The data confirms several intuitions and challenges a few assumptions about what drives restaurant success in a dense urban market.

**Author:** Anurag Rane
**LinkedIn:** [linkedin.com/in/anurag-rane-a2743aa9](https://linkedin.com/in/anurag-rane-a2743aa9)
**GitHub:** [github.com/anurag-rane](https://github.com/anurag-rane)
