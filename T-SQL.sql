-- Ex 4
SELECT orderdetails.orderid, SUM(orderdetails.qty * orderdetails.unitprice) as totalvalue FROM Sales.OrderDetails as  orderdetails

GROUP BY orderid

HAVING SUM(orderdetails.qty * orderdetails.unitprice) > 10000

ORDER BY totalvalue DESC