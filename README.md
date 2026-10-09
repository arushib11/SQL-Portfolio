# SQL Portfolio

SQL queries written for the SQL sprint of the TripleTen AI/ML Bootcamp. Each file starts with the business question as a comment, followed by the query that answers it.

| File | Business question | Techniques |
|---|---|---|
| [`01_cte_aggregation_authors.sql`](01_cte_aggregation_authors.sql) | Which authors with more than one book have an average rating above 4.0? | CTE, `GROUP BY`, `HAVING`, `COUNT` / `SUM` / `AVG` |
| [`02_window_functions_price_rank.sql`](02_window_functions_price_rank.sql) | How does each product's price rank within its store and category on a given day? | Window function `RANK() OVER (PARTITION BY … ORDER BY …)` |
| [`03_startup_investment_analysis.sql`](03_startup_investment_analysis.sql) | Four questions on a startup and venture-capital database (below) | `GROUP BY` / `HAVING`, `CASE`, joins, nested subqueries |

## 1. Authors with strong ratings

A CTE first summarizes each author (book count, total pages, average rating) and keeps only authors with more than one book. The main query then filters to an average rating above 4.0 and sorts by total pages.

**Why a CTE:** it separates "summarize per author" from "filter and sort the summary," so each step can be read and checked on its own.

## 2. Price rank within store and category

For one day, every product is ranked by price within its store-and-category group, cheapest first, using `RANK()`.

**Why a window function:** `GROUP BY` would collapse each group to one row. A window function keeps every product row and adds the rank beside it.

## 3. Startup investment analysis

Working across seven related tables (companies, funds, funding rounds, investments, acquisitions, people, education):

1. **Funding-round volatility.** For each date, the largest and smallest round raised, keeping only dates where the smallest is above zero and differs from the largest. Uses `GROUP BY` with `HAVING` on aggregates.
2. **Fund activity levels.** Each venture fund labeled high, middle or low activity by how many companies it invested in. Uses `CASE`.
3. **Strategy by activity level.** The average number of funding rounds per fund, by activity level, sorted ascending. Uses `CASE` inside a `GROUP BY` with `ROUND(AVG(...))`.
4. **Education at failed startups.** For companies that closed after a single funding round, the average number of degrees per employee. Joins `people` to `education` and filters through nested subqueries.

## What I would write differently today

- **Task 3.4** filters through three levels of nested subqueries. I would rewrite it as a chain of named CTEs (closed single-round companies, then their employees, then degrees per employee), which is easier to read and to test step by step.
- **Task 3.1** returns unnamed `MAX` and `MIN` columns. I would add aliases such as `max_raised` and `min_raised`.
- **Query 2** compares a timestamp column to a date string. That works when the timestamps are at midnight, as they are in the sample data, but a date range (`>= '2019-06-02' AND < '2019-06-03'`) is safer.

## Skills shown

Filtering and sorting · aggregation with `GROUP BY` and `HAVING` · conditional logic with `CASE` · joins across related tables · subqueries · common table expressions · window functions.
