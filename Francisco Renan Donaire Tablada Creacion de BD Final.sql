/*
	Autor: Francisco Renan Donaire Tablada
	Este script crea la base de datos Nomina, sus respectivas tablas, agrega el campo activo a las diferentes tablas
		y crea los triggeres de las tablas
	Lista de Tablas:
	- Cargos
	- Departamentos
	- Empresas
	- Sucursales
	- Sucursal_Deptos
	- Curriculum
	- GradoAcademico
	- Historial_Academico
	- Historial_Laboral
	- Referencias
	- Historial Cargos
	- Empleados
	- IR
	- Bitacora
*/

--Creacion de BD Nomina
create database nomina
go
use nomina
go
--Creacion de Tabla Cargos
create table cargos
(
	idCargo int primary key,
	cargo nvarchar(25) unique not null,
	salMin money not null,
	salMax money not null,
	descripcion nvarchar(100)
)
go
--Creacion de Tabla Departamentos
create table departamentos
(
	idDepto int primary key,
	depto nvarchar(25) unique not null,
	descripcion nvarchar(100)
)
go
--Creacion de Tabla de Empresas
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
--Creacion de Tabla Sucursales
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
--Creacion de Tabla Sucursal Departamentos
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
--Creacion de Tabla Curriculum
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
--Creacion de Tabla Grado Academico
create table gradoAcademico
(
	idGrado int primary key,
	gradoAcad nvarchar(25) unique not null,
	descripcion nvarchar(50)
)
go
--Creacion de Tabla Historial Academico
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
--Creacion de Tabla Historial Laboral
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
--Creacion de Tabla Referencias
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
--Creacion de Tabla Historial de Cargos
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
go
--Creacion de Tabla Empleados
create table empleados
(
	idempleado int primary key,
	cedula nvarchar(16) not null unique,
	nombres nvarchar(25) not null,
	apellidos nvarchar(50) not null,
	fechanac datetime not null,
	direccion nvarchar(100),
	telefono nvarchar(25),
	celular nvarchar(25) not null unique,
	email nvarchar(25) not null unique,
	salario money not null
)
go
--Creacion de Tabla IR
create table ir
(
	idIR int identity(1,1) primary key,
	rInicial money not null,
	rFinal money not null,
	porcentaje decimal(3,2) not null,
	exceso money not null,
	base money not null
)
go
--Creacion de Tabla Bitacora
create table bitacora
(
	idbitacora int identity(1,1) primary key,
	fecha datetime default getdate(),
	equipo nvarchar(50) default host_name(),
	usuario nvarchar(50) default user_name(),
	tabla nvarchar(50) not null,
	operacion nvarchar(50) not null,
	oldData nvarchar(4000) not null,
	newData nvarchar(4000) not null
)
go

--Alteracion de Tablas Agregado de Componente Activo
alter table cargos add activo bit default 1
alter table departamentos add activo bit default 1
alter table empresas add activo bit default 1
alter table curriculum add activo bit default 1
alter table gradoAcademico add activo bit default 1
alter table sucursales add activo bit default 1
alter table sucursal_deptos add activo bit default 1
alter table historial_academico add activo bit default 1
alter table historial_laboral add activo bit default 1
alter table referencias add activo bit default 1
alter table historial_cargos add activo bit default 1
alter table empleados add activo bit default 1
go

--Lista de Triggers
--Triggers de Cargo
create trigger insertCargo on cargos
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idcargo,'; ',cargo,'; ',salMin,' ',salMax,'; ',descripcion,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Cargos','Agregado','',@new) 
	end
go
create trigger updateCargo on cargos
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idCargo,'; ',cargo,'; ',salMin,' ',salMax,'; ',descripcion,'; ',activo) from deleted
		select @new= concat(idCargo,'; ',cargo,'; ',salMin,' ',salMax,'; ',descripcion,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Cargos','Actualizado',@old,@new) 
	end
go
--Triggers de Departamentos
create trigger insertDepartamento on departamentos
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(iddepto,'; ',depto,'; ',descripcion,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Departamentos','Agregado','',@new) 
	end
go
create trigger updateDepartamento on departamentos
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(iddepto,'; ',depto,'; ',descripcion,'; ',activo) from deleted
		select @new= concat(iddepto,'; ',depto,'; ',descripcion,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Departamentos','Actualizado',@old,@new) 
	end
go
--Triggers de Empresas
create trigger insertEmpresas on empresas
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idEmpresa,'; ',Ruc,'; ',empresa,'; ',siglas,'; ',website,';',email,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Empresas','Agregado','',@new) 
	end
go
create trigger updateEmpresas on empresas
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idEmpresa,'; ',Ruc,'; ',empresa,'; ',siglas,'; ',website,';',email,'; ',activo) from deleted
		select @new= concat(idEmpresa,'; ',Ruc,'; ',empresa,'; ',siglas,'; ',website,';',email,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Empresas','Actualizado',@old,@new) 
	end
go
--Triggers de Curriculum
create trigger insertCurriculum on curriculum
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idCV,';',cedula,';',noInss,';',nombres,';',apellidos,';',fechaNac,';',';',
			direccion,';',genero,';',estadoCivil,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Curriculum','Agregado','',@new) 
	end
go
create trigger updateCurriculum on curriculum
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idCV,';',cedula,';',noInss,';',nombres,';',apellidos,';',fechaNac,';',';',
			direccion,';',genero,';',estadoCivil,';',activo) from deleted
		select @new= concat(idCV,';',cedula,';',noInss,';',nombres,';',apellidos,';',fechaNac,';',';',
			direccion,';',genero,';',estadoCivil,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Curriculum','Actualizado',@old,@new) 
	end
go
--Triggers de Grado Academico
create trigger insertGradoAcademico on gradoAcademico
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idGrado,';',gradoAcad,';',descripcion,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('GradoAcademico','Agregado','',@new) 
	end
go
create trigger updateGradoAcademico on gradoAcademico
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idGrado,';',gradoAcad,';',descripcion,';',activo) from deleted
		select @new= concat(idGrado,';',gradoAcad,';',descripcion,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('GardoAcademico','Actualizado',@old,@new) 
	end
go
--Triggers de Sucursales
create trigger insertSucursales on sucursales
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idSucursal,';',idEmpresa,';',sucursal,';',direccion,';',telefono,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Sucursales','Agregado','',@new) 
	end
go
create trigger updateSucursales on sucursales
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idSucursal,';',idEmpresa,';',sucursal,';',direccion,';',telefono,'; ',activo) from deleted
		select @new= concat(idSucursal,';',idEmpresa,';',sucursal,';',direccion,';',telefono,'; ',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Sucursales','Actualizado',@old,@new) 
	end
go
--Triggers de Sucursales Departamentos
create trigger insertSucursal_deptos on sucursal_deptos
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idSucDept,';',idSucursal,';',idDepto,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('SucDepto','Agregado','',@new) 
	end
go
create trigger updateSucursal_deptos on sucursal_deptos
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idSucDept,';',idSucursal,';',idDepto,';',activo) from deleted
		select @new= concat(idSucDept,';',idSucursal,';',idDepto,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('SucDepto','Actualizado',@old,@new) 
	end
go
-- Triggers Historial Academico
create trigger insertHistorial_academico on historial_academico
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idhAcad,';',idCV,';',idGrado,';',titulo,';',institucion,';',fechaEmision,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistorialAcad','Agregado','',@new) 
	end
go
create trigger updateHistorial_academico on historial_academico
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idhAcad,';',idCV,';',idGrado,';',titulo,';',institucion,';',fechaEmision,';',activo) from deleted
		select @new= concat(idhAcad,';',idCV,';',idGrado,';',titulo,';',institucion,';',fechaEmision,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistorialAcad','Actualizado',@old,@new) 
	end
go
--Triggers Historial Laboral
create trigger insertHistorial_laboral on historial_laboral
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idhLaboral,';',idCV,'; ',empresa,';',cargo,';',salario,';',
			fIngreso,';',fSalida,';',superior,';',telefono,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistLaboral','Agregado','',@new) 
	end
go
create trigger updateHistorial_laboral on historial_laboral
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idhLaboral,';',idCV,'; ',empresa,';',cargo,';',salario,';',
			fIngreso,';',fSalida,';',superior,';',telefono,';',activo) from deleted
		select @new= concat(idhLaboral,';',idCV,'; ',empresa,';',cargo,';',salario,';',
			fIngreso,';',fSalida,';',superior,';',telefono,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistLaboral','Actualizado',@old,@new) 
	end
go
--Triggers Referencias
create trigger insertReferencias on referencias
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idRef,';',idCV,';',nombres,';',apellidos,';',empresa,';',cargo,';',
			telefono,';',celular,';',email,';',observaciones,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Referencias','Agregado','',@new) 
	end
go
create trigger updateReferencias on referencias
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idRef,';',idCV,';',nombres,';',apellidos,';',empresa,';',cargo,';',
			telefono,';',celular,';',email,';',observaciones,';',activo) from deleted
		select @new= concat(idRef,';',idCV,';',nombres,';',apellidos,';',empresa,';',cargo,';',
			telefono,';',celular,';',email,';',observaciones,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Referencias','Actualizado',@old,@new) 
	end
go
--Triggers Historial Cargos
create trigger insertHistorial_cargos on historial_cargos
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idhCargos,';',idCV,';',idSucDept,';',idCargo,';',
			salario,';',fIngreso,';',fsalida,';',observaciones,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistCargos','Agregado','',@new) 
	end
go
create trigger updateHistorial_cargos on historial_cargos
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idhCargos,';',idCV,';',idSucDept,';',idCargo,';',
			salario,';',fIngreso,';',fsalida,';',observaciones,';',activo) from deleted
		select @new= concat(idhCargos,';',idCV,';',idSucDept,';',idCargo,';',
			salario,';',fIngreso,';',fsalida,';',observaciones,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('HistCargos','Actualizado',@old,@new) 
	end
go
--Triggers de Empleados
create trigger insertEmpleados on empleados
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idempleado,';',cedula,';',nombres,';',apellidos,';',fechanac,';',
			direccion,';',telefono,';',celular,';',email,';',salario,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Empleados','Agregado','',@new) 
	end
go
create trigger updateEmpleados on empleados
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idempleado,';',cedula,';',nombres,';',apellidos,';',fechanac,';',
			direccion,';',telefono,';',celular,';',email,';',salario,';',activo) from deleted
		select @new= concat(idempleado,';',cedula,';',nombres,';',apellidos,';',fechanac,';',
			direccion,';',telefono,';',celular,';',email,';',salario,';',activo) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('Empleados','Actualizado',@old,@new) 
	end
go
--Triggers de IR
create trigger insertIR on ir
for insert
as
	begin
		declare @new nvarchar(4000)
		select @new= concat(idIR,';',rInicial,';',rFinal,';',porcentaje,';',exceso,';',base) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('IR','Agregado','',@new) 
	end
go
create trigger updateIR on ir
for update
as
	begin
		declare @old nvarchar(4000), @new nvarchar(4000)
		select @old= concat(idIR,';',rInicial,';',rFinal,';',porcentaje,';',exceso,';',base) from deleted
		select @new= concat(idIR,';',rInicial,';',rFinal,';',porcentaje,';',exceso,';',base) from inserted
		insert into bitacora(tabla,operacion,oldData,newData) values ('IR','Actualizado',@old,@new) 
	end
go

--Insercion de Datos en Tabla IR
insert into ir values (1,100000,0,0,0),(100000.01,200000,0.15,100000,0),
(200000.01,350000,0.20,200000,15000),(350000.01,500000,0.25,350000,42500),
(500000.01,9999999.99,0.30,500000,82500)
go
--El trigger de insertar IR se dispara una vez por que solo se ejecuta una instruccion insert aunque contenga varios registros
