--create table empleados
--(
--	idempleado int primary key,
--	cedula nvarchar(16) not null unique,
--	nombres nvarchar(25) not null,
--	apellidos nvarchar(50) not null,
--	fechanac datetime not null,
--	direccion nvarchar(100),
--	telefono nvarchar(25),
--	celular nvarchar(25) not null unique,
--	email nvarchar(25) not null unique,
--	activo bit default 1
--)
--go
--alter table empleados add salario money
--create table ir
--(
--	idIR int identity(1,1) primary key,
--	rInicial money not null,
--	rFinal money not null,
--	porcentaje decimal(3,2) not null,
--	exceso money not null,
--	base money not null
--)
--go
--Agregar Empleados
--create procedure empleados_agregar
--(@cedula nvarchar(16),@nombres nvarchar(25),
--@apellidos nvarchar(50),@fechanac datetime,@direccion nvarchar(100),
--@telefono nvarchar(25),@celular nvarchar(25),@email nvarchar(25),@resultado int output)
--as
--	begin try
--		declare @codigo int,@ced bit,@cel bit, @correo bit
--		select @ced=count(*) from empleados where cedula=@cedula
--		select @cel=count(*) from empleados where celular=@cel
--		select @correo=count(*) from empleados where email=@email
--		if @ced=0 and @cel=0 and @correo=0
--		begin
--			select @codigo =isnull(max(idempleado),0)+1 from empleados
--			begin transaction
--				insert into empleados
--					values(@codigo,@cedula,@nombres,@apellidos,@fechanac,@direccion,
--						@telefono,@celular,@email,1)
--			commit transaction
--			set @resultado=1
--		end
--		else
--			set @resultado=2
--			return @resultado
--	end try
--	begin catch
--		set @resultado=0
--		rollback transaction
--		return @resultado
--	end catch
--go
--Mostrar Empleados
--create procedure empleados_mostrar(@idempleado int=0)
--as
--	if @idempleado=0
--		select * from empleados
--	else
--		select * from empleados where idempleado=@idempleado
--go
--Actualizar Empleado
--create procedure empleado_actualizar
--(@idempleado int,@cedula nvarchar(16),@nombres nvarchar(25),@apellidos nvarchar(50),@fechanac datetime,
--@direccion nvarchar(100),@telefono nvarchar(25),@celular nvarchar(25),@email nvarchar(25),@activo bit,@resultado int output)
--as
--	begin try
--		declare @codigo int,@ced bit,@cel bit, @correo bit
--		select @ced=count(*) from empleados where cedula=@cedula
--		select @cel=count(*) from empleados where celular=@cel
--		select @correo=count(*) from empleados where email=@email
--		begin transaction
--			update empleados
--			set cedula=@cedula,nombres=@nombres,apellidos=@apellidos,
--				fechanac=@fechanac,direccion=@direccion,telefono=@telefono,
--				celular=@celular,email=@email,activo=@activo
--			where idempleado=@idempleado
--		commit transaction
--		set @resultado=1
--	end try
--	begin catch
--		set @resultado=0
--		rollback transaction
--		return @resultado
--	end catch
--go
--Ejecuciones
--declare @r int
--execute empleados_agregar'001-130490-0044f','Francisco Renan','Donaire Tablada','19900413','A Villa Libertad...',
--	'84722043','84722043','fran.renan.dt@gmail.com',7300,@r output
--select case @r
--	when 1 then 'Registro almacenado correctamente'
--	when 2 then 'Registro duplicado'
--	when 3 then 'Error procesando la solicitud'
--end as Resultado

--declare @r int
--execute empleados_agregar'002-130490-0044f','Renan','Tablada','19900413','A Villa Libertad...',
--	'48484848','48484848','renan.dt@gmail.com',7500,@r output
--select case @r
--	when 1 then 'Registro almacenado correctamente'
--	when 2 then 'Registro duplicado'
--	when 3 then 'Error procesando la solicitud'
--end as Resultado

--declare @r int
--execute empleado_actualizar 1,'001-130490-0044f','Francisco Renan','Donaire Tablada','19900413','A Villa Libertad...',
--	'60606060','60606060','fran.renan.dt@gmail.com',8000,1,@r output
--select case @r
--	when 1 then 'Registro almacenado correctamente'
--	when 2 then 'Registro duplicado'
--	when 3 then 'Error procesando la solicitud'
--end as Resultado

--Funciones Escalar INSS
--go
alter table empleados add salario money

create function inss(@salario money)
returns money
as
	begin
		declare @pago money
		set @pago=@salario*0.0625
		return @pago
	end
go
--insert into ir values (1,100000,0,0,0),(100000.01,200000,0.15,100000,0),
--(200000.01,350000,0.20,200000,15000),(350000.01,500000,0.25,350000,42500),
--(500000.01,9999999.99,0.30,500000,82500)
--select * from ir

--alter function pagoIr(@salario money)
--returns money
--as
--	begin
--		declare @salAnual money,@tasa decimal(3,2),@exceso money,@base money,@pago money
--		set @salAnual=(@salario-dbo.inss(@salario))*12
--		select @tasa=porcentaje from ir where @salAnual between rInicial and rFinal
--		select @exceso=exceso from ir where @salAnual between rInicial and rFinal
--		select @base=base from ir where @salAnual between rInicial and rFinal
--		set @pago=((@salAnual-@exceso)*@tasa+@base)/12
--		return @pago
--	end
--go
--create function deduccion(@salario money)
--returns money
--as
--	begin
--		return (dbo.inss(@salario)+dbo.pagoir(@salario))
--	end
--go
--create function pago(@salario money)
--returns money
--as
--	begin
--		return (@salario-dbo.deduccion(@salario))
--	end
--go
select nombres,apellidos,salario,dbo.inss(salario) as Inss,dbo.pagoir(salario) as PagoIRMensual,
	dbo.deduccion(salario) as Deducciones, dbo.pago(salario) as SalarioNeto
from empleados

--Funciones de tipo Tabla
--create function ftabla()
--returns table
--as
--	return(select * from empleados)
--go

select * from dbo.ftabla()

--Triggers
--create table bitacora
--(
--	idbitacora int identity(1,1) primary key,
--	fecha datetime default getdate(),
--	equipo nvarchar(50) default host_name(),
--	usuario nvarchar(50) default user_name(),
--	tabla nvarchar(50) not null,
--	operacion nvarchar(50) not null,
--	oldData nvarchar(4000) not null,
--	newData nvarchar(4000) not null
--)
--go

--create trigger traza on empleados
--for insert
--as
--	begin
--		declare @new nvarchar(4000)
--		select @new= concat(idempleado,'; ',cedula,'; ',nombres,' ',apellidos,'; ',fechanac,'; ',
--			direccion,'; ',telefono,'; ',celular,'; ',email,'; ',activo,'; ',salario) from inserted
--		insert into bitacora(tabla,operacion,oldData,newData) values ('empleados','agregar','',@new) 
--	end
--go
--create trigger templeados_modificar on empleados
--for update --para update insert deleted
--as
--	begin
--		declare @old nvarchar(4000), @new nvarchar(4000)
--		select @old= concat(idempleado,'; ',cedula,'; ',nombres,' ',apellidos,'; ',fechanac,'; ',
--			direccion,'; ',telefono,'; ',celular,'; ',email,'; ',activo,'; ',salario) from deleted
--		select @new= concat(idempleado,'; ',cedula,'; ',nombres,' ',apellidos,'; ',fechanac,'; ',
--			direccion,'; ',telefono,'; ',celular,'; ',email,'; ',activo,'; ',salario) from inserted
--		insert into bitacora(tabla,operacion,oldData,newData) values ('empleados','agregar',@old,@new) 
--	end
--go



--select *
--from bitacora