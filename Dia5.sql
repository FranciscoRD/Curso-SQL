use AdventureWorks
--Subconsulta
--1. Todos los empleados del departamento de finanza
		--Modo Clasico
select p.FirstName, p.LastName, d.Name as Departamento
from person.person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory edh on p.BusinessEntityID=edh.BusinessEntityID
	inner join HumanResources.Department d on d.DepartmentID=edh.DepartmentID
where d.Name='Finance'

		--Modo Subconsulta
select p.FirstName, p.LastName
from person.person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory edh on p.BusinessEntityID=edh.BusinessEntityID
where edh.DepartmentID=
(
	select DepartmentID
	from HumanResources.Department d
	where name='Finance'
)

--2. Listar el codigo de producto, nombre de producto, unidades vendidas por año, incluya productos que
--la palabra bike
		--Version 1
select p.ProductID,p.Name as Producto, YEAR(soh.OrderDate) as Año, sum(sod.OrderQty) as Unidades
from Production.Product p inner join sales.SalesOrderDetail sod on p.ProductID=sod.ProductID
	inner join sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
where p.Name like '%bike%'
group by YEAR(soh.OrderDate),p.ProductID,p.Name
order by p.Name,YEAR(soh.OrderDate)
		--Version 2
select p.ProductID,p.Name as Producto, YEAR(soh.OrderDate) as Año, sum(sod.OrderQty) as Unidades
from Production.Product p inner join sales.SalesOrderDetail sod on p.ProductID=sod.ProductID
	inner join sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
where sod.ProductID in
(
	select ProductID
	from Production.Product
	where Name like '%bike%'
)
group by YEAR(soh.OrderDate),p.ProductID,p.Name
order by p.Name,YEAR(soh.OrderDate)

--3. Mostrar el nombre del departamento con mas empleados, indicar la cantidad
		--Este ejercicio no se puede realizar como subconsulta
select top 1 d.Name as Departamento,COUNT(*) as Empleado
from HumanResources.Department d inner join HumanResources.EmployeeDepartmentHistory edh on d.DepartmentID=edh.DepartmentID
group by d.Name
order by Empleado desc

--4. Mostrar el nombre del departamento y el nombre completo del ultimo empleado que entro a laborar
		--Mio puedo sacar el dato pero si agrego el nombre de empleado se arruina
select d.Name as Departamento,max(edh.StartDate) as FechaInicio--, p.FirstName+' '+p.LastName as Nombre
from HumanResources.EmployeeDepartmentHistory edh inner join HumanResources.Department d on edh.DepartmentID=d.DepartmentID
	inner join Person.Person p on edh.BusinessEntityID=p.BusinessEntityID
group by d.Name--,p.FirstName,p.LastName--, edh.StartDate
order by d.name--,edh.StartDate desc

		--Profesor
select d.Name as Departamento, CONCAT(p.FirstName,SPACE(1),p.lastname) as Empleado, h1.StartDate
from person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h1 on e.BusinessEntityID=h1.BusinessEntityID
	inner join HumanResources.Department d on h1.DepartmentID=d.DepartmentID
where h1.StartDate in
(
	select max(StartDate)
	from HumanResources.EmployeeDepartmentHistory h2
	where h1.DepartmentID=h2.DepartmentID
	group by DepartmentID
)
order by 1,2 desc

--5. Mostrar por año, el nombre y apellidos del empleado que ha vendido mas
select YEAR(soh.DueDate) as Año, sum(soh.TotalDue) as Total
from sales.SalesOrderHeader soh inner join sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
	inner join person.Person p on p.BusinessEntityID=soh.SalesPersonID
group by year(soh.DueDate)

select soh.SalesPersonID ,concat(p.FirstName,space(1),p.lastname) as Vendedor,sum(soh.TotalDue) as MontoVentas
from sales.SalesOrderHeader soh inner join Person.Person p on p.BusinessEntityID=soh.SalesPersonID
group by soh.SalesPersonID,concat(p.FirstName,space(1),p.lastname)

		--Base para terminar Mio
select YEAR(soh.OrderDate) as Año, concat(p.FirstName,space(1),p.lastname) as Vendedor,sum(soh.TotalDue) as Total
from sales.SalesOrderHeader soh join person.Person p on p.BusinessEntityID=soh.SalesPersonID
group by year(soh.orderdate), concat(p.FirstName,space(1),p.lastname)

		--Base para terminar Profesor
select YEAR(h.orderdate) as Año, --concat(p.FirstName,space(1),p.lastname) as Vendedor,
	sum(h.TotalDue) as Ventas
from sales.SalesPerson sp inner join person.person p on sp.BusinessEntityID=p.BusinessEntityID
	inner join sales.salesorderheader h on h.SalesPersonID=sp.BusinessEntityID
group by year(h.OrderDate)--,concat(p.FirstName,space(1),p.lastname)--,sum(h.TotalDue)
having sum(h.TotalDue) in
(
	select sum(h2.TotalDue)
	from sales.SalesOrderHeader h2
	where h.SalesPersonID=h2.SalesPersonID
	group by year(h2.OrderDate),h2.SalesPersonID
)
order by 1 desc--, 3 desc