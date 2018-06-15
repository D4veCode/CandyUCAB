from pg import DB


def connect2():
    db = DB(dbname='CandyUCABLakra', user='postgres', passwd='root', host='localhost', port=5432)

    return db


def get_all_productos():
    con = connect2()

    q = con.query("select * from producto")

    productos = q.dictresult()

    con.close()

    return productos
