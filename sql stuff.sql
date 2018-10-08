--Get the product name , count of orders processed

--Get the list of the months which don’t have any orders for product chai
Select strftime('%m', o.OrderDate) || '-' || strftime('%Y', o.OrderDate) as 'OrderMonth'
From [Order] o,
(Select strftime('%m', o.OrderDate) || '-' || strftime('%Y', o.OrderDate) as 'OrderMonth', p.ProductName
	From OrderDetail od
	Join [Order] o on od.OrderId = o.Id
	join Product p on od.ProductId = p.Id
	Where p.ProductName like 'chai'
	group by strftime('%m', o.OrderDate)
	) ChaiMonths
	Where o.OrderDate Not like ChaiMonths.OrderMonth
	group by strftime('%m', o.OrderDate)
	;

--try using strings instead of dates
	
Select strftime('%m', o.OrderDate) || '-' || strftime('%Y', o.OrderDate) as 'OrderMonth', p.ProductName
	From OrderDetail od
	Join [Order] o on od.OrderId = o.Id
	join Product p on od.ProductId = p.Id
	Where p.ProductName like 'chai'
	group by strftime('%m', o.OrderDate);

Select ord.OrderDate
From [Order] ord


--Get the list of the products which don't have any orders across all the months and years
SELECT ProductName, b.ProductId FROM Product a
LEFT JOIN
    (SELECT OrderDetail.ProductId FROM OrderDetail
     GROUP BY OrderDetail.ProductId) b ON b.ProductId = a.Id
WHERE b.ProductId IS NULL;


--Get the list of employees who processed orders for the product chai

Select e.FirstName || ' ' || e.LastName as 'Name', p.ProductName
FROM OrderDetail od
Join Product p on od.ProductId = p.Id
Join [Order] o on od.OrderId = o.Id
join Employee e on o.EmployeeId = e.Id
Where p.ProductName like 'chai'
group by e.Id;

--Get the list of employees and the count of orders they processed in the month of march across all years
select e.FirstName || ' ' || e.LastName as 'Name', count(o.Id) as 'Orders'
From [Order] o
join Employee e on o.EmployeeId = e.Id
Where strftime('%m', o.OrderDate) like '03'
group by e.Id;


--Get the list of employees who processed the orders that belong to the city in which they live
select e.FirstName, e.City
from [Order] o
Join Employee e on o.EmployeeId = e.Id
Where o.ShipCity = e.City
group by e.Id;

--Get the list of employees who processed the orders that don’t belong to the city in which they live
select e.FirstName, e.City
from [Order] o
Join Employee e on o.EmployeeId = e.Id
Where o.ShipCity != e.City
group by e.Id;

--Get the shipping companies that processed ordersfor the category Seafood
Select o.ShipName, c.CategoryName
From [Order] o
Join OrderDetail od on o.Id = od.OrderId
Join Product p on od.ProductId = p.Id
Join Category c on p.CategoryId = c.Id
where c.CategoryName like 'Seafood'
group by o.ShipName;

--Get the category name and count of orders processed by employees in the USA
Select cc.Category, count(cc.Orders)
from
	(Select c.CategoryName as 'Category', o.Id as 'Orders'
	from [Order] o
	join OrderDetail od on o.Id = od.OrderId
	join Product p on od.ProductId = p.Id
	Join Category c on p.CategoryId = c.Id
	join Employee e on o.EmployeeId = e.Id
	where e.Country like 'USA'
	group by c.Id, o.Id
	) cc
	group by cc.Category;