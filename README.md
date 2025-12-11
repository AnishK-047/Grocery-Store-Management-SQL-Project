# 🛒 Grocery Store Management – SQL Project

A complete SQL project where I designed and implemented a relational database for a grocery store.  
This project covers database design, data cleaning, complex SQL querying, and business insights generation.

---

## 📌 Project Overview
This project simulates the backend data system of a grocery store. It includes:

- Designing **7 relational tables** (customers, orders, products, suppliers, categories, employees, order details)
- Cleaning inconsistent date formats and text fields
- Writing SQL queries for:
  - Customer behavior analysis
  - Product performance
  - Supplier contribution
  - Employee performance
  - Sales trends & revenue insights

The project demonstrates real-world SQL skills including joins, aggregations, subqueries, constraints, and trend analysis.

---

## 🗂️ Database Schema

### **Tables Included**
1. `supplier`
2. `categories`
3. `employees`
4. `customers`
5. `products`
6. `orders`
7. `order_details`

### **Key Relationships**
- One supplier → many products  
- One category → many products  
- One customer → many orders  
- One employee → many orders  
- One order → many order details  

Foreign keys were implemented with **cascade update/delete**.

---

## 🛠️ Tech Stack
- **MySQL**
- SQL Joins, Subqueries, Aggregations  
- Data Cleaning using SQL  
- Date Formatting  
- Business Analytics

---

## 🧹 Data Cleaning Performed

Examples:

```sql
-- Fix inconsistent hire_date formats
update employees
set hire_date = str_to_date(hire_date, '%m/%d/%Y');

-- Remove unwanted characters from employee names
update employees 
set emp_name = trim(replace(emp_name,'1',''));

-- Clean order dates
update orders
set order_date = str_to_date(order_date, '%m/%d/%Y');
```

---

## 📊 Key Analysis Performed

### **1️⃣ Customer Insights**
- Unique customers  
- Most frequent customer  
- Total & average purchase per customer  
- Top 5 customers by purchase amount  

---

### **2️⃣ Product Performance**
- Product count by category  
- Highest-selling products  
- Revenue per product  
- Sales by category and supplier  

---

### **3️⃣ Sales & Order Trends**
- Total orders  
- Average order value  
- Monthly trends  
- Weekday vs weekend ordering patterns  

---

### **4️⃣ Supplier Contribution**
- Supplier with most products  
- Revenue contributed per supplier  
- Average product price by supplier  

---

### **5️⃣ Employee Performance**
- Orders handled by each employee  
- Total sales processed  
- Average order value per employee  

---

## 📈 Business Insights

### **Key Findings**
- A few customers and products contribute majority revenue  
- Sales peak in **January, February, and December**  
- Low months: **April & October**  
- Strong correlation between quantity ordered & revenue  
- Some suppliers dominate product availability  

### **Recommendations**
- Build loyalty plans for high-value customers  
- Promote fast-selling products  
- Introduce offers during low-performing months  
- Strengthen partnerships with top suppliers  
- Upskill low-performing employees  

---

## 🚀 What I Learned
- Designing relational databases  
- Handling dirty/inconsistent data  
- Writing multi-table joins and subqueries  
- Trend & revenue analysis using SQL  
- Converting raw data into business insights  

---


