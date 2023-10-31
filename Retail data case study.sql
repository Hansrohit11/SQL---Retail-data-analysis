

create database base 

use base



select * from Customer
select * from prod_cat_info
select * from Transactions

---Q1---
select COUNT(customer_id) as Row from Customer
union 
select COUNT(prod_cat_code) as Row from prod_cat_info
union 
select COUNT(cust_id) as Row from Transactions

--Q2--
SELECT COUNT(CUST_id) as [Return] from Transactions
where Qty<0

--Q3--
select tran_date,convert(date,tran_date,105) as New_tran_date from Transactions

--Q4--
select DATEDIFF(year,MIN(tran_date),max(tran_date)) as [year],
	   DATEDIFF(month,MIN(tran_date),max(tran_date)) as [month],
	   DATEDIFF(day,MIN(tran_date),max(tran_date)) as [day]
from Transactions


--Q5---
select prod_cat from prod_cat_info
where prod_subcat='diy'

----DATA ANALYSIS----

--Q1--
SELECT TOP 1 Store_type as channel, COUNT(STORE_TYPE) AS TOTAL FROM Transactions
GROUP BY Store_type
ORDER BY TOTAL DESC

--Q2--
select Gender ,count(Gender) as gender_count     from Customer
where Gender in ('m','f')
group by Gender


--Q3--
select top 1 city_code, count(city_code) as No_cust from Customer
group by city_code
order by COUNT(city_code) desc

--Q4--
select prod_cat, count(prod_subcat) as sub_categories  from prod_cat_info
where prod_cat='books'
group by prod_cat

--Q5--
select top 1 p.prod_cat, count(cast(Qty as int)) as quantity from Transactions t
inner join prod_cat_info p
on p.prod_cat_code=t.prod_cat_code
group by p.prod_cat
order by quantity desc


--Q6--
select p.prod_cat, sum(CAST(t.total_amt as float)) as total_revenue from Transactions t
inner join prod_cat_info p
on p.prod_cat_code=t.prod_cat_code
where prod_cat='electronics' or prod_cat= 'books'
group by p.prod_cat

--Q7--
select cust_id, COUNT(transaction_id) as transactions from Transactions
WHERE Qty NOT LIKE '-%'
group by cust_id
having (COUNT(transaction_id)>10)

--Q8--
select sum(CAST(t.total_amt as float)) as total_revenue from Transactions t
inner join prod_cat_info p
on p.prod_cat_code=t.prod_cat_code
where p.prod_cat in ('electronics','clothing') and t.Store_type ='flagship store'


--Q9--
select p.prod_subcat, sum(CAST(t.total_amt as float)) as total_revenue   from prod_cat_info p
inner join Transactions t
on p.prod_sub_cat_code=t.prod_subcat_code
inner join Customer c
on c.customer_Id=t.cust_id
where c.Gender='m' and p.prod_cat='electronics'
group by p.prod_subcat

--Q10--
select TOP 5 P.prod_subcat,
concat(round(SUM(CAST(T.total_amt AS FLOAT))/(select sum(CAST(s.total_amt AS FLOAT)) from Transactions s)*100,2),'%') AS Percentage_Of_Sales,
concat(round(COUNT(CASE WHEN QTY< 0 THEN QTY ELSE NULL END)/SUM(cast(QTY as float))*100,2),'%') AS PERCENTAGE_OF_RETURN
FROM prod_cat_info P
INNER JOIN Transactions T
ON P.prod_sub_cat_code=T.prod_subcat_code
GROUP BY P.prod_subcat
ORDER BY Percentage_Of_Sales desc


--Q11--
 select cust_id,sum(cast(total_amt as float)) as Total_revenue
 from Transactions
 where cust_id in (select customer_id
 from Customer
 where datediff(year,convert(date,dob,103),GETDATE())
 between 25 and 35)
 and convert(date,tran_date,103)
 between
 DATEADD(day,-30,(select max(convert(date,tran_date,103))
 from Transactions))
 and(select max(convert(date,tran_date,103))
 from Transactions)
 group by cust_id




--Q12--
SELECT top 1 P.prod_cat, SUM(CAST(T.total_amt AS FLOAT)) AS RETURN_VALUE  FROM prod_cat_info P
INNER JOIN Transactions T
ON P.prod_cat_code=T.prod_cat_code
WHERE T.Qty LIKE'-%' AND CONVERT(date, tran_date, 103) BETWEEN DATEADD(MONTH,-3,(SELECT MAX(CONVERT(DATE,tran_date,103)) FROM Transactions)) 
	 AND (SELECT MAX(CONVERT(DATE,tran_date,103)) FROM Transactions) 
GROUP BY P.prod_cat
ORDER BY RETURN_VALUE 



--Q13--
select top 1 Store_type,sum(cast(total_amt as float)) as sale_amt, COUNT(cast(Qty as int)) as quantity from Transactions
group by Store_type
order by sale_amt desc , quantity desc

--Q14--
select p.prod_cat, avg(cast(t.total_amt as float)) as avg_revenue from prod_cat_info p 
inner join Transactions t
on p.prod_cat_code=t.prod_cat_code
group by p.prod_cat
having avg(cast(t.total_amt as float))>(select avg(cast(total_amt as float)) from Transactions)

--Q15--
select top 5 prod_cat
,avg(cast(t.total_amt as float)) as avg_revenue,sum(cast(T.total_amt as float)) as total_revenue, COUNT(cast(T.Qty as int)) as quantity
from prod_cat_info p
inner join Transactions t
ON P.prod_cat_code=T.prod_cat_code
GROUP BY prod_cat
ORDER BY quantity desc
