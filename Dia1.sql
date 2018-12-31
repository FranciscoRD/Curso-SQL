--Todos llos datos de la tabla persona.persona4
select *
from Person.Person
go;
--Mostrar el codigo de personal, titulo, 1er - 2do nombre
--y ultimo
select BusinessEntityID, Title, FirstName,MiddleName,LastName
from person.Person
go;

--Mostrar el codigo de empleado, fecha de nacimiento, estado civil y genero
select BusinessEntityID as [Codigo], BirthDate as [Fecha Nac.], MaritalStatus as [Estado Civil], Gender as [Genero]
from HumanResources.Employee
go;

select BusinessEntityID as [Codigo], BirthDate as [Fecha Nac.], MaritalStatus as [Estado Civil], Gender as [Genero]
from HumanResources.Employee
go;

--Mostrar todos los departamentos
select *
from HumanResources.Department
go;

--Mostrar el codigo y nombre del departamento
select DepartmentID as [ID],Name as [Departamento]
from HumanResources.Department
go;

--Mostrar el numero de orden, fecha de venta y monto total
select SalesOrderID as ID, OrderDate as FechaVenta, TotalDue as MontoTotal
from sales.SalesOrderHeader
go;

--Mostrar el Id de la orden, Codigo del articulo, Unidades, precio unitario e importe
select SalesOrderID as OrdenId, ProductID as ProductId , OrderQty as Cantidad,UnitPrice as [Precio Unitario],
		concat(UnitPriceDiscount*100,'%') as "%Descuento", OrderQty*UnitPrice*UnitPriceDiscount AS "Monto Desc", 
		OrderQty*UnitPrice*(1-UnitPriceDiscount) as Pago ,LineTotal as Importe  
from sales.SalesOrderDetail
where UnitPriceDiscount>0

--Mostrar el codigo del empleado, codigo de departamento, fecha de inicio y final del cargo
select BusinessEntityID as EmpleadoID,DepartmentID as DepartamentoID ,StartDate as FechaInicio, EndDate as FinalCargo
from HumanResources.EmployeeDepartmentHistory
		--Mostrando la fecha actuaol ya que no lo han corrido
select BusinessEntityID as EmpleadoID,DepartmentID as DepartamentoID ,StartDate as FechaInicio, 
		ISNULL(EndDate,GETDATE()) as FinalCargo
from HumanResources.EmployeeDepartmentHistory
		--Mostrando etiqueta en vez de null
select BusinessEntityID as EmpleadoID,DepartmentID as DepartamentoID ,StartDate as FechaInicio, 
		isnull(CONVERT(nvarchar(12),Enddate),'laborando') as FinalCargo
from HumanResources.EmployeeDepartmentHistory

--Listar los productos cuyo color es blanco
select ProductID as ProductoID, Name as Nombre,Color ,ListPrice as Precio, Size as 'Tamaño'
from.Production.Product
where Product.Color='white'

select ProductID as ProductoID, Name as Nombre,Color ,ListPrice as Precio, Size as 'Tamaño'
from.Production.Product
where Product.Color in ('white', 'red')

select ProductID as ProductoID, Name as Nombre,Color ,ListPrice as Precio, Size as 'Tamaño'
from.Production.Product
where Product.Color='white' or product.Color='red'

--Mostrar el codigo de la tienda y su nombre
select BusinessEntityID as TiendaID, Name as Nombre
from sales.Store
