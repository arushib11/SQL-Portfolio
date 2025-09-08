/*
Write a query using a CTE to find authors who have published more than one book. 

In your CTE, calculate the total number of pages and average rating for each author. Then, in the main query, select authors who have an average rating above 4.0
and order them by the total number of pages in descending order. Display the author name, book count, total pages, and average rating.
*/

WITH author_metrics AS (
    SELECT 
        author,
        COUNT(*) AS book_count,
        SUM(pages) AS total_pages,
        AVG(rating) AS avg_rating
    FROM 
        books_all
    GROUP BY 
        author
    HAVING 
        COUNT(*)>1
)
SELECT 
    author,
    book_count,
    total_pages,
    avg_rating
FROM 
    author_metrics
WHERE 
    avg_rating>4.0
ORDER BY 
    total_pages DESC
;
