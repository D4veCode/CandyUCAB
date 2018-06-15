import candyucab.db
import bcrypt
from flask import jsonify, request, render_template, url_for
from candyucab import app


"url_for('static')"

@app.route('/')
def home():
    return render_template('index.html')


@app.route('/productos')
def productos():
    db = candyucab.db
    productos = db.get_all_productos()

    return render_template('product.html', productos = productos)

@app.route('/contacto')
def contact():
    return render_template('contact.html')

""""@app.route('/registro', methods=['GET', 'POST'])
def registro():
    if request.method == 'POST':
        username = request.form['username']
        password = bcrypt.hashpw(request.form['password'], bcrypt.gensalt())
        if
   else render_template()
"""