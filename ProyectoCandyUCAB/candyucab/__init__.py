from flask import Flask

app = Flask(__name__)

from candyucab import db, routes

app.register_blueprint(routes.admin, url_prefix='/admin')
