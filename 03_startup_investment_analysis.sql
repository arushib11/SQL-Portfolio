/*
Basic Task:

Your manager has assigned you a series of analysis tasks that will help shape our upcoming quarterly investment report.
You'll be working with these key tables:

1. company: Information about startups (funding, status, category)
2: fund Details about venture capital funds
3: funding_round Data on investment rounds
4: investment Records of specific investments
5: acquisition Information about company acquisitions
6: people Details about founders, employees, and investors
7: education Educational backgrounds
*/

/*
Task1: Funding Round Volatility Analysis
Our risk analysis team is examining volatility in funding rounds. They're specifically interested in dates where there was significant variation between the smallest and largest rounds. 
This indicates days when both very small and very large companies were receiving funding, which could signal unusual market activity. They also want to exclude days where some companies
received no funding at all, as that skews the analysis.
Create a table showing the highest and lowest amount of money raised for each date in the funding_round table. Include the dates in your results. 
The resulting table should only have records where the lowest value is not equal to zero or to the highest value.
*/
SELECT MAX(raised_amount), MIN(raised_amount),funded_at
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) <> 0 AND MIN(raised_amount)<> MAX(raised_amount)

/*
Fund Activity Classification
For our investor clients, understanding the activity level of different venture funds helps them identify potential co-investment partners. Funds that invest in many companies are often seen as having broader networks, while those with fewer investments might have deeper industry expertise. We need to categorize funds by their activity level to help our clients find appropriate partners.

Create a field with three categories:

high_activity — for funds that invest in a hundred or more companies
middle_activity — for funds that invest in between twenty (inclusive) to a hundred companies (exclusive)
low_activity — for funds that invest in fewer than twenty companies
Print all fields from the fund table and the new field with categories.
*/

SELECT *,
    CASE WHEN invested_companies>=100 THEN 'high_activity'
         WHEN invested_companies>=20 AND invested_companies<100 THEN 'middle_activity'
         WHEN invested_companies<20 THEN 'low_activity'
         END AS activity_level
FROM fund;


/*
Task: Investment Strategy by Fund Activity
Building on our fund activity classification, our research team wants to understand how a fund's investment approach changes based on its activity level. 
Specifically, we want to know if funds that invest in more companies tend to participate in more funding rounds per company. 
This will help our clients understand different fund strategies and how broadly or deeply funds typically engage with their portfolio companies.
For each activity category you assigned in the previous task, calculate the average number of funding rounds the fund participated in. Round it to the nearest whole number. 
Print the categories and the average number of funding rounds. Sort the table by the average in ascending order.
*/

SELECT 
    CASE WHEN invested_companies>=100 THEN 'high_activity'
         WHEN invested_companies>=20 AND invested_companies<100 THEN 'middle_activity'
         WHEN invested_companies<20 THEN 'low_activity'
         END AS activity_level,
    ROUND(AVG(investment_rounds),0)
FROM fund
GROUP BY activity_level
ORDER BY ROUND(AVG(investment_rounds),0);

/*
Final Task: Employee Education Impact on Startup Success
A heated debate has emerged among our clients about whether the educational background of startup employees correlates with company success. 
Some argue that highly educated teams are more likely to succeed, while others claim education has little impact. To settle this debate with data, we need to compare
the education levels of employees at successful companies versus those that closed after limited funding.
Steps followed:
We'll start by identifying companies that closed after just one funding round, then analyze the educational backgrounds of their employees.
First, make a list with the names of companies that closed down and had only one funding round while they existed.
Then, find the employees who worked at these companies and join with the education table to analyze their degree types.
Finally, calculate the average number of degrees per employee at these failed startups.
*/



SELECT AVG(count_degree) FROM(
    SELECT education.person_id,COUNT(education.degree_type) as count_degree
FROM education INNER JOIN people ON education.person_id=people.id 
WHERE people.id IN
    (SELECT id FROM people WHERE company_id IN(        
            SELECT id
            FROM company
            WHERE id IN(
                SELECT company_id 
                FROM funding_round
                WHERE is_first_round=1 AND is_last_round=1)
        AND status='closed'))
GROUP BY education.person_id   
) AS final;
