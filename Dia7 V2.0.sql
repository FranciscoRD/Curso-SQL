--Sesion #7 
/*
Funciones
  + Escalones
  + Registros

Procedimientos almacenados
  + Mostrar
  + Agregar
  + Actualizar
  + Eliminar
  + Parametros
    - Opcionales
	- Retorno
*/

create database nomina
go
use nomina
create table cargos
(
	idCargo int primary key,
	cargo nvarchar(25) unique not null,
	salMin money not null,
	salMax money not null,
	descripcion nvarchar(100)
)
go
create table departamentos
(
	idDepto int primary key,
	depto nvarchar(25) unique not null,
	descripcion nvarchar(100)
)
go
create table empresas
(
	idEmpresa int primary key,
	Ruc nvarchar(15) unique not null,
	empresa nvarchar(50) not null,
	siglas nvarchar(25),
	website nvarchar(50),
	email nvarchar(50) unique not null
)
go
create table sucursales
(
	idSucursal int primary key,
	idEmpresa int not null,
	sucursal nvarchar(50) not null,
	direccion nvarchar(100) not null,
	telefono nvarchar(25) not null,
	constraint fk_suc_emp foreign key (idEmpresa) 
	references empresas(idEmpresa)  
)
go
create table sucursal_deptos
(
	idSucDept int primary key,
	idSucursal int not null,
	idDepto int not null,
	constraint fk_sd_suc foreign key (idSucursal) 
	references sucursales(idSucursal),
	constraint fk_sd_dep foreign key (idDepto) 
	references departamentos(idDepto)
)
go
create table curriculum
(
	idCV int primary key,
	cedula nvarchar(16) unique not null,
	noInss nvarchar(15) unique,
	nombres nvarchar(25) not null,
	apellidos nvarchar(50) not null,
	fechaNac smalldatetime not null,
	direccion nvarchar(100),
	genero nvarchar(25) not null,
	estadoCivil nvarchar(50) not null
)
go
create table gradoAcademico
(
	idGrado int primary key,
	gradoAcad nvarchar(25) unique not null,
	descripcion nvarchar(50)
)
go
create table historial_academico
(
	idhAcad int primary key,
	idCV int not null,
	idGrado int not null,
	titulo nvarchar(50) not null,
	institucion nvarchar(100) not null,
	fechaEmision smalldatetime not null,
	constraint fk_ha_cv foreign key (idCV)
	references curriculum(idCV),
	constraint fk_ha_gra foreign key (idGrado)
	references gradoAcademico (idGrado)
)
go 
create table historial_laboral
(
	idhLaboral int primary key,
	idCV int not null,
	empresa nvarchar(50) not null,
	cargo nvarchar(50) not null,
	salario money not null,
	fIngreso smalldatetime not null,
	fSalida smalldatetime not null,
	superior nvarchar(100),
	telefono nvarchar(25),
	constraint fk_hl_cv foreign key (idCV)
	references curriculum (idCV)
)
go
create table referencias
(
	idRef int primary key,
	idCV int not null,
	nombres nvarchar(25) not null,
	apellidos nvarchar(50) not null,
	empresa nvarchar(50),
	cargo nvarchar(25),
	telefono nvarchar(25),
	celular nvarchar(25),
	email nvarchar(50),
	observaciones nvarchar(100),
	constraint fk_ref_cv foreign key (idCV)
	references curriculum(idCV)
)
go
create table historial_cargos
(
	idhCargos int primary key,
	idCV int not null,
	idSucDept int not null,
	idCargo int not null,
	salario money not null,
	fIngreso smalldatetime not null,
	fsalida smalldatetime,
	observaciones nvarchar(100),
	constraint fk_hc_cv foreign key (idCV)
	references curriculum(idCV),
	constraint fk_hc_sd foreign key (idSucDept)
	references sucursal_deptos(idSucDept),
	constraint fk_hc_car foreign key (idCargo)
	references cargos(idCargo)
)
------------------------------------------------------------------------
--		Procedimientos de Cargos
alter table cargos add activo bit default 1

-- Mostar
alter procedure cargos_mostrar(@idcargo int=0)
as 
	if @idcargo=0
		select * from cargos
	else
		select *from cargos where idcargo=@idcargo
go
-- Agregar
alter procedure cargos_agregar
(@cargo nvarchar(25), @salmin money,@salmax money,@descripcion nvarchar(100),@activo bit)
as
	begin
		declare @codigo int,@existe int
		select @existe=count(*) from cargos where cargo=@cargo
		if @existe =0
		begin
			select @codigo=isnull(max(idcargo),0)+1 from cargos
			insert into cargos 
				values(@codigo,@cargo,@salmin,@salmax,@descripcion,1)
		end
	end
go
-- Actualizar
alter procedure cargos_actualizar
(@idcargo int,@cargo nvarchar(25), @salmin money,@salmax money,@descripcion nvarchar(100),@activo bit)
as
	update cargos
	set cargo=@cargo,salMin=@salmin,salMax=@salmax,descripcion=@descripcion, activo=@activo
	where idcargo=@idcargo
go
-- Elimnar
create procedure cargos_eliminar(@idcargo int)
as
	update cargos
	set activo=0
	where idcargo=@idcargo
go
-- Ejecuciones
execute cargos_mostrar
exec cargos_mostrar 4

execute cargos_agregar 'Gerente',80000,60000,'Gerente de la Empresa',1
execute cargos_agregar 'Vice Gerente',70000,50000,'Vice Gerente de la Empresa',1
execute cargos_agregar 'Director de Informatica',50000,45000,'Director Tic',1
execute cargos_agregar 'Contador',40000,35000,'Contador General',1
execute cargos_agregar 'Director de RRHH',35000,30000,null,1
execute cargos_agregar 'Inspector',30000,25000,null,1

execute cargos_actualizar 5,'Director de RRHH',35000,30000,'Capital Humano',1

execute cargos_eliminar 4

-----------------------------------------------------------------------------------------
--		Procedimientos de Departamentos
alter table departamentos add activo bit default 1
-- Mostar
alter table 
create procedure departamentos_mostrar(@iddepto int=0)
as 
	if @iddepto=0
		select * from departamentos
	else
		select *from departamentos where idDepto=@iddepto
go
-- Agregar
alter procedure departamento_agregar
(@depto nvarchar(25), @descripcion nvarchar(100),@activo bit)
as
	begin
		declare @codigo int,@existe int
		select @existe=count(*) from departamentos where depto=@depto
		if @existe =0
		begin
			select @codigo=isnull(max(iddepto),0)+1 from departamentos
			insert into departamentos 
				values(@codigo,@depto,@descripcion,@activo)
		end
	end
go
alter procedure departamento_agregar
(@depto nvarchar(25),@descripcion nvarchar(100))
as
	begin
		declare @codigo int
		if not exists(select * from departamentos where depto=@depto)
			select @codigo=isnull(max(iddepto),0)+1 from departamentos
			insert into departamentos
				values(@codigo,@depto,@descripcion,1)
	end
go
-- Actualizar
alter procedure departamento_actualizar
(@iddepto int,@depto nvarchar(25),@descripcion nvarchar(100),@activo bit)
as
	update departamentos
	set depto=@depto,descripcion=@descripcion,activo=@activo
	where idDepto=@iddepto
go
-- Elimnar
create procedure departamentos_eliminar(@iddepto int)
as
	update departamentos
	set activo=0
	where idDepto=@iddepto
go

--Ejecuciones
exec departamento_agregar 'RRHH','Area de control y manejo del personal que labora',1
exec departamento_agregar 'Legal','Area de registro de informacion y aistencia legal',1
exec departamento_agregar 'Financiera','Area de manejo de recursos economicos',1
exec departamento_agregar 'TIC','Area Control y planificacion de tecnologias y recursos informaticos',1
exec departamento_agregar 'Gerencia','Area superior de la empresa de los diferentes gerentes de area',1
exec departamento_agregar 'AsistenciaalCliente','Area X'

execute departamentos_mostrar 3

execute departamentos_eliminar 3

exec departamento_actualizar 6,'AsistenciaalCliente','Area de resolucion de inconvenientes con los clientes',1

-----------------------------------------------------------------------------------------
--		Procedimientos de Empresas

alter table empresas add activo bit not null default 1

-- Mostar
alter table 
create procedure empresas_mostrar(@idempresa int=0)
as 
	if @idempresa=0
		select * from empresas
	else
		select *from empresas where idEmpresa=@idempresa
go
-- Agregar
--@resultado generara:
--	0=>no se agrego; 1=>registro almacenado
--	2=>registro ya existe
create procedure empresas_agregar
(@ruc nvarchar(15),@empresa nvarchar(50),@siglas nvarchar(25),@website nvarchar(50),@email nvarchar(50),@resultado int output)
as
	begin try
		declare @codigo int,@exRuc bit,@exEmpresa bit, @exEmail bit
		select @exRuc=count(*) from empresas where ruc=@ruc
		select @exEmpresa=count(*) from empresas where empresa=@empresa
		select @exEmail=count(*) from empresas where email=@email
		if @exRuc=0 and @exEmpresa=0 and @exEmail=0
		begin
			select @codigo =isnull(max(idEmpresa),0)+1 from empresas
			insert into empresas
				values(@codigo,@ruc,@empresa,@siglas,@website,@email,1)
				set @resultado=1
		end
		else
			set @resultado=2
			return @resultado
	end try
	begin catch
		set @resultado=0
		return @resultado
	end catch
go

	--Modo transaccion
alter procedure empresas_agregar
(@ruc nvarchar(15),@empresa nvarchar(50),@siglas nvarchar(25),@website nvarchar(50),@email nvarchar(50),@resultado int output)
as
	begin try
		declare @codigo int,@exRuc bit,@exEmpresa bit, @exEmail bit
		select @exRuc=count(*) from empresas where ruc=@ruc
		select @exEmpresa=count(*) from empresas where empresa=@empresa
		select @exEmail=count(*) from empresas where email=@email
		if @exRuc=0 and @exEmpresa=0 and @exEmail=0
		begin
			select @codigo =isnull(max(idEmpresa),0)+1 from empresas
			begin transaction
				insert into empresas
					values(@codigo,@ruc,@empresa,@siglas,@website,@email,1)
			commit transaction
			set @resultado=1
		end
		else
			set @resultado=2
			return @resultado
	end try
	begin catch
		set @resultado=0
		rollback transaction
		return @resultado
	end catch
go

-- Actualizar
create procedure empresa_actualizar
(@idempresa int,@ruc nvarchar(15),@empresa nvarchar(50),@siglas nvarchar(25),@website nvarchar(50),@email nvarchar(50),@activo bit)
as
	update empresas
	set Ruc=@ruc,empresa=@empresa,siglas=@siglas,website=@website,email=@email,activo=@activo
	where idEmpresa=@idempresa
go
-- Elimnar
create procedure empresa_eliminar(@idempresa int)
as
	update empresas
	set activo=0
	where idEmpresa=@idempresa
go

--Ejecuciones
declare @salida int
execute empresas_agregar '21001223353','Copasa S.A','www.copasa.com.ni','Copasa','info@copasa.com.ni',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end

execute empresas_mostrar
execute empresa_actualizar 1,'21001223353','Copasa','Copasa S.A.','www.copasa.com.ni','info@copasa.com.ni',1