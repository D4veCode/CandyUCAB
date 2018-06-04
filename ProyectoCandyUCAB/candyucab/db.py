import psycopg2


def connect():
    con = psycopg2.connect("dbname=candyucab")
    return con


