--use master
--create database nomina
--use master
--drop database nomina
use nomina

create table cargos
(
	idcargo int primary key ,
	cargo nvarchar(25) unique not null,
	salmin money not null,
	salmax money not null,
	descripcion nvarchar(100)
)

create table departamentos
(
	iddepto int primary key,
	depto nvarchar(25) unique not null,
	descripcion nvarchar(100)
);

create table empresas
(
	idempresa int primary key,
	ruc nvarchar(15) unique not null,
	empresa nvarchar(50) unique not null,
	siglas nvarchar(25),
	website nvarchar(50),
	email nvarchar(50) unique not null
);

create table sucursales
(
	idsucursal int primary key,
	idempresa int not null,
	sucursal nvarchar(50) not null,
	direccion nvarchar(100) not null,
	telefono nvarchar(25) not null,
	constraint fk_suc_emp foreign key(idempresa) references empresas(idempresa)
);

create table sucursal_deptos
(
	idsucdept int primary key,
	idsucursal int not null,
	iddepto int not null,
	constraint fk_sd_suc foreign key (idsucursal) references sucursales(idsucursal),
	constraint fk_sd_dep foreign key (iddepto) references departamentos(iddepto)
);
create table curriculum
(
	idcurriculum int primary key,
	cedula nvarchar(16) unique not null,
	noinss nvarchar(15) unique,
	nombres nvarchar(25) not null,
	apellidos nvarchar(50) not null,
	fechanac smalldatetime not null,
	direccion nvarchar(100),
	genero nvarchar(25) not null,
	estadocivil nvarchar(50) not null
);
create table gradoacademico
(
	idgrado int primary key,
	gradoacad nvarchar(25) unique not null,
	descripcion nvarchar(50)
);
create table historial_academico
(
	idhacad int primary key,
	idcv int not null,
	idgrado int not null,
	titulo nvarchar(50) not null,
	institucion nvarchar(100) not null,
	fechaemision smalldatetime not null,
	constraint fk_ha_vc foreign key(idcv) references curriculum(idcv),
	constraint fk_ha_gra foreign key(idgrado) references gradoacademico(idgrado)
);

create table historial_laboral
(
	idhlaboral int primary key,
	idcv int not null,
	empresa nvarchar(50) not null,
	cargo nvarchar(50) not null,
	fingreso smalldatetime not null,
	fsalida smalldatetime not null,
	salario money not null,
	superior nvarchar(100) not null,
	telefono nvarchar(25),
	constraint fk_hl_cv foreign key(idcv) references curriculum(idcv)
);

create table referencias
(
	idref int primary key,
	idcv int not null,
	nombres nvarchar(25) not null,
	apellidos nvarchar(50) not null,
	empresa nvarchar(50),
	telefono nvarchar(25),
	celular nvarchar(25),
	email nvarchar(50),
	observaciones nvarchar(100),
	constraint fk_ref_cv foreign key(idcv) references curriculum(idcv)
);
create table historial_cargos
(
	idhcargos int primary key,
	idcv  int not null,
	idsucdept int not null,
	idcargo int not null,
	salario money not null,
	fingreso smalldatetime not null,
	fsalida smalldatetime,
	observaciones nvarchar(100),
	constraint fk_hc_cv foreign key(idcv) references curriculum(idcv),
	constraint fk_hc_sd foreign key(idsucdept) references sucursal_deptos(idsucdept),
	constraint fk_hc_car foreign key(idcargo) references cargos(idcargo)
)