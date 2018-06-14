CREATE DataBase CandyUcabDB;

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
	ID SERIAL,
	rif varchar(12),
	Ci int, 
	Num_Carnet varchar(12),
	email varchar(20) NOT NULL UNIQUE,
	Nombre varchar(20) NOT NULL,
	Apellido varchar(20) NOT NULL,
	Apellido2 varchar(20), 
	FK_Usuario varchar(20),
	FK_Lugar int NOT NULL,
	Constraint Pk_ClienteNRif PRIMARY KEY (ID ,rif, Ci, Num_Carnet),
	FOREIGN KEY (FK_Usuario) REFERENCES Usuario (Nombre_Usuario),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

CREATE Table Cliente_Juridico(
	ID SERIAL UNIQUE,
	Rif varchar(12),
	Razon_s varchar(20) NOT NULL UNIQUE,
	Num_Carnet varchar(12),
	email varchar(20) NOT NULL UNIQUE,
	Denominacion_C varchar(120) NOT NULL,
	Pagina_web varchar(60),
	FK_Usuario varchar(20) NOT NULL,
	FK_Lugar int NOT NULL,
	Constraint Pk_ClienteJ PRIMARY KEY(ID, Rif, Num_Carnet),
	FOREIGN KEY (FK_Usuario) REFERENCES Usuario (Nombre_Usuario),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

CREATE Table Contacto(
	ID SERIAL,
	Ci int, 
	Nombre varchar(20) NOT NULL,
	Apellido varchar(20) NOT NULL,
	Fk_Juridico int,
	Constraint Pk_Contacto PRIMARY KEY (ID),
	FOREIGN KEY (Fk_Juridico) REFERENCES Cliente_Juridico(ID)
	);

CREATE Table Sucursal(
	Cod int,
	Nombre varchar(20) NOT NULL,
	FK_Lugar int NOT NULL,
	Constraint Pk_Sucursal PRIMARY KEY(Cod),
	FOREIGN KEY (Fk_Lugar) REFERENCES Lugar(ID)
	);

/*CREATE Table Telefono*/

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

CREATE Table Tipo_Producto(
	ID SERIAL,
	Nombre varchar(20) NOT NULL,
	Constraint Pk_TProd PRIMARY KEY (ID)
	);

CREATE Table Producto(
	ID SERIAL,
	Nombre varchar(20) NOT NULL,
	Precio real NOT NULL,
	Descripcion varchar(120) NOT NULL,
	Fk_Tprod int NOT NULL,
	Constraint Pk_Producto PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Tprod) REFERENCES Tipo_producto(ID)
	);

CREATE Table Fecha_Diario(
	ID SERIAL,
	Fecha_i timestamp NOT NULL,
	Fecha_f timestamp NOT NULL,
	Constraint Pk_Diario PRIMARY KEY(ID)
	);

CREATE Table Diario_Dulce(
	ID SERIAL,
	Fk_Producto int NOT NULL,
	Fk_Diario int NOT NULL,
	Constraint Pk_DiarioDulce PRIMARY KEY(ID),
	FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID),
	FOREIGN KEY (Fk_Diario) REFERENCES Fecha_Diario(ID)
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
