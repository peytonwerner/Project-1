-- 1.	What is the total_sales in dollars in each country. Order the results by the descending order of sales.
SELECT co.country_name, sum(s.quantity_sold) as "Total sales"
FROM SH.SALES s 
JOIN SH.CUSTOMERS cu ON cu.cust_id = s.cust_id
JOIN SH.COUNTRIES co ON co.country_id = cu.country_id
GROUP BY co.country_name
ORDER BY sum(s.quantity_sold) DESC
;

-- 2.	Display the no. of distinct promotions (use promo_id to count the distinct promotions) per country. Sort the results by the descending order of no. of distinct promotions.
SELECT co.country_name, count(DISTINCT pr.promo_id) as "No. of distinct promotions"
FROM SH.PROMOTIONS pr 
JOIN SH.SALES s ON pr.promo_ID = s.promo_ID
JOIN SH.CUSTOMERS cu ON cu.cust_id = s.cust_id
JOIN SH.COUNTRIES co ON co.country_id = cu.country_id
GROUP BY co.country_name
ORDER BY count(DISTINCT pr.promo_id) DESC
;


-- 3.	Write a query to identify the channel that received maximum sales (in dollars) in fiscal year 2000.
-- HINT: First print the total sales for each channel in 2000 as an inner query. Then write an outer query to print the channel with maximum sales in 2000.
SELECT ch1.channel_desc 
FROM SH.CHANNELS ch1 
JOIN SH.SALES s1 ON ch1.channel_id = s1.channel_id
JOIN SH.TIMES t1 ON t1.time_id = s1.time_id
WHERE t1.fiscal_year = '2000'
GROUP BY ch1.channel_desc 
HAVING sum(s1.amount_sold) = 
    ( 
    SELECT max(sum(s2.amount_sold)) 
    FROM SH.CHANNELS ch2 
    JOIN SH.SALES s2 ON ch2.channel_id = s2.channel_id
    JOIN SH.TIMES t2 ON t2.time_id = s2.time_id
    WHERE t2.fiscal_year = '2000'
    GROUP BY ch2.channel_desc 
    )
;


-- 4.	Display the products sold in Brazil in the fiscal year 1999. Print the product name only. Sort the results by product name. 
SELECT DISTINCT p.prod_name
FROM SH.PRODUCTS p JOIN SH.SALES s ON p.prod_id = s.prod_id
JOIN SH.CUSTOMERS cu ON cu.cust_id = s.cust_id
JOIN SH.COUNTRIES co ON co.country_id = cu.country_id
JOIN SH.TIMES t ON t.time_id = s.time_id
WHERE co.country_name = 'Brazil' AND t.fiscal_year = '1999'
ORDER BY p.prod_name
;

-- 5.	Display the top 10 customers sorted in descending order of the total amount of their purchase. 
-- Print their full name and the total amount and total quantity they purchased. 
-- Print the amount purchased rounded to the nearest integer and preceded by a $ sign.
SELECT DISTINCT cu.cust_first_name, cu.cust_last_name, 
'$' || ROUND(SUM(s.amount_sold )) as "Total amount of purchase", SUM(s.quantity_sold ) as "Total quantity purchased"
FROM SH.CUSTOMERS cu JOIN SH.SALES s ON s.cust_id = cu.cust_id
GROUP BY cu.cust_first_name , cu.cust_last_name
ORDER BY SUM(s.amount_sold ) DESC
FETCH NEXT 10 ROWS ONLY
;