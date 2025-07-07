SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY order_purchase_timestamp) AS row_num
FROM (
 SELECT
  o.order_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  
  -- customer
  c.customer_id,
  c.customer_city,
  c.customer_state,
  -- payment
  p.payment_type,
  p.payment_value,
  -- review
  r.review_score,
  -- item
  i.product_id,
  i.seller_id,
  i.price,
  i.freight_value,
  -- product
  pr.product_category_name,
  -- seller
  s.seller_city,
  s.seller_state

FROM
  `project-re-learning.Data1.orders` o

--JOIN TO ITEMS
LEFT JOIN `project-re-learning.Data1.order_items` i
      ON  o.order_id = i.order_id

--JOIN TO PAYMENTS
LEFT JOIN `project-re-learning.Data1.order_payments` p
      ON o.order_id = p.order_id

--JOIN TO REVIEWS
LEFT JOIN `project-re-learning.Data1.reviews` r
      ON o.order_id = r.order_id

--JOIN TO CUSTOMERS
LEFT JOIN `project-re-learning.Data1.Customers` c
      ON o.customer_id = c.customer_id

--JOIN TO PRODUCTS
LEFT JOIN `project-re-learning.Data1.products` pr
      ON i.product_id = pr.product_id

--JOIN TO SELLERS
LEFT JOIN `project-re-learning.Data1.sellers` s
      ON i.seller_id = s.seller_id

WHERE o.order_purchase_timestamp IS NOT NULL
  AND i.price IS NOT NULL
  AND p.payment_value IS NOT NULL
)
)
WHERE row_num = 1
