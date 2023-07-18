select 
    pb.brand_name,
    COUNT(soi.list_price) AS count,
    SUM(soi.list_price) AS total,
    MIN(soi.list_price) AS min,
    MAX(soi.list_price) AS max,
    AVG(soi.list_price) AS mean


FROM production.products AS pp
INNER JOIN production.categories AS pc
ON pp.category_id = pc.category_id
INNER JOIN production.brands AS pb
ON pp.brand_id = pb.brand_id
INNER JOIN production.stocks AS ps
ON pp.product_id = ps.product_id
INNER JOIN sales.stores AS ss
ON ps.store_id = ss.store_id
INNER JOIN sales.orders AS so
ON ss.store_id = so.store_id
INNER JOIN sales.customers AS sc
ON so.customer_id = sc.customer_id
INNER JOIN sales.order_items AS soi
ON pp.product_id = soi.product_id AND so.order_id = soi.order_id
INNER JOIN sales.staffs AS sst
ON so.staff_id = sst.staff_id
GROUP BY pb.brand_name
ORDER BY total DESC