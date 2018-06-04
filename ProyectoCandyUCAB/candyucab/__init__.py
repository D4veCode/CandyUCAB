from flask import Flask

app = Flask(__name__)

from candyucab import db, routes
