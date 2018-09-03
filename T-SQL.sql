-- **** Ex1
-- Write a query against the Sales.Orders table that returns orders placed in June 2015
--Desired output (abbreviated):
--orderid orderdate custid empid
------------- ---------- ----------- -----------
--10555 2015-06-02 71 6
--10556 2015-06-03 73 2
--10557 2015-06-03 44 9
--10558 2015-06-04 4 1
--10559 2015-06-05 7 6
--10560 2015-06-06 25 8
--10561 2015-06-06 24 2
--10562 2015-06-09 66 1
--10563 2015-06-10 67 2
--10564 2015-06-10 65 4
--...
--(30 row(s) affected)

-- SOLUTION 1
SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE orderdate >= '2015-06-01'
      AND orderdate <= '2015-06-30'
ORDER BY orderdate;

-- SOLUTION 2
SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE YEAR(orderdate) = 2015
      AND MONTH(orderdate) = 6;

-- **** Ex2
--Write a query against the Sales.Orders table that returns orders placed on the last day of the month:
--Tables involved: TSQLV4 database and the Sales.Orders table
--Desired output (abbreviated):

--orderid orderdate custid empid
------------- ---------- ----------- -----------
--10269 2014-07-31 89 5
--10317 2014-09-30 48 6
--10343 2014-10-31 44 4
--10399 2014-12-31 83 8
--10432 2015-01-31 75 3
--10460 2015-02-28 24 8
--10461 2015-02-28 46 1
--10490 2015-03-31 35 7
--10491 2015-03-31 28 8
--10522 2015-04-30 44 4
--...
--(26 row(s) affected)

-- SOLUTION 1
SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE orderdate = DATEADD(MONTH, DATEDIFF(MONTH, '18991231', orderdate), '18991231');

-- SOLUTION 2
SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);


-- **** Ex3
--Write a query against the HR.Employees table that returns employees with a last name containing the letter e twice or more:
--Tables involved: TSQLV4 database and the HR.Employees table
--Desired output:

--empid firstname lastname
------------- ---------- --------------------
--4 Yael Peled
--5 Sven Mortensen
--(2 row(s) affected)

-- SOLUTION 1
SELECT empid,
       firstname,
       lastname
FROM HR.Employees
WHERE lastname LIKE N'%e%e%';

-- **** Ex4
--Write a query against the Sales.OrderDetails table that returns orders with a total value
--(quantity * unitprice) greater than 10,000, sorted by total value:
--Tables involved: TSQLV4 database and the Sales.OrderDetails table
--Desired output:

--orderid totalvalue
------------- ---------------------
--10865 17250.00
--11030 16321.90
--10981 15810.00
--10372 12281.20
--10424 11493.20
--10817 11490.70
--10889 11380.00
--10417 11283.20
--10897 10835.24
--10353 10741.60
--10515 10588.50
--10479 10495.60
--10540 10191.70
--10691 10164.80
--(14 row(s) affected)

-- SOLUTION 1
SELECT orderid,
       SUM(unitprice * qty) AS totalValue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(unitprice * qty) > 10000
ORDER BY totalValue DESC;


-- **** Ex5
--To check the validity of the data, write a query against the HR.Employees table that returns
--employees with a last name that starts with a lowercase English letter in the range a through z.
--Remember that the collation of the sample database is case INSENSITIVE (Latin1_General_CI_AS):
--Tables involved: TSQLV4 database and the HR.Employees table
--Desired output is an empty set:

--empid lastname
------------- --------------------
--(0 row(s) affected))

-- SOLUTION 1
SELECT empid,
       lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]';


-- **** Ex6
--Explain the difference between the following two queries:
--Click here to view code image
-- Query 1
--SELECT empid, COUNT(*) AS numorders
--FROM Sales.Orders
--WHERE orderdate < '20160501'
--GROUP BY empid;
SELECT empid,
       COUNT(*) numorders
FROM Sales.Orders
WHERE orderdate < '20160501'
GROUP BY empid
ORDER BY empid;

-- Query 2
SELECT empid,
       COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501'
ORDER BY empid;

-- SOLUTION 1

SELECT orders.empid,
       MAX(orderdate)
FROM Sales.Orders orders
WHERE orders.empid = 2
GROUP BY orders.empid
HAVING orderdate < '20160501';

-- **** Ex7
--Write a query against the Sales.Orders table that returns the three shipped-to countries with the
--highest average freight in 2015:
--Tables involved: TSQLV4 database and the Sales.Orders table
--Desired output:
--Click here to view code image
--shipcountry avgfreight
----------------- ---------------------
--Austria 178.3642
--Switzerland 117.1775
--Sweden 105.16
--(3 row(s) affected)

-- SOLUTION 1
SELECT TOP (3)
       shipcountry,
       AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101'
      AND orderdate <= '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

-- SOLUTION 2
SELECT shipcountry,
       AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101'
      AND orderdate <= '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- **** Ex8
--Write a query against the Sales.Orders table that calculates row numbers for orders based on
--order date ordering (using the order ID as the tiebreaker) for each customer separately:
--Tables involved: TSQLV4 database and the Sales.Orders table
--Desired output (abbreviated):
--Click here to view code image
--custid orderdate orderid rownum
------------- ---------- ----------- --------------------
--1 2015-08-25 10643 1
--1 2015-10-03 10692 2
--1 2015-10-13 10702 3
--1 2016-01-15 10835 4
--1 2016-03-16 10952 5
--1 2016-04-09 11011 6
--2 2014-09-18 10308 1
--2 2015-08-08 10625 2
--2 2015-11-28 10759 3
--2 2016-03-04 10926 4
--...
--(830 row(s) affected)

SELECT custid,
       orderdate,
       orderid,
       ROW_NUMBER() OVER (PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid,
         rownum;

-- **** Ex9
--Using the HR.Employees table, write a SELECT statement that returns for each employee the
--gender based on the title of courtesy. For ‘Ms.’ and ‘Mrs.’ return ‘Female’; for ‘Mr.’ return
--‘Male’; and in all other cases (for example, ‘Dr.‘) return ‘Unknown’:
--Tables involved: TSQLV4 database and the HR.Employees table
--Desired output:
--empid firstname lastname titleofcourtesy gender
------------- ---------- -------------------- ------------------------- -------
--1 Sara Davis Ms. Female
--2 Don Funk Dr. Unknown
--3 Judy Lew Ms. Female
--4 Yael Peled Mrs. Female
--5 Sven Mortensen Mr. Male
--6 Paul Suurs Mr. Male
--7 Russell King Mr. Male
--8 Maria Cameron Ms. Female
--9 Patricia Doyle Ms. Female
--(9 row(s) affected)

SELECT empid,
       firstname,
       lastname,
       titleofcourtesy,
       CASE titleofcourtesy
           WHEN 'Ms.' THEN
               'Female'
           WHEN 'Mrs.' THEN
               'Female'
           WHEN 'Mr.' THEN
               'Male'
           ELSE
               'Unknow'
       END AS gender
FROM HR.Employees;

-- **** Ex10
--Write a query against the Sales.Customers table that returns for each customer the customer
--ID and region. Sort the rows in the output by region, having NULLs sort last (after non-NULL
--values). Note that the default sort behavior for NULLs in T-SQL is to sort first (before non-
--NULL values):
--Tables involved: TSQLV4 database and the Sales.Customers table
--Desired output (abbreviated):
--custid region
------------- ---------------
--55 AK
--10 BC
--42 BC
--45 CA
--37 Co. Cork
--33 DF
--71 ID
--38 Isle of Wight
--46 Lara
--78 MT
--...
--1 NULL
--2 NULL
--3 NULL
--4 NULL
--5 NULL
--6 NULL
--7 NULL
--8 NULL
--9 NULL
--11 NULL

SELECT custid, region FROM Sales.Customers
ORDER BY CASE WHEN region IS NULL THEN 1 ELSE 0 END;