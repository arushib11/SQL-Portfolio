/*
Write a query that shows products from June 2nd, 2019 ('2019-06-02') with their price ranking within each store-category combination. Products with lower prices should get better (lower) ranks.
Required columns (in this exact order):
name_store (rename it to store_name)
category
date_upd (rename it to sale_date)
name (product name)
price
A ranking column called price_rank using the RANK() function
*/

/*
id_product	name	category	units	weight	price	date_upd	id_store	name_store
2	Shamrock Farms Rockin' Refuel Muscle Builder Chocolate Protein Milk Beverage, 12 oz	milk	oz	12	2.28	2019-06-01 00:00:00	0	Wise Penny
4	Мoo-Moo Select Ingredients Whole Milk, 1 pt	milk	pt		0.73	2019-06-01 00:00:00	0	Wise Penny
8	Nestle Nesquik Chocolate Lowfat Milk, 16 pk	milk	pk	16	11.49	2019-06-01 00:00:00	0	Wise Penny
9	Fairlife 2% Chocolate Reduced Fat Milk, 52 oz	milk	oz	52	3.18	2019-06-01 00:00:00	0	Wise Penny
10	Мoo-Moo Select Ingredients Lactose Free Fat Free Milk, 1/2 gal	milk	gal	0.5	2.96	2019-06-01 00:00:00	0	Wise Penny
*/


SELECT DISTINCT
    name_store AS store_name,
    category,
    date_upd AS sale_date,
    name,
    price,
    RANK() OVER (PARTITION BY name_store,category ORDER BY price) AS price_rank
FROM
    products_data_all
WHERE
    date_upd='2019-06-02'
ORDER BY
    store_name,category,price_rank
    
