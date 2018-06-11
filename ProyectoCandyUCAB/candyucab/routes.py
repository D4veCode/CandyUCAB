import candyucab.db
from flask import jsonify
from candyucab import app


@app.route('/')
def home():
    db = candyucab.db
    users = db.get_all_users()

    return jsonify(users[0][0])
