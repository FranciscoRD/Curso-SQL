--Mostrar el Id de la Orden y Monto total pagado
select SalesOrderID as IDOrden, TotalDue as MontoPago
from sales.SalesOrderHeader
go;

--1. Mostrar los campos de la tabla Persona
select *
from Person.Person

--2. Mostrar el nombre1, apellido, 
select FirstName as Nombre1, LastName as Apellido
from person.Person

select FirstName+' '+MiddleName+' '+LastName as Nombre
from Person.Person

select FirstName+' '+isnull(MiddleName,'')+' '+LastName as Nombre
from Person.Person

select concat(FirstName,SPACE(1),MiddleName,Space(1),LastName) as Personal
from Person.Person

--3. Mostrar el codigo de producto y el nombre
select ProductID, name as Nombre
from Production.Product

--4. Listar el ID de Orden, ID producto, Cantidades, Precio Unitario, Descuento %
--Descuento Monto, Importe de Linea
select SalesOrderID as IDOrden,ProductID as IDProducto, OrderQty as Cantidades, UnitPrice as "Precio Unitario", 
		CONCAT(UnitPriceDiscount*100,'%') as "Descuento%", 
		OrderQty*UnitPrice*UnitPriceDiscount as "MontoDesc",
		LineTotal as "Monto Total"  
from sales.SalesOrderDetail
where UnitPriceDiscount>0

--5. Mostrar el id de departamento y nombre del mismo
select DepartmentID as "IDDepartamento", Name as Nombre
from HumanResources.Department

--6. Mostrar el id de empleado, id del departamento, fecha de inicio y final de trabajo
select BusinessEntityID as IDEmpleado, DepartmentID as IDDepartamento, 
		convert(nvarchar(12),StartDate)+' / '+ISNULL(CONVERT(nvarchar(12),Enddate),'trabajando') as PeriodoLaboral
from HumanResources.EmployeeDepartmentHistory

--7. Mostrar el id de la tienda con su nombre
select BusinessEntityID as IDTienda, Name as Nombre
from sales.Store

--8. Listar el codigo de subcategoria y su nombre
select ProductSubcategoryID as IDSubcategoria, Name as Nombre
from Production.ProductSubcategory

--9. Mostrar el codigo de la categoria con su nombre
select ProductCategoryID as IDCategoria, Name as Nombre
from Production.ProductCategory

--10. Mostrar las ordenes cuyo monto superan los $10,000
select SalesOrderID as IDOrdenes, TotalDue as Total
from sales.SalesOrderHeader
where TotalDue>10000
order by TotalDue




------------------------------------------------------------------------------------------------------------------
--Consultas de mas de 1 tabla
create database Biblioteca
go
 create table categoria
 (
	idcategoria int identity(1,1) primary key,
	categoria nvarchar(25) not null unique,
	descripcion nvarchar(50)
 )
 go
 insert into categoria values
 ('Biologia',null),
 ('Anatomia',null),
 ('Fisica','Fisica General'),
 ('Informatica','Ciencias de la Computacion')
 go

 create table libros
 (
	isbn nvarchar(13) primary key,
	idcategoria int not null,
	titulo nvarchar(50) not null,
	descripcion nvarchar(100),
	constraint fk_libros_categoria foreign key(idcategoria) references categoria(idcategoria)  
 )

 insert into libros values
 ('123456789',1,'Biologia General',null),
 ('987654321',2,'Anatomia General',null),
 ('654987321',3,'Fisica General', 'Fisica Basica'),
 ('254879345',3,'Dinamica',null),
 ('753146952',4,'Bases de Datos','Analisis y Diseño')

 use Biblioteca
 select *
 from libros

 select l.isbn, c.categoria,l.titulo,l.descripcion
 from categoria c inner join libros l on c.idcategoria=l.idcategoria

 -----------------------------------------------------------------------
 -----------------------------------------------------------------------
 use AdventureWorks

 --1. Mostrar el nombre y apellido de personal, fecha de nacimiento, genero, estado civil
 select p.FirstName+' '+p.LastName NombrePersonal, e.BirthDate as FechaNacimiento, e.MaritalStatus,
	case e.gender
		when 'M' then 'Masculino'
		when 'F' then 'Femenino'
	end as Genero,
	case e.maritalstatus
		when 'S' then 'Soltero'
		else 'Casado'
	end as EstadoCivil
 from Person.person p inner join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID

 --2. Listar el id de orden, nombre del producto, cantidad de unidades, precio unitario,
 --monto del descuento e importe de la linea
 select s.SalesOrderID, p.Name, s.OrderQty, s.UnitPrice, CONCAT(s.UnitPriceDiscount*100,'%') as "Descuento%", s.LineTotal as ImporteTotal
 from sales.SalesOrderDetail s inner join Production.Product p on s.ProductID=p.ProductID 
 where s.UnitPriceDiscount>0

 --3. Mostrar el id de la orden, monto total y nombre completo del empleado que la atendio
 select s.SalesOrderID as IDOrden, s.TotalDue, p.FirstName+''+p.LastName as Nombre 
 from Sales.SalesOrderHeader s inner join person.Person p on s.SalesPersonID=p.BusinessEntityID

 --4. Listar el codigo del producto, nombre del producto con el nombre de subcategoria a la 
 --cual pertenece
 select p.ProductID as IDProducto, p.Name as Producto, s.Name as SubCategoria
 from Production.Product p inner join Production.ProductSubcategory s on p.ProductSubcategoryID=s.ProductSubcategoryID
	
 --5. Mostrar el nombre de la tienda, nombre del vendedor, id de la orden y monto facturado
 select st.Name as Tienda, p.FirstName+' '+p.LastName as Vendedor, h.SalesOrderID as IDOrden, h.TotalDue as MontoFactura
 from sales.SalesOrderHeader h inner join sales.SalesPerson s on h.SalesPersonID=s.BusinessEntityID inner join Sales.Store st
		on st.SalesPersonID=s.BusinessEntityID inner join person.Person p on
		p.BusinessEntityID=s.BusinessEntityID
