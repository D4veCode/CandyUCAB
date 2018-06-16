import candyucab.db
import bcrypt
from flask import request, render_template, url_for, redirect, session
from candyucab import app

app.secret_key = b'\xf3\xff\xe3\xa3\x92\xc4\xebH[\x0e\x95\xd4\x8df\xf1\x7f'


@app.route('/')
def home():
    session['logged_in'] = False

    return render_template('index.html')


@app.route('/productos')
def productos():
    db = candyucab.db
    productos = db.get_all_productos()

    return render_template('product.html', productos = productos)


@app.route('/productos/<int:id>')
def producto(id):
    db = candyucab.db
    producto = db.get_one_product(id)
    print(producto)
    return render_template('product-detail.html', producto=producto)

@app.route('/contacto')
def contact():
    return render_template('contact.html')


@app.route('/registroNatural', methods=['POST'])
def registro_nat():
    db = candyucab.db
    username = request.form['username']
    password = request.form['password']

    db.registro_nat(username, password)

    return redirect(url_for('home'))


@app.route('/registroJuridico', methods=['POST'])
def registro_jur():
    db = candyucab.db
    username = request.form['username']
    password = request.form['password']

    db.registro_nat(username, password)

    return redirect(url_for('home'))
