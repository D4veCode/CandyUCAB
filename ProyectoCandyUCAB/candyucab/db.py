from pg import DB


def connect():
    db = DB(dbname='candyucabdb', user='postgres', passwd='root', host='localhost', port=5432)

    return db


def close(con):

    con.close()


def get_all_productos():
    con = connect()

    q = con.query("select * from producto")

    productos = q.dictresult()

    con.close()

    return productos


def get_one_product(id):
    con = connect()

    producto = con.query("select * from producto where id = $1", (id, )).dictresult()

    con.close()

    return producto


def registro_nat(username, password, ):
    con = connect()

    con.query("insert into Usuario (Nombre_Usuario,Contraseña) values (%s,%s)", (username,password,))

    con.close()

