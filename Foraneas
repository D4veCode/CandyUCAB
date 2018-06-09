(lugar)FOREIGN KEY Fk_Lugar REFERENCES Lugar(ID)

(Cliente_Natural)FOREIGN KEY FK_Usuario REFERENCES Usuario(Nombre_Usuario)
	  	 FOREIGN KEY Fk_Lugar REFERENCES Lugar(ID)

(Cliente_Juridico)FOREIGN KEY FK_Usuario REFERENCES Usuario(Nombre_Usuario)
	 	  FOREIGN KEY Fk_Lugar REFERENCES Lugar(ID)

(Contacto)FOREIGN KEY Fk_Juridico REFERENCES Cliente_Juridico(rif)

(Sucursal)FOREIGN KEY Fk_Lugar REFERENCES Lugar(ID)

(Empleado)FOREIGN KEY Fk_Lugar REFERENCES Lugar(ID)
	  FOREIGN KEY Fk_Sucursal REFERENCES Sucursal(Cod)
	  FOREIGN KEY FK_Usuario REFERENCES Usuario(Nombre_Usuario)

(Diario_Dulce)FOREIGN KEY Fk_Producto REFERENCES Producto(ID)
	      FOREIGN KEY Fk_Diario REFERENCES Diario(ID)

(Inventario)FOREIGN KEY Fk_Producto REFERENCES Producto(ID)
	    FOREIGN KEY Fk_Sucursal REFERENCES Sucursal(ID)
