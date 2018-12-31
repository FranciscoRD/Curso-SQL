/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Cargos
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure cargos_mostrar(@idcargo int=0)
as 
	if @idcargo=0
		select * from cargos
	else
		select *from cargos where idcargo=@idcargo
go
-- Agregar
create procedure cargos_agregar
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
create procedure cargos_actualizar
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
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Departamentos
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure departamento_mostrar(@iddepto int=0)
as 
	if @iddepto=0
		select * from departamentos
	else
		select *from departamentos where idDepto=@iddepto
go
-- Agregar
create procedure departamento_agregar
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
create procedure departamento_actualizar
(@iddepto int,@depto nvarchar(25),@descripcion nvarchar(100),@activo bit)
as
	update departamentos
	set depto=@depto,descripcion=@descripcion,activo=@activo
	where idDepto=@iddepto
go
-- Elimnar
create procedure departamento_eliminar(@iddepto int)
as
	update departamentos
	set activo=0
	where idDepto=@iddepto
go
--Ejecuciones
exec departamento_agregar 'RRHH','Area de control y manejo del personal que labora'
exec departamento_agregar 'Legal','Area de registro de informacion y aistencia legal'
exec departamento_agregar 'Financiera','Area de manejo de recursos economicos'
exec departamento_agregar 'TIC','Area Control y planificacion de tecnologias y recursos informaticos'
exec departamento_agregar 'Gerencia','Area superior de la empresa de los diferentes gerentes de area'
exec departamento_agregar 'AsistenciaalCliente','Area X'
execute departamento_mostrar 3
execute departamento_eliminar 3
exec departamento_actualizar 6,'AsistenciaalCliente','Area de resolucion de inconvenientes con los clientes',1
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Empresas
/*-----------------------------------------------------------------------------------------*/
-- Mostar
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
declare @salida int
execute empresas_agregar '22001223353','Pali Wallmart S.A','Pali','www.pali.com.ni','info@pali.com.ni',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute empresas_agregar '23001223353','La Union Wallmart S.A','La Union','www.launion.com.ni','info@launion.com.ni',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
execute empresas_mostrar
execute empresa_actualizar 1,'21001223353','Copasa','Copasa S.A.','www.copasa.com.ni','info@copasa.com.ni',1
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Curriculum
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure curriculum_mostrar(@idcurriculum int=0)
as 
	if @idcurriculum=0
		select * from curriculum
	else
		select * from curriculum where idCV=@idcurriculum
go
-- Agregar
create procedure curriculum_agregar
(@cedula nvarchar(16),@noInss nvarchar(15),@nombres nvarchar(25),@apellidos nvarchar(50),@fechanac smalldatetime,
@direccion nvarchar(100),@genero nvarchar(25),@estadocivil nvarchar(50),@resultado int output)
as
	begin try
		declare @codigo int,@exCedula bit,@exInss bit
		select @exCedula=count(*) from curriculum where cedula=@cedula
		select @exInss=count(*) from curriculum where noInss=@noInss
		if @exCedula=0 and @exInss=0
		begin
			select @codigo =isnull(max(idcv),0)+1 from curriculum
			begin transaction
				insert into curriculum
					values(@codigo,@cedula,@noInss,@nombres,@apellidos,@fechanac,@direccion,@genero,@estadocivil,1)
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
create procedure curriculum_actualizar
(@idcv int,@cedula nvarchar(16),@noInss nvarchar(15),@nombres nvarchar(25),@apellidos nvarchar(50),@fechanac smalldatetime,
@direccion nvarchar(100),@genero nvarchar(25),@estadocivil nvarchar(50),@activo bit)
as
	update curriculum
	set cedula=@cedula,noInss=@noInss,nombres=@nombres,apellidos=@apellidos,fechaNac=@fechanac,direccion=@direccion,
		genero=@genero,estadoCivil=@estadocivil,activo=@activo
	where idCV=@idcv
go
-- Elimnar
create procedure curriculum_eliminar(@idcv int)
as
	update curriculum
	set activo=0
	where idCV=@idcv
go
--Ejecuciones
declare @salida int
execute curriculum_agregar '001-130490-0044f','032857780','Francisco Renan','Donaire Tablada','19900413','Anexo de Villa Libertad Farmacia Montecristo 1 C al sur',
	'Masculino','soltero',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute curriculum_agregar '001-140490-0044f','030857780','Jose Alexander','Acosta','19900413','P del H 1 C al sur',
	'Masculino','soltero',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute curriculum_agregar '001-130490-0034f','042857780','Angel Smith','Melendez del Valle','19900413','Tope Sur de Bello Horizonte 1 C al sur',
	'Masculino','soltero',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
execute curriculum_eliminar 2
execute curriculum_mostrar
execute curriculum_actualizar 3,'001-130490-0034f','042857780','Angel Smith','Melendez del Valle','19900413','Monte Tabor 1 C al sur',
	'Masculino','Casado',1
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Grado Academico
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure gradoacademico_mostrar(@idgrado int=0)
as 
	if @idgrado=0
		select * from gradoAcademico
	else
		select * from gradoAcademico where idGrado=@idgrado
go
-- Agregar
create procedure gradoacademico_agregar
(@gradoacad nvarchar(25),@descripcion nvarchar(50),@resultado int output)
as
	begin try
		declare @codigo int,@exgradoacad bit
		select @exgradoacad=count(*) from gradoAcademico where gradoAcad=@gradoacad
		if @exgradoacad=0
		begin
			select @codigo =isnull(max(idGrado),0)+1 from gradoAcademico
			begin transaction
				insert into gradoAcademico
					values(@codigo,@gradoacad,@descripcion,1)
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
create procedure gradoacademico_actualizar
(@idgrado int,@gradoacad nvarchar(25),@descripcion nvarchar(50),@activo bit)
as
	update gradoAcademico
	set gradoAcad=@gradoacad,descripcion=@descripcion,activo=@activo
	where idGrado=@idgrado
go
-- Elimnar
create procedure gradoacademico_eliminar(@idgrado int)
as
	update gradoAcademico
	set activo=0
	where idGrado=@idgrado
go
--Ejecuciones
declare @salida int
execute gradoacademico_agregar 'Bachiller','Culminacion de Secundaria',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute gradoacademico_agregar 'Tecnico Medio','Culminacion de Carrera Tecnica',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute gradoacademico_agregar 'Licenciado','Culminacion de Carrera Universitaria',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
declare @salida int
execute gradoacademico_agregar 'Ingeniero','Culminacion de Secundaria',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado'
end
execute gradoacademico_mostrar
execute gradoacademico_actualizar 4,'Ingeniero','Culminacion de carrera Universitaria',1
execute gradoacademico_eliminar 1
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Sucursales
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure sucursales_mostrar(@idSucursal int=0)
as 
	if @idSucursal=0
		select * from sucursales
	else
		select * from sucursales where idSucursal=@idSucursal
go
-- Agregar
		--create procedure sucursales_agregar
		--(@idempresa int,@sucursal nvarchar(50),@direccion nvarchar(100),@telefono nvarchar(25),@resultado int output)
		--as
		--	begin try
		--		declare @codigo int,@exsucursal bit,
		--		select @exsucursal=count(*) from sucursales where sucursal=@sucursal
		--		if @exsucursal=0
		--		begin
		--			select @codigo =isnull(max(idSucursal),0)+1 from sucursales
		--			begin transaction
		--				insert into sucursales
		--					values(@codigo,@idempresa,@sucursal,@direccion,@telefono,1)
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
create procedure sucursales_agregar
(@empresa nvarchar(50),@sucursal nvarchar(50),@direccion nvarchar(100),@telefono nvarchar(25),@resultado int output)
as
	begin try
		declare @codigo int,@exSucursal bit,@exEmpresa bit,@idempresa int
		select @exEmpresa=count(*) from empresas where empresa=@empresa
		if @exEmpresa=1
		begin
			select @exSucursal=count(*) from sucursales where sucursal=@sucursal
			if @exsucursal=0
			begin
				select @codigo =isnull(max(idSucursal),0)+1 from sucursales
				select @idempresa=idempresa from empresas where empresa=@empresa
				begin transaction
					insert into sucursales
						values(@codigo,@idempresa,@sucursal,@direccion,@telefono,1)
				commit transaction
				set @resultado=1
			end
			else
				set @resultado=2
				return @resultado
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
		--create procedure sucursales_actualizar
		--(@idsucursal int,@idempresa int,@sucursal nvarchar(50),@direccion nvarchar(100),@telefono nvarchar(25),@activo bit)
		--as
		--	update sucursales
		--	set idEmpresa=@idempresa,sucursal=@sucursal,direccion=@direccion,telefono=@telefono,activo=@activo
		--	where idSucursal=@idsucursal
		--go
create procedure sucursales_actualizar
(@idsucursal int,@empresa nvarchar(50),@sucursal nvarchar(50),@direccion nvarchar(100),@telefono nvarchar(25),@activo bit,@resultado int output)
as
	declare @exEmpresa bit,@idempresa int
	select @exEmpresa=count(*) from empresas where empresa=@empresa
	if @exEmpresa=1
	begin
		select @idempresa=idempresa from empresas where empresa=@empresa
		update sucursales
		set idEmpresa=@idempresa,sucursal=@sucursal,direccion=@direccion,telefono=@telefono,activo=@activo,@resultado=1
		where idSucursal=@idsucursal
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure sucursales_eliminar(@idSucursal int)
as
	update sucursales
	set activo=0
	where idSucursal=@idSucursal
go
--Ejecuciones
declare @salida int
execute sucursales_agregar 'Copasa','Bodega Sur','Tope Sur','2425-6568',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Empresa No Existe'
end
declare @salida int
execute sucursales_agregar 'La Union Wallmart S.A','Bello Horizonte','Tope Sur','2425-6568',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Empresa No Existe'
end
declare @salida int
execute sucursales_agregar 'Copasa','Bodega Norte','Tope Sur','2425-6568',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Empresa No Existe'
end
declare @salida int
execute sucursales_agregar 'Pali Wallmart S.A','Primero de Mayo','Tope Sur','2425-6568',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Empresa No Existe'
end
declare @salida int
execute sucursales_actualizar 1,'Conico','Bodega 12','Tope Sur','2425-6568',0,@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Empresa No Existe'
end
execute sucursales_mostrar
execute sucursales_eliminar 2
go;

/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Sucursal Departamentos
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure sucdeptos_mostrar(@idSucDept int=0)
as 
	if @idSucDept=0
		select * from sucursal_deptos
	else
		select * from sucursal_deptos where idSucDept=@idSucDept
go
-- Agregar
create procedure sucdeptos_agregar
(@sucursal nvarchar(50),@departamento nvarchar(25),@resultado int output)
as
	begin try
		declare @codigo int,@exSucursal bit,@exDepartamento bit,@idsucursal int,@iddepartamento int
		select @exSucursal=count(*) from sucursales where sucursal=@sucursal
		if @exSucursal=1
		begin
			select @exDepartamento=count(*) from departamentos where depto=@departamento
			if @exDepartamento=1
			begin
				select @codigo =isnull(max(idSucDept),0)+1 from sucursal_deptos
				select @idsucursal=idSucursal from sucursales where sucursal=@sucursal
				select @iddepartamento=idDepto from departamentos where depto=@departamento
				begin transaction
					insert into sucursal_deptos
						values(@codigo,@idsucursal,@iddepartamento,1)
				commit transaction
				set @resultado=1
			end
			else
				set @resultado=2
				return @resultado
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
create procedure sucdeptos_actualizar
(@idsucdept int,@sucursal nvarchar(50),@departamento nvarchar(25),@activo bit,@resultado int output)
as
	declare @exSucursal bit,@exDepartamento bit,@idSucursal int,@idDepto int
	select @exSucursal=count(*) from sucursales where sucursal=@sucursal
	select @exDepartamento=count(*) from departamentos where depto=@departamento
	if @exSucursal=1 and @exDepartamento=1
	begin
		select @idSucursal=idSucursal from sucursales where sucursal=@sucursal
		select @idDepto=idDepto from departamentos where depto=@departamento
		update sucursal_deptos
		set idSucursal=@idSucursal,idDepto=@idDepto,activo=@activo,@resultado=1
		where idSucDept=@idsucdept
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure sucdeptos_eliminar(@idsucdepto int)
as
	update sucursal_deptos
	set activo=0
	where idSucDept=@idsucdepto
go
--Ejecuciones
execute departamento_mostrar
execute sucursales_mostrar

declare @salida int
execute sucdeptos_agregar 'Bodega Sur','RRHH',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Algun Parametro no existe'
end
execute sucdeptos_mostrar
go;
/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Historial Academico
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure histacad_mostrar(@idhAcad int=0)
as 
	if @idhAcad=0
		select * from historial_academico
	else
		select * from historial_academico where idhAcad=@idhAcad
go
-- Agregar
create procedure histacad_agregar
(@cedula nvarchar(16),@grado nvarchar(25),@titulo nvarchar(50),@institucion nvarchar(100),
@fechaEmision smalldatetime,@resultado int output)
as
	begin try
		declare @codigo int,@excedula bit,@exGrado bit,@idCurriculum int,@idGrado int
		select @excedula=count(*) from curriculum where cedula=@cedula
		if @excedula=1
		begin
			select @exGrado=count(*) from gradoAcademico where gradoAcad=@grado
			if @exGrado=1
			begin
				select @codigo =isnull(max(idhAcad),0)+1 from historial_academico
				select @idCurriculum=idCV from curriculum where cedula=@cedula
				select @idGrado=idGrado from gradoAcademico where gradoAcad=@grado
				begin transaction
					insert into historial_academico
						values(@codigo,@idCurriculum,@idGrado,@titulo,@institucion,@fechaEmision,1)
				commit transaction
				set @resultado=1
			end
			else
				set @resultado=2
				return @resultado
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
create procedure histacad_actualizar
(@idhacad int,@cedula nvarchar(100),@grado nvarchar(25),@titulo nvarchar(50),@institucion nvarchar(100),
@fechaEmision smalldatetime,@activo bit,@resultado int output)
as
	declare @excedula bit,@exGrado bit,@idCurriculum int,@idGrado int
	select @excedula=count(*) from curriculum where cedula=@cedula
	select @exGrado=count(*) from gradoAcademico where gradoAcad=@grado
	if @excedula=1 and @exGrado=1
	begin
		select @idCurriculum=idCV from curriculum where cedula=@cedula
		select @idGrado=idGrado from gradoAcademico where gradoAcad=@grado
		update historial_academico
		set idhAcad=@idhacad,idCV=@idCurriculum,idGrado=@grado,activo=@activo,@resultado=1
		where idhAcad=@idhacad
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure histacad_eliminar(@idhAcad int)
as
	update historial_academico
	set activo=0
	where idhAcad=@idhAcad
go
--Ejecutar
execute curriculum_mostrar
execute gradoacademico_mostrar
declare @salida int
execute histacad_agregar '001-130490-0044f','Licenciado','LIcenciado en CIencias de la Computacion',
	'UNAN-Managua RURD','20160128',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Parametro no Registrado'
end
execute histacad_mostrar
go;

/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Historial Laboral
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure histlaboral_mostrar(@idhlaboral int=0)
as 
	if @idhlaboral=0
		select * from historial_laboral
	else
		select * from historial_laboral where idhLaboral=@idhlaboral
go
-- Agregar
create procedure histlaboral_agregar
(@cedula nvarchar(16),@empresa nvarchar(50),@cargo nvarchar(50),@salario money,@fingreso smalldatetime,
@fsalida smalldatetime,@superior nvarchar(100),@telefono nvarchar(25),@resultado int output)
as
	begin try
		declare @codigo int,@excedula bit,@idCurriculum int
		select @excedula=count(*) from curriculum where cedula=@cedula
		if @excedula=1
		begin
			select @codigo =isnull(max(idhLaboral),0)+1 from historial_laboral
			select @idCurriculum=idCV from curriculum where cedula=@cedula
			begin transaction
				insert into historial_laboral
					values(@codigo,@idCurriculum,@empresa,@cargo,@salario,@fingreso,@fsalida,@superior,@telefono,1)
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
create procedure histlaboral_actualizar
(@idhlaboral int,@cedula nvarchar(16),@empresa nvarchar(50),@cargo nvarchar(50),@salario money,@fingreso smalldatetime,
@fsalida smalldatetime,@superior nvarchar(100),@telefono nvarchar(25),@activo bit,@resultado int output)
as
	declare @excedula bit,@idCurriculum int
	select @excedula=count(*) from curriculum where cedula=@cedula
	if @excedula=1
	begin
		select @idCurriculum=idCV from curriculum where cedula=@cedula
		update historial_laboral
		set idhLaboral=@idhlaboral,idCV=@idCurriculum,empresa=@empresa,cargo=@cargo,salario=@salario,
			fIngreso=@fingreso,fSalida=@fsalida,superior=@superior,telefono=@telefono,activo=@activo,@resultado=1
		where idhLaboral=@idhlaboral
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure histlaboral_eliminar(@idhlaboral int)
as
	update historial_laboral
	set activo=0
	where idhLaboral=@idhlaboral
go
--Ejecuciones
declare @salida int
execute histlaboral_agregar '001-130490-0044f','Pricesmart','Electronic Sales','8900','20160516','20161231',
	'Don Marlon','84762534',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Parametro no Registrado'
end
execute histlaboral_mostrar
execute histlaboral_eliminar 1
go;

/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Historial Cargos
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure histcargos_mostrar(@idhcargos int=0)
as 
	if @idhcargos=0
		select * from historial_cargos
	else
		select * from historial_cargos where idhCargos=@idhcargos
go
-- Agregar
create procedure histcargos_agregar
(@cedula nvarchar(16),@idsucdept int,@cargo nvarchar(50),@salario money,@fingreso smalldatetime,
@fsalida smalldatetime,@observaciones nvarchar(100),@resultado int output)
as
	begin try
		declare @codigo int,@excedula bit,@idCurriculum int,@exCargo bit,@idCargo int 
		select @excedula=count(*) from curriculum where cedula=@cedula
		select @exCargo=count(*) from cargos where cargo=@cargo
		if @excedula=1 and @exCargo=1
		begin
			select @codigo =isnull(max(idhCargos),0)+1 from historial_cargos
			select @idCurriculum=idCV from curriculum where cedula=@cedula
			select @idCargo=idcargo from cargos where cargo=@cargo
			begin transaction
				insert into historial_cargos
					values(@codigo,@idCurriculum,@idsucdept,@idCargo,@salario,@fingreso,@fsalida,@observaciones,1)
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
create procedure histcargos_actualizar
(@idhcargos int,@cedula nvarchar(16),@idsucdept int,@cargo nvarchar(50),@salario money,@fingreso smalldatetime,
@fsalida smalldatetime,@observaciones nvarchar(100),@activo bit,@resultado int output)
as
	declare @excedula bit,@idCurriculum int,@exCargo bit,@idCargo int
	select @excedula=count(*) from curriculum where cedula=@cedula
	select @exCargo=count(*) from cargos where cargo=@cargo
	if @excedula=1 and @exCargo=1
	begin
		select @idCurriculum=idCV from curriculum where cedula=@cedula
		select @idCargo=idCargo from cargos where cargo=@cargo
		update historial_cargos
		set idCV=@idCurriculum,idSucDept=@idsucdept,idCargo=@idCargo,salario=@salario,
			fIngreso=@fingreso,fSalida=@fsalida,observaciones=@observaciones,activo=@activo,@resultado=1
		where idhCargos=@idhcargos
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure histcargos_eliminar(@idhcargos int)
as
	update historial_cargos
	set activo=0
	where idhCargos=@idhcargos
go
--Ejecuciones
execute cargos_mostrar
declare @salida int
execute histcargos_agregar '001-130490-0044f',1,'Inspector',8900,'20160516','20161231','Ninguna',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Parametro no Registrado'
end
execute histcargos_mostrar
go;

/*-----------------------------------------------------------------------------------------*/
--		Procedimientos de Referencias
/*-----------------------------------------------------------------------------------------*/
-- Mostar
create procedure referencias_mostrar(@idref int=0)
as 
	if @idref=0
		select * from referencias
	else
		select * from referencias where idRef=@idref
go
-- Agregar
create procedure referencias_agregar
(@cedula nvarchar(16),@nombres nvarchar(25),@apellidos nvarchar(50),@empresa nvarchar(50),
@cargo nvarchar(25),@telefono nvarchar(25),@celular nvarchar(25),@email nvarchar(50),@observaciones nvarchar(100),@resultado int output)
as
	begin try
		declare @codigo int,@excedula bit,@idCurriculum int
		select @excedula=count(*) from curriculum where cedula=@cedula
		if @excedula=1
		begin
			select @codigo =isnull(max(idRef),0)+1 from referencias
			select @idCurriculum=idCV from curriculum where cedula=@cedula
			begin transaction
				insert into referencias
					values(@codigo,@idCurriculum,@nombres,@apellidos,@empresa,@cargo,
						@telefono,@celular,@email,@observaciones,1)
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
create procedure referencias_actualizar
(@idref int,@cedula nvarchar(16),@nombres nvarchar(25),@apellidos nvarchar(50),@empresa nvarchar(50),@cargo nvarchar(25),
@telefono nvarchar(25),@celular nvarchar(25),@email nvarchar(50),@observaciones nvarchar(100),@activo bit,@resultado int output)
as
	declare @excedula bit,@idCurriculum int
	select @excedula=count(*) from curriculum where cedula=@cedula
	if @excedula=1
	begin
		select @idCurriculum=idCV from curriculum where cedula=@cedula
		update referencias
		set idCV=@idCurriculum,nombres=@nombres,apellidos=@apellidos,empresa=@empresa,cargo=@cargo,
			telefono=@telefono,celular=@celular,email=@email,observaciones=@observaciones,activo=@activo,@resultado=1
		where idRef=@idref
	end
	else
		set @resultado=2
		return @resultado
go
-- Elimnar
create procedure referencias_eliminar(@idref int)
as
	update referencias
	set activo=0
	where idRef=@idref
go
--Ejecuciones
execute curriculum_mostrar
declare @salida int
execute referencias_agregar '001-130490-0044f','Emman','Hussein','UNAN-Managua','Docente','84848484',
	'84848484','emmanhjousiff@gmail.com','Ninguna',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Parametro no Registrado'
end
declare @salida int
execute referencias_agregar '001-130490-0044f','Martha','Taleno','UNAN-Managua','Docente','84848484',
	'84848484','marthatoporta@gmail.com','Ninguna',@salida output
select case @salida
	when 0 then 'Contacte con el Administrador'
	when 1 then 'Registro almacenado correctamente'
	when 2 then 'Registro duplicado o Parametro no Registrado'
end
execute referencias_mostrar
go;