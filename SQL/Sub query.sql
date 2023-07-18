WITH Y1718 AS(
    SELECT YEAR(order_date) [year]
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
)

select 
    ROW_NUMBER() OVER(ORDER BY so.order_id) AS NUM_OF_ORDER,
    so.order_id,
    YEAR(so.order_date) [Order_year],
    so.required_date,
    so.shipped_date,
    soi.item_id,
    soi.quantity,
    soi.list_price,
    soi.discount,
    ss.store_name,
    pp.product_name,
    pb.brand_name,
    pc.category_name,
    sc.*


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
WHERE ss.store_id = 1 AND YEAR(so.order_date) IN (2017,2018) AND so.shipped_date IS NOT NULL
ORDER BY order_date

