USE `classicmodels`;

-- --------------------- My SQL Assignments--------------------------------------------------
-- -----Day 3---------
-- Q. 1-----

select customernumber, customername, state, creditlimit from customers 
where state is not null and creditlimit between 50000 and 100000 order by creditlimit desc;

-- Q. 2------

select distinct productline from products where productline like '%cars';

-- ------Day 4----------
-- Q. 1--------

select ordernumber, status, ifnull(comments,"-") as comments 
from orders where status = 'shipped';

-- Q. 2--------

with y as(select employeenumber, firstname, jobtitle from employees)
select *, case when jobtitle = "president" then "P"
when jobtitle like "%manager%" then "SM"
when jobtitle = "sales rep" then "SR"
when jobtitle like "vp%" then "VP"
end as job_title_abbreviation from y;

-- --------Day 5---------------------------------
-- Q. 1-----------

select year(paymentdate) as year, min(amount) as min_amount from payments group by year order by year asc;

-- Q. 2-----------

select year(orderdate) as OrderYear, concat("Q",quarter(orderdate)) as Quarter, 
count(distinct customernumber) as Unique_Customers, count(ordernumber) as Total_Orders 
from orders group by orderyear, quarter order by orderyear, quarter; 

select * from orders;
-- Q. 3------------

select date_format(paymentdate,'%b') as month, 
concat(format(sum(amount)/1000,0),'K') as Formatted_amount from payments 
group by month having sum(amount) between 500000 and 1000000 order by sum(amount) desc; 

-- -----------Day 6----------------------------------------
-- Q. 1-----------

create table journey (Bus_ID integer not null primary key, Bus_name varchar(111) not null, 
Source_Station varchar(111) not null, Destination varchar(111) not null,
Email varchar(111) not null unique);

-- Q. 2-----------

create table Vendor (Vendor_ID integer not null primary key, Name varchar(111) not null,
Email varchar(111) not null unique, Country varchar(111) default 'N/A');

-- Q. 3-----------

create table Movies (Movie_id integer not null primary key, Name varchar(111) not null, 
Release_Year integer, Cast varchar(111)  not null, Gender enum('male','female') not null, 
Not_of_shows integer unsigned);

-- Q. 4-----------
-- Suppliers------
create table suppliers(Supplier_id integer auto_increment primary key, 
supplier_name varchar(111) not null, location varchar(111));

-- product--------

create table Product(Product_id integer auto_increment primary key, 
Product_name varchar(111) not null unique, description text, supplier_id integer, 
foreign key(supplier_id) references suppliers(supplier_id));

-- stock----------

create table Stock(id integer auto_increment primary key, 
product_id integer, foreign key(product_id) references product(product_id), 
balance_stock integer);

-- ---------DAy 7----------------------------------------------------------
-- Q. 1-----------------
select employees.employeeNumber as EmployeeNumber, 
concat(employees.firstname," ",employees.lastname) as SalesPerson, 
count(distinct customers.customernumber) as UniqueCustomers from 
employees left join customers on employees.employeeNumber = customers.salesrepemployeenumber group 
by employees.employeeNumber, salesperson order by uniquecustomers desc;

-- Q. 2-----------------

select c.customernumber as customernumber, c.customername as CustomerName, 
p.productcode as ProductCode, p.productname as ProductName, 
sum(od.quantityordered) as Ordered_QTY, ifnull(p.quantityinstock,0) as Total_inventory, 
ifnull(p.quantityinstock - sum(od.quantityordered),0) as Left_Qty from 
customers c join orders o on c.customernumber = o.customernumber join orderdetails od on 
o.ordernumber = od.ordernumber join products p on od.productcode = p.productcode
left join products s on p.productcode = s.productcode group by c.customernumber,
p.productcode order by c.customernumber;

-- Q. 3------------------

create table laptop(laptop_name varchar(111));
insert into laptop values("dell"),("hp"),("dell"),("hp"),("dell"),("hp");

create table colours(colour_name varchar(111));
insert into colours values("green"),("white"),("blue"),("green"),("white"),("blue");

select laptop.laptop_name, colours.colour_name from colours cross join laptop;

-- Q. 4-----------------

create table project(EmployeeID integer primary key,FullName varchar(111), Gender varchar(111), ManagerID integer);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select p1.fullname as "manager name", p2.fullname as "emp name" from project p1 join project p2 on p1.employeeid = p2.managerid;

-- --------------------DAy 8---------------------------------------------------------

create table facility(Facility_ID integer not null,
Name varchar(100), State varchar(100), Country varchar(100));

alter table facility modify column facility_id integer auto_increment primary key;

alter table facility add column city varchar(100) not null after name;

desc facility;

-- ------------------ Day 9------------------------------------------------

create table university(ID integer, Name varchar(111));
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
              

select * from university;
set SQL_SAFE_UPDATES = 0;
update university  set name = replace(name,' ','');

-- --------------------DAy 10--------------------------------------------------------

create view products_status as select year(o.orderdate) as year, 
concat(count(od.priceeach),' (',round((sum(od.priceeach*od.quantityordered)/
(select sum(od2.priceeach*od2.quantityordered) from 
orderdetails od2))*100),'%)') as value from orders o join orderdetails od on o.ordernumber = 
od.ordernumber group by year order by value desc;

select * from products_status;

-- ----------------------Day 11-------------------------------------------------------
-- Stored Procedure---------------------------------------
-- Q.1------------------------------

select * from customers;
Call getcustomerlevel(276,@level);
select @level as customers_level;

-- Q. 2-----------------------------
-- Stored Procedure---------

call get_country_payments(2003,'france');

-- --------------------------------Day 12------------------------------------------------------
-- Q. 1------------------------------

with y as (
select year(orderdate) as order_year, monthname(orderdate) as order_month,
count(*) as order_count from orders group by order_year, order_month order by order_year, order_month),
x as (select a.order_year, a.order_month,a.order_count,b.order_count as prev_year_order_count,
case when b.order_count is null then null
else concat(round(((a.order_count-b.order_count)/b.order_count)*100),'%')
end as yoy_percentage_change from y a left join y b on a.order_year = b.order_year + 1 and 
a.order_month = b.order_month)
select order_year as Year, order_month as Month, order_count as Total_Orders,
yoy_percentage_change as "% YoY Change" from x;

-- Q. 2----------------------------------

create table emp_udf(Emp_ID integer auto_increment primary key, 
Name varchar(111) not null, DOB date);

INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush","1990-03-30"),("Aman","1992-08-15"),("Meena","1998-07-28"),("Ketan","2000-11-21"),("Sanjay","1995-05-21");

select * from emp_udf;

select emp_id, name, DOB, calculate_age(DOB) as age from emp_udf;

-- ----------------------------------Day 13-----------------------------------------------------
-- Q.1----------------------------------------

select customernumber, customername from customers where customernumber
not in (select customernumber from orders);

-- Q 2---------------------------------------- 

select c.customernumber, c.customername, ifnull(count(o.ordernumber),0) as "Total Orders" from 
customers as c left join orders as o on c.customernumber = o.customernumber group by c.customernumber, c.customername
union
select o.customernumber, c.customername, ifnull(count(o.ordernumber),0) as "Total Orders" from 
customers c right join orders o on c.customernumber = o.customernumber group by o.customernumber, c.customername;

-- Q. 3-------------------------------------- 

select ordernumber, max(quantityordered) as quantityordered from orderdetails od1 where 
quantityordered < (select max(quantityordered) from orderdetails od2 where od1.ordernumber =
od2.ordernumber) group by ordernumber;

-- Q. 4--------------------------------------

select max(productcount) as "MAX(Total)", min(productcount) as "MIN(Total)"
from (select ordernumber, count(*) as productcount from orderdetails group by ordernumber) as counts;

-- Q.5---------------------------------------

select p.productline, count(*) as Total from products p join (select avg(buyprice) as avgbuyprice
from products) as Avg_prices on p.buyprice > avg_prices.avgbuyprice group by p.productline
order by Total desc;

-- --------------------------Day 14---------------------------------------------

create table emp_EH(EmpID integer primary key, empname varchar(111), emailaddress varchar(111));

-- --------------------------Day 15-----------------------------------------------

create table Emp_BIT(Name varchar(111), Occupation varchar(111), Working_date date, Working_hours integer);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11); 

 







