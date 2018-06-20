from pg import DB
import pg

def connect():
    db = DB(dbname='candyucabdb', user='postgres', passwd='root', host='localhost', port=5432)

    return db


def close(con):

    con.close()


def get_all_productos():
    con = connect()

    productos = con.query("select * from producto order by id ").dictresult()

    con.close()

    return productos


def get_one_product(id):
    con = connect()

    producto = con.query("select * from producto where id = $1", (id, )).dictresult()

    con.close()

    return producto


def registro_user(username, password):
    con = connect()

    con.query("insert into Usuario (Nombre_Usuario,Contraseña) values ($1,$2)", (username, password,))

    con.close()

def addsucursal(cod,nombre, fk_lugar):
    con = connect()

    con.query("insert into sucursal (cod, nombre, fk_lugar) values ($1,$2, $3)", (cod, nombre, fk_lugar))

    con.close()

def registro_nat(user, email, nombre, apell, apell2, FK_L, ci, rif):
    con = connect()

    con.query("insert into Cliente_Natural (Nombre, Apellido, Apellido2, rif, ci, email, FK_Lugar, FK_Usuario) values ($1,$2,$3,$4,$5,$6,$7,$8)", (nombre, apell, apell2, rif, ci, email, FK_L, user,))
    con.close()

def registro_jur(user,email, razon_s, denom_com, pagina_web, rif, FK_L):
    con = connect()
    con.query(
        "insert into Cliente_juridico (email, razon_s, denominacion_c, pagina_web, rif, FK_Lugar, FK_Usuario) values ($1,$2,$3,$4,$5,$6)",
        (email, razon_s, denom_com, pagina_web, rif, FK_L, user)
    )

    con.close()

def login(username):
    con = connect()

    user = con.query("select * from usuario where nombre_usuario = $1", (username,)).dictresult()

    con.close()
    return user

def get_all_municipios(estado):
    con = connect()

    municipios = con.query("select * from lugar where fk_lugar = $1", (estado,)).dictresult()

    con.close()

    return municipios


def get_parroquias():
    con = connect()

    parroq = con.query("select * from lugar where tipo = 'Prq'").dictresult()

    con.close()

    return parroq

def get_estados():
    con = connect()

    estados = con.query("select * from lugar where fk_lugar is NULL").dictresult()

    con.close()

    return estados


def add_products(nombre, precio, descripcion, fk_tprod, foto):
    con = connect()

    con.query("insert into producto (nombre, precio, descripcion, fk_tprod, foto) values ($1, $2, $3, $4, $5)", (nombre, precio, descripcion, fk_tprod, foto,))

    con.close()


def get_tipoprod():
    con = connect()

    tipo_prod = con.query("select * from tipo_producto ").dictresult()

    con.close()
    return tipo_prod


def registro_nat_presencial(email, nombre, apell, apell2, FK_L, ci, rif):
    con = connect()
    con.query(
        "insert into Cliente_Natural (Nombre, Apellido, Apellido2, rif, ci, email, FK_Lugar, FK_Usuario) values ($1,$2,$3,$4,$5,$6,$7,$8)",
        (nombre, apell, apell2, rif, ci, email, FK_L, None)
    )
    con.close()


def registro_jur_presencial(email, razon_s, denom_com, pagina_web, rif, FK_L):
    con = connect()
    con.query(
        "insert into Cliente_juridico (email, razon_s, denominacion_c, pagina_web, rif, FK_Lugar, FK_Usuario) values ($1,$2,$3,$4,$5,$6)",
        (email, razon_s, denom_com, pagina_web, rif, FK_L, None)
    )
    con.close()

def Update_presupuesto(carro):
    con = connect()
    con.query("UPDATE presupuesto SET monto = (select sum(total) from pre_pro where Fk_presupuesto = $1) WHERE id = $2;", (carro, carro,))
    con.close()


def add_carrito(cant, total, carro, producto):
    con = connect()
    print(cant, total, carro, producto)
    con.query("insert into Pre_Pro (Cant,Total,Fk_Presupuesto, Fk_Producto) values($1,$2,$3,$4);", (cant, total, carro, producto,))
    con.close()
    Update_presupuesto(carro)


def crear_presupuesto(monto,fecha,User,producto,cant,precio):
    con = connect()
    dirpresupuesto = con.query_formatted("insert into presupuesto (monto,fecha_D, Fk_Usuario) values(0, %s, %s)Returning ID;", (fecha, User,)).dictresult()
    con.close()
    cantf = float(cant)
    total = precio*cantf
    presupuesto = int(dirpresupuesto[0]['id'])
    add_carrito(cant, total, presupuesto, producto)

    return presupuesto

def venta_inventario(tienda, carro):
    con = connect()
    dirProductos = con.query("select distinct fk_producto from pre_pro where fk_presupuesto = $1", (carro,)).dictresult()
    print(dirProductos)
    for i in range(0,len(dirProductos)):
        con.query("UPDATE Inventario SET cant_stock = cant_stock - (select sum(cant) from pre_pro where Fk_producto = $1 and fk_presupuesto = $2) where Fk_producto = $3 and fk_sucursal = $4", (int(dirProductos[i]['fk_producto']), carro, int(dirProductos[i]['fk_producto']), tienda,))

    con.close()

def generar_pedido(carro, tienda, fecha):
    con = connect()
    con.query("insert into pedido (Monto, Fecha_C, Fk_Sucursal, Fk_Presupuesto)values((select sum(total) from pre_pro where Fk_presupuesto = $1),$2,$3,$4)", (carro, fecha, tienda, carro,))
    con.query("insert into EstadoPedido(Fecha_I, Fk_Pedido, Fk_Status)values($1,(select ID from pedido where fk_presupuesto = $2), 1)", (fecha, carro,))
    venta_inventario(tienda, carro, )

    con.close()


def pagar(carro, credit, debit, tienda, fecha):
    generar_pedido(carro, tienda, fecha)
    con = connect()
    if debit == 0:
        con.query("insert into Met_Ped(Monto,fk_pedido, Fk_Credito)values((select sum(total) from pre_pro where Fk_presupuesto = $1), (select ID from pedido where fk_presupuesto = $2), $3)", (carro, carro, credit,))
    else:
        con.query("insert into Met_Ped(Monto,fk_pedido, Fk_Debito)values((select sum(total) from pre_pro where Fk_presupuesto = $1), (select ID from pedido where fk_presupuesto = $2), $3)", (carro, carro, debit,))

    con.close()


def alterstatus(pedido,fecha):
    con = connect()
    con.query("insert into EstadoPedido(Fecha_I, Fk_Pedido, Fk_Status)values($1,$2,1+(select MAX(Fk_Status) from Estadopedido where Fk_pedido = $3));",(fecha, pedido, pedido,))

    con.close()


def carrito(id):
    con =connect()

    carrito= con.query("select (select foto from producto where a.Fk_producto = Id),(select nombre from producto where a.Fk_producto = Id),(select precio from producto where a.Fk_producto = Id), a.cant, a.total from Pre_Pro as a where a.Fk_presupuesto = $1", (id,)).dictresult()

    con.close()

    return carrito