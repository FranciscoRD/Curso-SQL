use AdventureWorks

select *
from Person.Person
where MiddleName>'K'

------------------------------------------------------------------------------
--1. Mostrar los empleados con sus nombres y apellidos del genero femenino
select p.FirstName as Nombre, p.LastName as Apellido,
case e.gender
when 'F' then 'Femenino'
end as Apellido
from Person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
where e.Gender='F'

--2. Listar el nombre completo del empleado, el nombre del departamento y la fecha de ingreso
--sea del mes de enero
select *
from HumanResources.Employee 
select *
from HumanResources.Department

select p.FirstName, p.LastName, d.Name as Departamento, h.StartDate as FechaIngreso
from Person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h on e.BusinessEntityID=h.BusinessEntityID
	inner join HumanResources.Department d on h.DepartmentID=d.DepartmentID
where MONTH(h.StartDate)=1

--3. Mostrar el Id de la orden, nombre completo del empleado y el monto facturado cuya fecha de venta sea superior al 01/01/2013
select h.SalesOrderID,h.OrderDate, p.FirstName, p.LastName, h.TotalDue
from sales.SalesOrderHeader h inner join Person.Person p on h.SalesPersonID=p.BusinessEntityID
where h.OrderDate>'01/01/2005'
order by h.OrderDate

--4. Listar las ordenes cuyo monto este comprendido entre 2000 y 5000
select h.SalesOrderID, h.TotalDue
from sales.SalesOrderHeader h
where h.TotalDue >=2000 and h.TotalDue <=5000

select h.SalesOrderID, h.TotalDue
from sales.SalesOrderHeader h
where h.TotalDue between 2000 and 5000

--5. Mostra el Id de Orden, subtotal, impuesto, envio y total a pagar de las ordenes 43668, 56837, 64898, 13351 y 
--75120
select s.SalesOrderID, s.SubTotal, s.TaxAmt, s.Freight, s.TotalDue
from Sales.SalesOrderHeader s
where s.SalesOrderID in (43668,56837,64898,73351,75120)

--6. Listar los empleados que ingresaron en el año 2004
  --select h.BusinessEntityID, p.FirstName, p.LastName,h.HireDate
  --from HumanResources.Employee h inner join Person.Person p on h.BusinessEntityID=p.BusinessEntityID 
  --where year(h.HireDate)=2004

select e.BusinessEntityID, p.FirstName, p.LastName, h.StartDate
from HumanResources.Employee e inner join Person.Person p on e.BusinessEntityID=p.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h on e.BusinessEntityID=h.BusinessEntityID  
where year(h.StartDate) = 2004

--7. Mostrar los empleados de la tienda "World of Bikes"
select s.Name as Tienda, s.SalesPersonID,p.FirstName, p.LastName
from sales.Store s inner join Person.Person p on s.SalesPersonID=p.BusinessEntityID
where s.Name='World of Bikes'

--8. Listar las ordenes cuya cantidad de unidades vendidas sea superior a 12 unidades
select s.SalesOrderID,s.OrderQty
from sales.SalesOrderDetail s
where s.OrderQty>12
order by 2 desc

--9. Listar los empleados del departamento de Finanzas e Ingenieria, con su fecha de ingreso
select *
from HumanResources.Department
select *
from HumanResources.Employee
select *
from Person.Person

     --Mio No funcion, revisar
select d.DepartmentID, d.Name as Departamento--, p.FirstName, p.LastName
from HumanResources.Department d inner join HumanResources.Employee e on d.DepartmentID=e.OrganizationLevel
	inner join Person.Person p on e.BusinessEntityID=p.BusinessEntityID
where d.Name='Finance'
     --Profesor Si funciona
select p.FirstName, p.LastName, d.Name as Departamento, h.StartDate as FechaIngreso
from Person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h on e.BusinessEntityID=h.BusinessEntityID
	inner join HumanResources.Department d on h.DepartmentID=d.DepartmentID
where d.Name in ('Finance','Engineering')
order by d.Name

--10. Mostrar los empleados con el ID de la orden y el monto, ordenar de mayor a menor
		--Mio Innecesariamente largo
select s.SalesOrderID, s.TotalDue, p.FirstName, p.LastName
from sales.SalesOrderHeader s inner join sales.SalesPerson sp on s.SalesPersonID=sp.BusinessEntityID 
	inner join Person.Person p on sp.BusinessEntityID=p.BusinessEntityID
order by TotalDue desc
		--Profesor Omitio una tabla
select s.SalesOrderID, s.TotalDue, p.FirstName, p.LastName
from sales.SalesOrderHeader s inner join Person.Person p on s.SalesPersonID=p.BusinessEntityID
order by s.TotalDue desc

--11. Listar el id de la orden con su monto de menor a mayor
select s.SalesOrderID, s.TotalDue
from sales.SalesOrderHeader s
order by TotalDue desc

--12. Mostrar el nombre del producto, ID de la orden y las unidades vendidas
--Ordenar por unidades de mayor a menor
select p.Name as NombreProducto, s.SalesOrderID, s.OrderQty as UnidadesVendidas
from Production.Product p inner join Sales.SalesOrderDetail s on p.ProductID=s.ProductID
order by s.OrderQty desc

--13. Listar el nombre del producto, el nombre de la subcategoria y categoria
select *
from Production.Product
select *
from Production.ProductCategory
select *
from Production.ProductSubcategory

select p.Name as NombreProducto, s.Name as NombreSubcategoria, c.Name as NombreCategoria
from Production.ProductCategory c inner join Production.ProductSubcategory s on c.ProductCategoryID=s.ProductCategoryID
	inner join Production.Product p on s.ProductSubcategoryID=p.ProductSubcategoryID
order by p.Name, s.Name, c.Name

--14. Mostrar el año, mes y dia de ingreso, nombre completo del empleado y su departamento
--Ordenar por año, luego por mes de forma descendente
select year(h.StartDate) as 'Año', DATENAME(m,h.StartDate) as Mes, day(h.StartDate) as Dia,
	concat(p.firstname,space(1),p.lastname) as Empleado, d.name as Departamento
from person.Person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory h on p.BusinessEntityID=e.BusinessEntityID
	inner join HumanResources.Department d on h.DepartmentID=d.DepartmentID
order by year(h.StartDate),month(h.StartDate)
 

--15. Listar la tienda y region a la que pertenece
select *
from Sales.Store
select *
from Sales.SalesTerritory

select s.Name as Tienda, st.Name as Territorio
from sales.Store s inner join sales.SalesPerson sp on s.SalesPersonID=sp.BusinessEntityID 
	inner join Sales.SalesTerritory st on sp.TerritoryID=st.TerritoryID
order by s.Name, st.Name

--16. Mostrar el ID de orden, nombre del producto, unidades vendidas, descuento y total a pagar de los productos
--cuyas unidades son superiores a 25 y el total a a pagar entre 2500 y 7500

		--No funciona no tengo ventas de 25 con esa cantidad
		--No utilice las tablas apropiadas
select s.SalesOrderID, p.Name as NombreProducto, s.OrderQty as UnidadesVendidas, s.UnitPriceDiscount, s.LineTotal
from sales.SalesOrderDetail s inner join Production.Product p on s.ProductID=p.ProductID
where s.OrderQty>25 and s.LineTotal between 2500 and 7500
--order by s.OrderQty desc
--order by linetotal desc 

		--Profesor
select h.SalesOrderID, p.Name as Producto, d.OrderQty as Unidades, d.UnitPriceDiscount, h.TotalDue as Total
from sales.SalesOrderHeader h inner join sales.SalesOrderDetail d on h.SalesOrderID=d.SalesOrderID
	inner join production.Product  p on d.ProductID=p.ProductID
where d.OrderQty>25 and h.totaldue between 120000 and 250000