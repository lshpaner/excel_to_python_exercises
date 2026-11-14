# Data Science Fundamentals: course map

10 weeks. Audience: beginners, business analysts, and managers with no coding background.
Modeled on the scope of UCLA Extension COM SCI X 450.00. One dataset all quarter: LA Metro Bike Share trips
for 2026 Q1 plus the station table. One running question: ridership is falling, what should Metro do?

Each chapter ships three things: a lecture (Excel workbook in chapters 1-3, Jupyter notebook in chapters 4-10),
a guided exercise worked in class, and a solo exercise due before the the next chapter.

| Chapter | Tool | Title | What students can do afterwards |
|---|---|---|---|
| 1 | Excel | Meet the data | Explain rows, columns, and data types; open the trip CSV; sort, filter, freeze panes; COUNTA, AVERAGE, MIN, MAX, MEDIAN |
| 2 | Excel | Summarize and compare | Build pivot tables (trips by day, hour, pass type); make a bar and a line chart; read a trend |
| 3 | Excel | Clean and join | Spot duplicates, blanks, and impossible values; XLOOKUP station names and regions onto trips; write a one-paragraph finding |
| 4 | Python | From cells to code | Run a notebook; variables, lists, functions; load the same CSV with pandas; `head`, `shape`, `describe` |
| 5 | Python | Filter, group, aggregate | Redo chapters 2-3 in pandas: boolean filters, `groupby`, `merge`; midterm (Excel to Python handoff) |
| 6 | Python | Visualize | matplotlib and seaborn: histograms, bar, line, small multiples; choose the chart for the question |
| 7 | Python | Statistics for decisions | Mean vs median, spread, distributions; compare pass types with a t-test; what a p-value does and does not say |
| 8 | Python | Regression | Daily trips as a function of weekday and week number; interpret coefficients; fitted vs actual |
| 9 | Python | Prediction | Logistic regression and a decision tree predicting monthly-pass trips; train/test split; accuracy and its limits |
| 10 | Python | Tell Metro | Final memo: evidence, chart, recommendation; present and critique |

## Grading

| Component | Weight | Notes |
|---|---|---|
| Weekly exercises | 50% | Solo exercise each week, chapters 1-9, equal weight |
| Midterm | 20% | Chapter 5, in class: reproduce an Excel analysis in pandas |
| Final memo | 30% | Chapter 10: two-page memo to Metro with one chart, plus a five-minute presentation |

## Data

- Trips: https://bikeshare.metro.net/about/data/ (one quarter, one row per trip: trip_id, duration in minutes, start_time, end_time, start_station, end_station, lat/lon, bike_id, plan_duration, trip_route_category, passholder_type, bike_type)
- Stations: same page, station table (station id, name, go-live date, region, status)
- Context for the running question: BTS monthly docked bikeshare releases, https://www.bts.gov/newsroom
