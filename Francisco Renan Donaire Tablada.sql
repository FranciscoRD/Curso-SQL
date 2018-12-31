/*
	Autor: Francisco Renan Donaire Tablada
	Numeros de ejercicios: 12
	Resueltos:		8 ->	1,2,3,4,5,6,10,11
	Incompletos:	4 ->	7,8,9,12
*/
--1. Mostrar el titulo del libro y sus autores
select t.title as Libro, a.au_lname+', '+a.au_fname as Autor
from dbo.titles t inner join dbo.titleauthor ta on t.title_id=ta.title_id
	inner join dbo.authors a on ta.au_id=a.au_id
group by t.title,a.au_lname+', '+a.au_fname
order by t.title asc

--2. Indicar el titulo del libro y la cantidad de autores
select t.title as Libro, count(a.au_id) as CantidadAutores
from dbo.titles t inner join dbo.titleauthor ta on t.title_id=ta.title_id
	inner join dbo.authors a on ta.au_id=a.au_id
group by t.title
order by t.title asc

--3. Mostrar el nombre de la editorial, el titulo del libro, unidades vendidas y total recaudado
select p.pub_name as Editorial, t.title as Libro, sum(s.qty) as CantidadesVendidas, (sum(s.qty)*t.price) as Ventas
from dbo.publishers p inner join dbo.titles t on t.pub_id=p.pub_id
	inner join dbo.sales s on t.title_id=s.title_id
group by p.pub_name, t.title,t.price

--4. Listar el nombre de la editorial y la cantidad de empleados que laboran para ella
select p.pub_name as Editorial, COUNT(*) as TotalEmpleados
from dbo.publishers p inner join dbo.employee e on p.pub_id=e.pub_id
group by p.pub_name

--5. Mostrar el nombre de la tienda, titulo del libro, unidades vendidas y total de ventas
select st.stor_name as Tienda, t.title as Libro, sum(s.qty) as CantidadesVendidas, (sum(s.qty)*t.price) as Ventas
from dbo.stores st inner join dbo.sales s on st.stor_id=s.stor_id 
	inner join dbo.titles t on s.title_id=t.title_id
group by st.stor_name, t.title,t.price

--6. Listar el año de ventas, titulo de libro, total de unidades y total recaudado
select YEAR(s.ord_date) as AñoVenta,t.title as Libro,sum(s.qty) as CantidadesVendidas, (sum(s.qty)*t.price) as Ventas
from dbo.sales s inner join dbo.titles t on s.title_id=t.title_id
group by YEAR(s.ord_date),t.title,t.price

--7. Mostrar  el nombre completo del autor y el total de ingresos por año
		--Corregir
		--1. Algunos autores tienen mas de un libro eso altera el resultado del group by
select a.au_lname+', '+a.au_fname as Autor, year(s.ord_date) as Año,-- t.title as Libro,
	(sum(s.qty)*t.price) as Ganancias
from dbo.authors a inner join dbo.titleauthor ta on a.au_id=ta.au_id
	inner join dbo.titles t on ta.title_id=t.title_id
	inner join dbo.sales s on t.title_id=s.title_id
group by YEAR(s.ord_date),a.au_lname+', '+a.au_fname,t.price--,t.title,t.price
order by a.au_lname+', '+a.au_fname

--8. Listar año de venta y el titulo del libro mas vendidos por año
		--Corregir
		--1. Verificar como sacar el primer registro de cada grupo
select YEAR(s.ord_date) as AñoVenta, t.title as Libro,SUM(s.qty)as CantidadesVendidas
from dbo.sales s inner join dbo.titles t on s.title_id=t.title_id
group by year(s.ord_date),t.title
order by year(s.ord_date),SUM(s.qty) desc

--9. Mostrar el año, autor, total de ingreso por año y por mes
		--Corregir por año y por mes, el mismo error por autores con mas de un libro
select a.au_lname+', '+a.au_fname as Autor,year(s.ord_date) as Año,(sum(s.qty)*t.price) as GananciasAnuales,
	case MONTH(s.ord_date)
		when 1 then 'Enero'
		when 2 then 'Febreo'
		when 3 then 'Marzo'
		when 4 then 'Abril'
		when 5 then 'Mayo'
		when 6 then 'Junio'
		when 7 then 'Julio'
		when 8 then 'Agosto'
		when 9 then 'Septiembre'
		when 10 then 'Octubre'
		when 11 then 'Noviembre'
		when 12 then 'Diciembre'
	end as Mes,
	(sum(s.qty)*t.price) as GananciasMensuales
from dbo.authors a inner join dbo.titleauthor ta on a.au_id=ta.au_id
	inner join dbo.titles t on ta.title_id=t.title_id
	inner join dbo.sales s on t.title_id=s.title_id
group by year(s.ord_date),a.au_lname+', '+a.au_fname,t.price,MONTH(s.ord_date)
order by year(s.ord_date)

		--Los libros que aparecen en mas de una orden fueron vendido es el mismo mes del mismo año
--select t.title,s.ord_num, s.ord_date
--from dbo.sales s inner join dbo.titles t on s.title_id=t.title_id
--group by t.title,s.ord_num, s.ord_date

--10. Listar el titulo del libro, nombre del autor de aquellos que recibieron un anticipo
select t.title as Libro,a.au_lname+', '+a.au_fname as Autor, t.advance
from dbo.titles t inner join dbo.titleauthor ta on t.title_id=ta.title_id
	inner join dbo.authors a on ta.au_id=a.au_id
where t.advance >0.0 and t.advance is not null

--11. Mostrar los autores, tipo de libro y la cantidad de unidades
select a.au_lname+', '+a.au_fname as Autor, t.type as TipoLibro, SUM(s.qty) as Cantidades
from dbo.titles t inner join dbo.titleauthor ta on t.title_id=ta.title_id
	inner join dbo.authors a on ta.au_id=a.au_id 
	inner join dbo.sales s on s.title_id=t.title_id
group by a.au_lname+', '+a.au_fname, t.type
order by a.au_lname+', '+a.au_fname
	--Nota:Los autores que no tienen contrato no tienen libro

--12. Listar el tipo de libro, unidades vendidas y total de recaudado por año de venta
		--Corregir error generado por los diferentes precios de libros altera la formula group by y sum
select t.type as TipoLibro, year(s.ord_date) as Año,sum(s.qty) as UnidadesVendidas,
	 (sum(s.qty)*t.price) as Recaudados
from dbo.sales s inner join dbo.titles t on s.title_id=t.title_id
group by t.type, year(s.ord_date), t.price
order by t.type
