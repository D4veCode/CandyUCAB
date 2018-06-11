import psycopg2
import psycopg2.extras


def connect():
    con = psycopg2.connect("dbname=blog4geeks user=postgres password=root host=localhost")
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    return cur


def close(cur):

    cur.close()


"""def cursor(con):
    cur = con.cursor()
    return cur
"""


def get_all_users():
    cur = connect()

    cur.execute("select * from users")

    products = cur.fetchall()

    close(cur)

    return products
