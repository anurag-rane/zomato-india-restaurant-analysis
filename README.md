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

## Dataset

- **Source:** Zomato Bangalore Restaurants Dataset — [Kaggle](https://www.kaggle.com/datasets/himanshupoddar/zomato-bangalore-restaurants)
- **Volume:** 56,251 restaurants | 17 columns
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
| listed_in(type) | Meal type listed under |
| listed_in(city) | City area listed under |

---

## SQL Analysis — 6 Sections, 20+ Queries

### Section I — Data Exploration & Cleaning
- Total restaurant count
- Null value audit across all key columns
- Unique location and restaurant type distribution
- Online order and table booking availability breakdown

### Section II — Ratings Analysis
- Overall rating distribution across all restaurants
- Average rating by location (top 10 neighbourhoods)
- Average rating by restaurant type
- Top 10 highest rated restaurants (min 100 votes)
- Rating vs online order availability — does it matter?

### Section III — Cuisine Analysis
- Top 15 most popular cuisines by restaurant count
- Top cuisines by average rating with cost context
- Cuisine distribution within top 5 locations

### Section IV — Cost Analysis
- Average cost for two by location — most to least expensive
- Cost vs rating correlation — price segment analysis
- Best value restaurants — high rating (≥4.0), low cost (≤₹400), verified votes

### Section V — Location Intelligence
- Restaurant density + rating + cost + digital adoption by neighbourhood
- Underserved locations — high avg rating but low restaurant count
- Online ordering adoption rate by location

### Section VI — Advanced Analysis (CTEs & Window Functions)
- Location ranking by avg rating using `RANK()` window function
- Cuisine popularity ranking within each location — CTE + `RANK() OVER PARTITION BY`
- Restaurant performance tier classification — Elite / High Performer / Solid / Average
- Cost percentile ranking by location using `PERCENT_RANK()`

---

## Key Findings

- **Indiranagar, Koramangala, and Whitefield** lead in restaurant density — highly competitive but also highest votes, indicating strong demand
- **Budget restaurants (< ₹300)** are the most common but don't necessarily rate highest — mid-range (₹300–600) shows the best rating-to-cost ratio
- **Online ordering correlates positively with ratings** — restaurants offering online delivery tend to have slightly higher average ratings, likely due to higher review volume
- **Several smaller neighbourhoods** (10–50 restaurants) show avg ratings ≥ 4.0 with high vote counts — signalling underserved high-demand areas worth targeting for new openings
- **North Indian and Chinese cuisines** dominate by volume but specialty cuisines (Continental, European) show higher average ratings at premium price points
- **Fine dining (₹1000+)** has the highest avg rating but the smallest restaurant count — low competition, high customer expectation

---

## Actionable Recommendations

1. **New restaurant operators should target underserved high-rating neighbourhoods** — areas with strong demand signals (high votes, high avg ratings) but fewer than 50 restaurants present a lower-competition entry point

2. **Enable online ordering from day one** — data shows a positive correlation between online delivery availability and ratings, likely driven by review volume and accessibility

3. **Mid-range pricing (₹300–600) offers the best return on satisfaction** — budget positioning risks margin compression while fine dining requires significant investment; mid-range hits the sweet spot

4. **North Indian remains the safest cuisine bet for volume** — but operators willing to offer Continental or specialty cuisines in premium locations can command better ratings and margins

5. **Table booking adoption is low overall** — restaurants that offer it tend to be in the premium segment; mid-range operators who add this feature can differentiate meaningfully

---

## Tableau Dashboard

📊 **[View Interactive Dashboard on Tableau Public]** *(link to be added after publishing)*

The dashboard visualises:
- Restaurant density heatmap by location
- Rating distribution across cuisine types
- Cost vs rating scatter plot by neighbourhood
- Online ordering adoption by area
- Performance tier breakdown

---

## Tools Used

| Tool | Purpose |
|------|---------|
| SQL (MySQL) | All analysis — joins, aggregations, CTEs, window functions, CASE WHEN, SUBSTRING_INDEX |
| Tableau Public | Interactive dashboard — location heatmap, cuisine ratings, cost analysis |

---

## SQL Techniques Demonstrated

- `REPLACE()` + `CAST()` for inline data cleaning (rate and cost columns)
- `SUBSTRING_INDEX()` to extract primary cuisine from comma-separated values
- `CASE WHEN` for price segment bucketing and performance tier classification
- `CTE` for modular, readable query structure
- `RANK() OVER (ORDER BY)` for overall rankings
- `RANK() OVER (PARTITION BY)` for within-group rankings
- `PERCENT_RANK()` for cost percentile analysis
- `HAVING` for post-aggregation filtering
- Subqueries for dynamic top-N filtering

---

## Files

```
zomato-india-restaurant-analysis/
│
├── README.md
├── zomato_restaurant_analysis.sql    ← 20+ queries across 6 sections
└── tableau/
    └── zomato_dashboard.twbx         ← Tableau workbook (to be added)
```

---

## About

As a former restaurant founder (The Bhookha Beirdo, 2015–2019), I built this analysis with a practitioner's lens — the questions here are ones I genuinely needed answers to when running a food business. The data confirms several intuitions and challenges a few assumptions about what drives restaurant success in a dense urban market.

**Author:** Anurag Rane
**LinkedIn:** [linkedin.com/in/anurag-rane-a2743aa9](https://linkedin.com/in/anurag-rane-a2743aa9)
**GitHub:** [github.com/anurag-rane](https://github.com/anurag-rane)
