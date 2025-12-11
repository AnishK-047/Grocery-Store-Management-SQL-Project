create database grocery_store;
use grocery_store;
-----------------------------------------------------------------------
-- 1. Supplier Table
create table if not exists supplier(
sup_id tinyint auto_increment primary key,
sup_name varchar(255),
address text
); 
-----------------------------------------------------------------------
-- 2. Categories Table
create table if not exists categories(
cat_id tinyint auto_increment primary key,
cat_name varchar(255)
);
-----------------------------------------------------------------------
-- 3. Employees Table
create table if not exists employees(
emp_id tinyint auto_increment primary key,
emp_name varchar(255),
hire_date date
);

alter table employees modify hire_date varchar(50);

set sql_safe_updates =1;

update employees
set hire_date =str_to_date(hire_date,'%m/%d/%Y');

update employees 
set emp_name = trim(replace(emp_name,'1',''));

SHOW TABLES;
SELECT * FROM employees LIMIT 10;
-----------------------------------------------------------------------
-- 4. Customers Table
create table if not exists customers (
cust_id smallint auto_increment primary key,
cust_name varchar(255),
address text
);
-----------------------------------------------------------------------
-- 5. Products Table
create table if not exists products(
prod_id tinyint auto_increment primary key,
prod_name varchar(255),
sup_id tinyint,
cat_id tinyint,
price decimal(10,2),
foreign key (sup_id) references supplier(sup_id)
      on update cascade on delete cascade,
foreign key (cat_id) references categories(cat_id)
      on update cascade on delete cascade
);

select * from PRODUCTS;
------------------------------------------------------------------------
-- 6. Order Table
create table if not exists orders(
ord_id smallint auto_increment primary key,
cust_id smallint,
emp_id tinyint,
order_date date,
foreign key (cust_id) references customers (cust_id)
      on update cascade on delete cascade,
foreign key (emp_id) references employees(emp_id)
	on update cascade on delete cascade
);
alter table orders modify order_date varchar(50);

set sql_safe_updates =0;

update orders
set order_date =str_to_date(order_date,'%m/%d/%Y');

select * from orders;
-----------------------------------------------------------------------
-- 7 Order_Details Table
create table if not exists Order_details(
ord_detID smallint auto_increment primary key,
ord_id smallint,
prod_id tinyint,
quantity tinyint,
each_price decimal(10,2),
total_price decimal(10,2),
foreign key (ord_id) references orders(ord_id)
	on update cascade on delete cascade,
foreign key (prod_id) references products(prod_id)
	on update cascade on delete cascade
);
select * from order_details;
---------------------------------------------------------------------------
-- Analysis Questions

-- 1️.  Customer Insights

-- Gain an understanding of customer engagement and purchasing behavior.
---------------------------------------------------------------------------
-- A. How many unique customers have placed orders?

select count(distinct cust_id) as unique_customers  from orders;
---------------------------------------------------------------------------
-- B. Which customers have placed the highest number of orders?

select c.cust_name,count(o.ord_id) as total_orders
from customers c
join orders o on c.cust_id = o.cust_id
group by c.cust_id
order by total_orders desc limit 1;
---------------------------------------------------------------------------
-- C. What is the total and average purchase value per customer?

select c.cust_name,
		sum(od.total_price) as total_purchase,
        avg(od.total_price) as avg_purchase
from customers c
join orders o on c.cust_id = o.cust_id
join order_details od on o.ord_id = od.ord_id
group by c.cust_id
order by total_purchase desc;
---------------------------------------------------------------------------

-- D. Who are the top 5 customers by total purchase amount?

select c.cust_name,sum(od.total_price) as total_purchase
from customers c
join orders o on c.cust_id = o.cust_id
join order_details od on o.ord_id = od.ord_id
group by c.cust_id
order by total_purchase desc
limit 5;
-------------------------------------------------------------------------------

-- 2. Product Performance

-- Evaluate how well products are performing in terms of sales and revenue.
-------------------------------------------------------------------------------
-- A. How many products exist in each category?

select cat.cat_name,count(p.prod_id) as product_count
from categories cat
left join products p on cat.cat_id = p.cat_id
group by cat.cat_id
order by product_count desc;
-------------------------------------------------------------------------------
-- B. What is the average price of products by category?

select cat.cat_name,avg(p.price) as avg_price
from categories cat
join products p on cat.cat_id = p.cat_id
group by cat.cat_id;

-------------------------------------------------------------------------------
-- C.  Which products have the highest total sales volume (by quantity)?

select p.prod_name,sum(od.quantity) as total_quantity_sold
from products p 
join order_details od on p.prod_id = od.prod_id
group by p.prod_id
order by total_quantity_sold desc limit 10;
--------------------------------------------------------------------------------
-- D. What is the total revenue generated by each product?

select p.prod_name,sum(od.total_price) as total_revenue
from products p
join order_details od on p.prod_id = od.prod_id
group by p.prod_id
order by total_revenue desc;
--------------------------------------------------------------------------------
-- E. How do product sales vary by category and supplier?

select cat.cat_name,s.sup_name,
		sum(od.total_price) as total_sales
from order_details od
join products p on od.prod_id = p.prod_id
join categories cat on p.cat_id = cat.cat_id
join supplier s on p.sup_id = s.sup_id
group by cat.cat_id,s.sup_id
order by total_sales desc;
--------------------------------------------------------------------------------
-- 3. Sales and Order Trends
-- Analyze business performance through orders and revenue over time.
--------------------------------------------------------------------------------
-- A. How many orders have been placed in total?

select count(*) as total_orders from orders;
--------------------------------------------------------------------------------
-- B. What is the average value per order?

select round(avg(order_total),2) as avg_order_value
from (
		select ord_id,sum(total_price) as order_total
        from order_details
        group by ord_id
)t;
--------------------------------------------------------------------------------
-- c. On which dates were the most orders placed?

select order_date,count(*) as order_count
from orders
group by order_date
order by order_count desc;

--------------------------------------------------------------------------------
-- D. What are the monthly trends in order volume and revenue?

select date_format(o.order_date,'%Y-%m') as month,
count(distinct o.ord_id) as total_orders,
sum(od.total_price) as total_revenue
from orders o
join order_details od on o.ord_id = od.ord_id
group by month
order by month;
--------------------------------------------------------------------------------
-- E. How do order patterns vary across weekdays and weekends?

select dayname(order_date) as day,
count(*) as total_orders
from orders
group by day
order by field(day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
--------------------------------------------------------------------------------
-- 4️. Supplier Contribution

-- Identify the most active and profitable suppliers.
--------------------------------------------------------------------------------
-- A. How many suppliers are there in the database?

select count(*) as  total_suppliers from supplier;
--------------------------------------------------------------------------------
-- B. Which supplier provides the most products?

select * from supplier;
select * from products;

select s.sup_name,count(p.prod_id) as product_count
from supplier s
join products p on s.sup_id =p.sup_id
group by s.sup_id
order by product_count desc;
--------------------------------------------------------------------------------
-- C. What is the average price of products from each supplier?

select s.sup_name,round(avg(p.price),2) as avg_price
from supplier s
join products p on s.sup_id=p.sup_id
group by s.sup_id;
--------------------------------------------------------------------------------
-- D. Which suppliers contribute the most to total product sales (by revenue)?

select * from order_details;

select s.sup_name,sum(od.total_price) as total_revenue
from supplier s
join products p on s.sup_id = p.sup_id
join order_details od on p.prod_id = od.prod_id
group by s.sup_id
order by total_revenue desc;
--------------------------------------------------------------------------------
-- 5️. Employee Performance

-- Assess how employees are handling and influencing sales.
--------------------------------------------------------------------------------
-- A. How many employees have processed orders?
select * from employees;

select count(distinct emp_id) as employees_involved from orders; 

--------------------------------------------------------------------------------
-- B. Which employees have handled the most orders?

select e.emp_name,count(o.ord_id) as total_orders
from employees e
join orders o on e.emp_id = o.emp_id
group by e.emp_id
order by total_orders desc;
--------------------------------------------------------------------------------
-- C. What is the total sales value processed by each employee?

select e.emp_name, sum(od.total_price) as total_sales
from employees e
join orders o on e.emp_id = o.emp_id
join order_details od on o.ord_id = od.ord_id
group by e.emp_id
order by total_sales desc;
--------------------------------------------------------------------------------
-- D. What is the average order value handled per employee?

select e.emp_name, round(avg(order_total),2) as avg_order_value
from employees e
join (
select o.emp_id, o.ord_id, sum(od.total_price) as order_total
from orders o
join order_details od on o.ord_id = od.ord_id
group by o.ord_id
)t on e.emp_id = t.emp_id
group by e.emp_id;
--------------------------------------------------------------------------------
-- 6️. Order Details Deep Dive

-- Explore item-level sales patterns and pricing behavior.
--------------------------------------------------------------------------------
-- A. What is the relationship between quantity ordered and total price?

select quantity,total_price from order_details;

-----------------------------------------------------------------------------------
-- B. What is the average quantity ordered per product?

select p.prod_name,round(avg(od.quantity),2) as avg_quantity
from products p
join order_details od on p.prod_id = od.prod_id
group by p.prod_id;
-----------------------------------------------------------------------------------
-- C. How does the unit price vary across products and orders?

select p.prod_name,od.each_price as order_unit_price,p.price as orginal_price
from products p
join order_details od on p.prod_id = od.prod_id;
-----------------------------------------------------------------------------------

select * from order_details;
select * from products;