-- Ex 4
SELECT orderdetails.orderid, SUM(orderdetails.qty * orderdetails.unitprice) as totalvalue FROM Sales.OrderDetails as  orderdetails

GROUP BY orderid

HAVING SUM(orderdetails.qty * orderdetails.unitprice) > 10000

ORDER BY totalvalue DESC

GO 

-- Ex 5
SELECT empid, lastname
FROM HR.Employees Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%';

GO

-- Ex 6
--	Query	1
SELECT empid, COUNT(*)	AS	numorders
FROM Sales.Orders
WHERE	orderdate <	'20160501'
GROUP	BY	empid;
--	Query	2
SELECT empid, COUNT(*)	AS	numorders
FROM Sales.Orders
GROUP	BY	empid
HAVING	MAX(orderdate)	< '20160501';

GO

-- Ex 7 
SELECT orders.shipcountry, AVG(orders.freight) as avgfreight
From Sales.Orders orders
WHERE orderdate >= '20150101' AND orderdate <= '20160101'
GROUP BY orders.shipcountry
ORDER BY avgfreight DESC OFFSET 0 ROWS FETCH NEXT 3 ROWs ONlY;

GO

-- Ex 9
SELECT employees.empid, employees.firstname, employees.lastname, employees.titleofcourtesy,
    CASE 
WHEN employees.titleofcourtesy IN ('Ms.','Mrs.') THEN 'Female'
WHEN employees.titleofcourtesy = 'Mr.' THEN 'Male'
ELSE 'Unknown'
END as gender
FROM HR.Employees employees
