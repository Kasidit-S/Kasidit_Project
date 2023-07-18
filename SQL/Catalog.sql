SELECT ss.store_name AS Store,
    YEAR(so.order_date) [Year],
    SUM(soi.list_price*soi.quantity) AS Sales
FROM sales.stores AS ss
INNER JOIN sales.orders AS so
ON ss.store_id = so.store_id
INNER JOIN sales.order_items AS soi
ON so.order_id = soi.order_id
GROUP BY ss.store_name, YEAR(so.order_date)
ORDER BY ss.store_name DESC,YEAR(so.order_date)