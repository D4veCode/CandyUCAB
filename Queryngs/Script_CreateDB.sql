CREATE DataBase CandyUcabDB;

DROP schema public cascade;
CREATE schema public;

CREATE Table Usuario(
	ID SERIAL UNIQUE,
	Nombre_Usuario  varchar(20) UNIQUE,
	Contraseña varchar(20) NOT NULL,
	Constraint Pk_Usuario PRIMARY KEY (ID, Nombre_Usuario)
	);

CREATE Table Lugar(
	ID int,
	Tipo varchar(3) NOT NULL,
	Nombre varchar(40) NOT NULL,
	Fk_Lugar int,
	Constraint Pk_Lugar PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar (ID)
	);

CREATE Table Cliente_Natural(
	ID SERIAL UNIQUE,
	rif varchar(12),
	Ci int, 
	Num_Carnet varchar(12) UNIQUE,
	email varchar(40) NOT NULL UNIQUE,
	Nombre varchar(20) NOT NULL,
	Apellido varchar(20) NOT NULL,
	Apellido2 varchar(20), 
	FK_Usuario varchar(20),
	FK_Lugar int NOT NULL,
	Constraint Pk_ClienteNRif PRIMARY KEY (ID ,rif, Ci),
	FOREIGN KEY (FK_Usuario) REFERENCES Usuario (Nombre_Usuario),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

CREATE Table Cliente_Juridico(
	ID SERIAL UNIQUE,
	Rif varchar(12),
	Razon_s varchar(20) NOT NULL UNIQUE,
	Num_Carnet varchar(12) UNIQUE,
	email varchar(40) NOT NULL UNIQUE,
	Denominacion_C varchar(120) NOT NULL,
	Pagina_web varchar(60),
	FK_Usuario varchar(20) NOT NULL,
	FK_Lugar int NOT NULL,
	Constraint Pk_ClienteJ PRIMARY KEY(ID, Rif),
	FOREIGN KEY (FK_Usuario) REFERENCES Usuario (Nombre_Usuario),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

CREATE Table Contacto(
	ID SERIAL,
	Ci int, 
	Nombre varchar(20) NOT NULL,
	Apellido varchar(20) NOT NULL,
	Fk_Juridico int NOT NULL,
	Constraint Pk_Contacto PRIMARY KEY (ID),
	FOREIGN KEY (Fk_Juridico) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Sucursal(
	Cod int,
	Nombre varchar(60) NOT NULL,
	FK_Lugar int NOT NULL,
	Constraint Pk_Sucursal PRIMARY KEY(Cod),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

CREATE Table Empleado(
	ID SERIAL UNIQUE,
	Ci int,
	Nombre varchar(20) NOT NULL,
	Nombre2 varchar(20),
	Apellido varchar(20) NOT NULL,
	Apellido2 varchar(20) NOT NULL,
	Salario real NOT NULL,
	FK_Lugar int NOT NULL,
	Fk_Sucursal int NOT NULL,
	Fk_Usuario varchar(20) NOT NULL,
	Constraint Pk_Empleado PRIMARY KEY(ID, Ci),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID),
	FOREIGN KEY (Fk_Sucursal) REFERENCES Sucursal(Cod),
	FOREIGN KEY (FK_Usuario) REFERENCES Usuario(Nombre_Usuario)	
	);

CREATE table Telefono(
	ID SERIAL,
	tipo varchar(20) NOT NULL,
	numero varchar(15) NOT NULL,
	Fk_Contacto int,
	Fk_Natural int,
	Fk_Juridico int,
	Fk_Empleado int,
	Constraint Pk_Telefono PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Contacto) REFERENCES Contacto(ID),
	FOREIGN KEY (Fk_Natural ) REFERENCES Cliente_natural(ID),
	FOREIGN KEY (Fk_Juridico) REFERENCES Cliente_juridico(ID),
	FOREIGN KEY (Fk_Empleado) REFERENCES Empleado(ID)
	);

CREATE Table Sabor(
	ID SERIAL,
	Nombre varchar(20) NOT NULL UNIQUE,
	Constraint Pk_Sabor PRIMARY KEY (Nombre)
	);

CREATE Table Tipo_Producto(
	ID SERIAL,
	Nombre varchar(20) NOT NULL UNIQUE,
	Constraint Pk_TProd PRIMARY KEY (nombre)
	);

CREATE Table Fecha_Diario(
	ID SERIAL,
	Fecha_i timestamp NOT NULL,
	Fecha_f timestamp NOT NULL,
	Constraint Pk_Diario PRIMARY KEY(ID)
	);

CREATE Table Producto(
	ID SERIAL,
	Nombre varchar(20) NOT NULL,
	Precio real NOT NULL,
	Descripcion varchar(120) NOT NULL,
	Foto varchar(120),
	Fk_Tprod varchar(20) NOT NULL,
	Constraint Pk_Producto PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Tprod) REFERENCES Tipo_producto(nombre)
	);

CREATE Table Diario_Dulce(
	ID SERIAL,
	Fk_Producto int NOT NULL,
	Fk_Diario int NOT NULL,
	Constraint Pk_DiarioDulce PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID),
	FOREIGN KEY (Fk_Diario) REFERENCES Fecha_Diario(ID)
	);

CREATE Table Sabor_Producto(
	ID SERIAL,
	Fk_Producto int NOT NULL,
	Fk_Sabor varchar(20) NOT NULL,
	Constraint Pk_SaborProducto PRIMARY KEY (ID),
	FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID),
	FOREIGN KEY (Fk_Sabor) REFERENCES Sabor(nombre)
	);

CREATE Table Inventario(
	ID SERIAL,
	Cant_Stock int NOT NULL,
	Cant_Max int NOT NULL,
	Fk_Sucursal int NOT NULL,
	Fk_Producto int NOT NULL,
	Constraint Pk_Inventario PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID),
	FOREIGN KEY (Fk_Sucursal) REFERENCES Sucursal(Cod)
	);
	
CREATE Table Almacen(
	ID SERIAL,
	Cant_Prod int NOT NULL,
	
	pasillo varchar(30) NOT NULL,
	zona varchar(30) NOT NULL,
	Fk_Inventario int NOT NULL UNIQUE,
	Constraint Pk_Alamecen PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Inventario) REFERENCES inventario(ID)
	);

CREATE Table Credito(
	ID SERIAL,
	Numero varchar(30) NOT NULL,
	Nombre_T varchar(50) NOT NULL,
	Cod_S varchar(10) NOT NULL,
	Fecha_V date NOT NULL,
	Banco varchar(50) NOT NULL,
	Fk_ClienteN int,
	Fk_ClienteJ int,
	Constraint Pk_Credito PRIMARY KEY(ID),
	FOREIGN KEY (Fk_ClienteN) REFERENCES Cliente_Natural(ID),
	FOREIGN KEY (Fk_ClienteJ) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Debito(
	ID SERIAL,
	Numero varchar(30) NOT NULL,
	Nombre_T varchar(50) NOT NULL,
	Cod_S varchar(10) NOT NULL,
	Banco varchar(50) NOT NULL,
	Fk_ClienteN int,
	Fk_ClienteJ int,
	Constraint Pk_Debito PRIMARY KEY(ID),
	FOREIGN KEY (Fk_ClienteN) REFERENCES Cliente_Natural(ID),
	FOREIGN KEY (Fk_ClienteJ) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Cheque(
	ID SERIAL,
	Numero_C varchar(50) NOT NULL,
	Fecha_D timestamp NOT NULL,
	Banco varchar(50) NOT NULL,
	Fk_ClienteN int,
	Fk_ClienteJ int,
	Constraint Pk_Cheque PRIMARY KEY(ID),
	FOREIGN KEY (Fk_ClienteN) REFERENCES Cliente_Natural(ID),
	FOREIGN KEY (Fk_ClienteJ) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Punto(
	ID SERIAL,
	Cant int NOT NULL,
	Valor real NOT NULL,
	Fecha timestamp NOT NULL,
	Fk_ClienteN int,
	Fk_ClienteJ int,
	Constraint Pk_Punto PRIMARY KEY(ID),
	FOREIGN KEY (Fk_ClienteN) REFERENCES Cliente_Natural(ID),
	FOREIGN KEY (Fk_ClienteJ) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Presupuesto(
	ID SERIAL,
	Monto int NOT NULL,
	Fecha_D date NOT NULL,
	Fk_Usuario varchar(20),
	Fk_ClienteN int,
	Fk_ClienteJ int,
	Constraint Pk_Presupuesto PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Usuario)  REFERENCES Usuario(Nombre_usuario),
	FOREIGN KEY (Fk_ClienteN) REFERENCES Cliente_Natural(ID),
	FOREIGN KEY (Fk_ClienteJ) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Pedido(
	ID SERIAL,
	Monto real NOT NULL,
	Fecha_C timestamp NOT NULL,
	Fk_Sucursal int,
	Fk_Presupuesto int UNIQUE,
	Constraint Pk_Pedido PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Sucursal) REFERENCES Sucursal(Cod),
	FOREIGN KEY (Fk_Presupuesto) REFERENCES Presupuesto(ID)
	);

CREATE Table Status(
	ID SERIAL,
	Tipo varchar(20) NOT NULL,
	Constraint Pk_Status PRIMARY KEY(ID)
	);
	
CREATE Table EstadoPedido(
	ID SERIAL,
	Fecha_I timestamp NOT NULL,
	Fk_Pedido int NOT NULL,
	Fk_Status int NOT NULL,
	Constraint Pk_EstadoPedido PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Pedido) REFERENCES Pedido(ID),
	FOREIGN KEY (Fk_Status) REFERENCES Status(ID)
	);

CREATE Table Beneficio(
	ID SERIAL,
	Tipo varchar(30),
	Descripcion varchar(120) NOT NULL,
	Fk_Empleado int NOT NULL,
	Constraint Pk_Beneficio PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Empleado) REFERENCES Empleado(ID)
	);

CREATE Table Vacacion(
	ID SERIAL,
	Tipo varchar(30),
	Descripcion varchar(120) NOT NULL,
	Fecha_I date NOT NULL,
	Fecha_F date NOT NULL,
	Fk_Empleado int NOT NULL,
	Constraint Pk_Vacacion PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Empleado) REFERENCES Empleado(ID)
	);

CREATE Table ROL(
	ID SERIAL,
	Nombre varchar(30),
	Fk_Usuario int NOT NULL,
	Constraint Pk_ROL PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Usuario) REFERENCES Usuario(ID)
	);

CREATE Table Privilegio(
	ID SERIAL,
	Nombre varchar(40),
	Constraint Pk_Privilegio PRIMARY KEY(ID)
	);

CREATE Table Priv_Rol(
	ID SERIAL,
	Fk_privilegio int NOT NULL,
	Fk_Rol int NOT NULL,
	Constraint Pk_Priv_Rol PRIMARY KEY(ID),
	FOREIGN KEY (Fk_privilegio) REFERENCES Privilegio(ID),
	FOREIGN KEY (Fk_Rol) REFERENCES Rol(ID)
	);

CREATE Table Asistencia(
	ID SERIAL,
	Hora_E timestamp NOT NULL,
	Hora_S timestamp,
	Fk_Empleado int NOT NULL,
	Constraint Pk_Asistencia PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Empleado) REFERENCES Empleado(ID)
	);

CREATE Table Pre_Pro(
	ID SERIAL,
	Cant int NOT NULL,
	Total real NOT NULL,
	Fk_Producto int NOT NULL,
	Fk_Presupuesto int NOT NULL,
	Constraint Pk_Pre_Pro PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID),
	FOREIGN KEY (Fk_Presupuesto) REFERENCES Presupuesto(ID)											 
	);
	
CREATE Table Met_Ped(
	ID SERIAL,
	Monto real NOT NULL,
	Fk_Pedido int,
	Fk_Cheque  int,
	Fk_Credito int,
	Fk_Debito int,
	Constraint Pk_Met_Ped PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Pedido) REFERENCES Pedido(ID),
	FOREIGN KEY (Fk_Cheque) REFERENCES Cheque(ID),
	FOREIGN KEY (Fk_Credito) REFERENCES Credito(ID),
	FOREIGN KEY (Fk_Debito) REFERENCES Debito(ID)
	);
