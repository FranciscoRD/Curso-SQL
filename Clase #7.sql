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
	telegono nvarchar(25),
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