
-- 0. Get all the users
SELECT * FROM customers;


-- Tasks
-- 1. Get all customers and their addresses.
SELECT * FROM "customers"
JOIN "addresses" ON "customers"."id" = "addresses"."customer_id";

--2. Get all orders and their line items (orders, quantity and product).
SELECT * FROM "orders"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id";

--3. Which warehouses have cheetos?
SELECT "warehouse"."warehouse" FROM "products"
JOIN "warehouse_product" ON "products"."id" = "warehouse_product"."product_id"
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
WHERE "products"."description" = 'cheetos'
;

--4. Which warehouses have diet pepsi?
SELECT "warehouse"."warehouse" FROM "products"
JOIN "warehouse_product" ON "products"."id" = "warehouse_product"."product_id"
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
WHERE "products"."description" = 'diet pepsi'
;

--5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers"."first_name" , "customers"."last_name", count("orders"."id") FROM "customers"
JOIN "addresses" ON "customers"."id" = "addresses"."customer_id"
JOIN "orders" ON "addresses"."id" = "orders"."address_id"
GROUP BY "customers"."first_name", "customers"."last_name"
;

--6. How many customers do we have?
SELECT count(id) FROM "customers";

--7. How many products do we carry?
SELECT count(id) FROM "products";

--8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM ("on_hand") AS "on_hand" FROM "products"
JOIN "warehouse_product" ON "products"."id" = "warehouse_product"."product_id"
WHERE "products"."description" = 'diet pepsi'
GROUP BY "id"
;

--## Stretch
--9. How much was the total cost for each order?
SELECT "orders"."id", SUM("unit_price") FROM "orders"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "orders"."id"
;

--10. How much has each customer spent in total?
SELECT "customers"."first_name", SUM("unit_price") FROM "customers"
JOIN "addresses" ON "customers"."id" = "addresses"."customer_id"
JOIN "orders" ON "addresses"."id" = "orders"."address_id"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "customers"."id"
;

--11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT "customers"."first_name",  COALESCE(SUM("unit_price"), 0) FROM "customers"
FULL JOIN "addresses" ON "customers"."id" = "addresses"."customer_id"
FULL JOIN "orders" ON "addresses"."id" = "orders"."address_id"
FULL JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
FULL JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "customers"."id"
;