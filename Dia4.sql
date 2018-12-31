use AdventureWorks

select Sum(s.TotalDue) as TotalVendido
from Sales.SalesOrderHeader s

--Funciones de Agregados
--1. Cantidad de personas
select COUNT(p.BusinessEntityID) as CantidadPersonas
from Person.Person p

--2. Cantidad de Empleados
select count(*) as TotalEmpleados
from HumanResources.Employee

--3. Indicar el año de Ventas y el Monto Facturado
select year(OrderDate) as 'Año', sum(s.TotalDue) as Facturacion
from sales.SalesOrderHeader s
group by year(OrderDate)
order by year(OrderDate) desc

--4. Indicar el año de venta, nombre del producto, unidades vendidas y monto facturado,
--Ordenar primero por año, luego por producto

		--Mio
select year(h.OrderDate) as 'AñoVenta',p.Name as NombreProducto, sum(d.OrderQty) as ArticulosVendidos, sum(h.TotalDue) as Total
from sales.SalesOrderDetail d inner join Production.Product p on d.ProductID=p.ProductID 
	inner join Sales.SalesOrderHeader h on h.SalesOrderID=d.SalesOrderID
group by YEAR(h.OrderDate), p.Name
order by year(h.OrderDate), p.Name

		--Profesor
select year(h.OrderDate) as 'Año',p.Name as Producto, sum(d.OrderQty) as Unidades, sum(d.LineTotal) as Ventas
from Sales.SalesOrderHeader h inner join sales.SalesOrderDetail d on h.SalesOrderID=d.SalesOrderID
	inner join Production.Product p on d.ProductID=p.ProductID
group by year(h.orderdate),p.name
order by year(h.OrderDate),p.Name

--5. Mostrar el nombre del departamento y el numero de empleados
		--Mio
select d.Name, COUNT(e.BusinessEntityID) as EmpleadosArea
from HumanResources.Department d inner join HumanResources.Employee e on d.DepartmentID=e.OrganizationLevel
group by d.Name

		--Profesor
select d.Name as Departamento, count(*) as Empleados
from HumanResources.EmployeeDepartmentHistory h inner join HumanResources.Department d on h.DepartmentID=d.DepartmentID
group by d.Name
order by d.Name
--6. Listar el nombre del empleado, año de ventas y monto facturado
		--Mio
select p.FirstName as Nombre,p.LastName as Apellido,sum(d.TotalDue) as Ventas, year(d.OrderDate) as Año
from HumanResources.Employee e inner join Person.Person p on e.BusinessEntityID=p.BusinessEntityID
	inner join sales.SalesOrderHeader d on e.BusinessEntityID=d.SalesPersonID
group by p.FirstName,p.LastName,year(d.OrderDate)
order by 1,2
		--Profesor
select p.FirstName as Nombre, p.LastName as Apellido, year(h.OrderDate) as Año, sum(h.TotalDue) as Total
from person.Person p inner join sales.SalesPerson sp on p.BusinessEntityID=sp.BusinessEntityID
	inner join sales.SalesOrderHeader h on sp.BusinessEntityID=h.SalesPersonID
group by p.FirstName, p.LastName, year(h.OrderDate)
order by 1,2,3

--7. Mostrar el año de venta, total facturado, venta minimo y maxima
select year(OrderDate) as Año, sum(TotalDue) as Total, min(TotalDue) as Minimo,max(TotalDue) as Maximo
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by year(OrderDate)

--8. Listar el año de venta, region y total de ventas
select year(h.OrderDate) as Año, t.Name as Territorio, c.Name as Region, sum(h.TotalDue) as Ventas
from sales.SalesOrderHeader h inner join sales.SalesTerritory t on h.TerritoryID=t.TerritoryID
	inner join Person.CountryRegion c on t.CountryRegionCode=c.CountryRegionCode
group by year(h.OrderDate), t.Name, c.Name
order by 1 desc,2,3

--9. Mostrar por año el total de descuento aplicado
select year(h.OrderDate) as Año, sum(d.OrderQty*d.UnitPrice*d.UnitPriceDiscount) as Descuento
from sales.SalesOrderHeader h inner join sales.SalesOrderDetail d on h.SalesOrderID=d.SalesOrderID
group by year(h.OrderDate)
order by 1 desc

--10. Indicar el nombre completo del empleado y la cantidad de departamentos donde ha laborado
		--select p.FirstName+' '+p.LastName as Nombre
		--from person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=p.BusinessEntityID
		--	inner join HumanResources.EmployeeDepartmentHistory eh on eh.BusinessEntityID=e.BusinessEntityID 


--11. Mostrar el nombre de la tienda, la cantidad total de ventas realizadas por año
select s.Name as Tienda, year(h.OrderDate) as Año,sum(h.TotalDue) as TotalAño
from sales.Store s inner join Sales.SalesPerson sp on s.SalesPersonID=sp.BusinessEntityID
	inner join sales.SalesOrderHeader h on sp.BusinessEntityID=h.SalesPersonID
group by s.Name, YEAR(h.OrderDate)
order BY s.name, year(h.OrderDate)

--12. Listar la categoria del producto, Año de ventas, Mes en letras unidades vendidas y total recaudado
		--select c.Name as Categoria
		--from Production.Product p inner join Production.ProductSubcategory s on p.ProductSubcategoryID=s.ProductSubcategoryID
		--	inner join Production.ProductCategory c on s.ProductCategoryID=c.ProductCategoryID

--13. Mostrar el nombre del departamento y la cantidad de empleados que laboran actualmente
select d.Name as Departamento, sum(eh.BusinessEntityID) as TotalEmpleados
from HumanResources.Department d inner join HumanResources.EmployeeDepartmentHistory eh on d.DepartmentID=eh.DepartmentID
where eh.EndDate<getdate()
group by d.Name

--14. Listar la subcategoria de productos, cantidad de ordenes donde aparece y monto recaudado.
select s.Name as Subcategoria, COUNT(d.ProductID) as CantidadOrdenes, sum(LineTotal) as Monto
from Production.Product p inner join Sales.SalesOrderDetail d on p.ProductID=d.ProductID
	inner join Production.ProductSubcategory s on p.ProductSubcategoryID=s.ProductSubcategoryID
group by s.Name,d.ProductID

--15. Mostrar el pais y el numero de tiendas que posee


--16. Listar el nombre de la tienda, año, mes en letras, cantidad de ventas realizadas,
--monto total facturado y venta promedio


--17. Mostrar el nombre del empleado, numero de ordenes atendidas y monto facturado
select p.FirstName+' '+p.LastName as Nombre, count(h.SalesOrderID) Ordenes, sum(TotalDue) Total
from Person.Person p inner join Sales.SalesPerson sp on p.BusinessEntityID=sp.BusinessEntityID
	inner join sales.SalesOrderHeader h on sp.BusinessEntityID=h.SalesPersonID
group by p.FirstName,p.LastName,SalesOrderID
order by p.FirstName

--18. Listar año, mes, cantidad de ordenes, total de ventas, venta promedio, minima y maxima realizada por
-- territorio y region.


--19. Mostrar el nombre del producto y total facturado por año
select p.name as Producto, year(h.OrderDate) as Año,sum(s.LineTotal) as Total
from sales.SalesOrderDetail s inner join Production.Product p on s.ProductID=p.ProductID
	inner join sales.SalesOrderHeader h on s.SalesOrderID=h.SalesOrderID
group by p.Name,year(h.OrderDate)
order by 1,2

--20. Indicar el nombre del departamento y la cantidad de empleado que ya no laboran en el

		--Mio
select d.Name as Departamento, p.FirstName as Nombre, p.LastName as Apellido,
	eh.StartDate,eh.EndDate
from person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory eh on e.BusinessEntityID=eh.BusinessEntityID
	inner join HumanResources.Department d on eh.DepartmentID=d.DepartmentID
where eh.EndDate<getdate()	

		--Profesor
select d.Name as Departamento, p.FirstName as Nombre, p.LastName as Apellido,
	h.StartDate,h.EndDate
from person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h on e.BusinessEntityID=h.BusinessEntityID
	inner join HumanResources.Department d on h.DepartmentID=d.DepartmentID
where h.EndDate is not null

