import candyucab.db
import os
import bcrypt
from datetime import datetime
from flask import request, render_template, url_for, redirect, session, jsonify, Blueprint
from candyucab import app
from werkzeug.utils import secure_filename

app.secret_key = b'\xf3\xff\xe3\xa3\x92\xc4\xebH[\x0e\x95\xd4\x8df\xf1\x7f'
admin = Blueprint('admin', __name__, template_folder='templates')


@app.route('/', methods=['GET', 'POST'])
def home():
    db = candyucab.db

    parroquias = db.get_parroquias()
    productos = db.get_all_productos()

    return render_template('index.html', parroquias=parroquias, productos=productos)


@app.route('/nosotros')
def nosotros():

    return render_template('about.html')


@app.route('/productos', methods=['GET', 'POST'])
def productos():
    db = candyucab.db
    productos = db.get_all_productos()

    return render_template('product.html', productos = productos)


@app.route('/carrito', methods=['GET','POST'])
def carrito():
    db =candyucab.db
    if session['cart']:
        id = session['cart']
        carrito = db.carrito(id)
        return render_template('cart.html', carrito=carrito)
    return render_template('cart.html')


@app.route('/addcarrito/<int:id>', methods=['POST'])
def addcarrito(id):
    db = candyucab.db
    user = session['username']
    precio = float(request.form['precio'])
    cant = request.form['num-product']

    if session['cart'] == 0:
        fecha = datetime.utcnow().strftime("%d-%m-%Y")
        id_p = db.crear_presupuesto(0, fecha, user, id, cant, precio)
        session['cart'] = id_p
        return redirect(url_for('productos'))
    else:
        cantf = float(cant)
        total = precio * cantf
        carro = session['cart']
        db.add_carrito(cant, total, carro, producto)
        return redirect(url_for('productos'))


@app.route('/productos/<int:id>', methods=['GET', 'POST'])
def producto(id):
    db = candyucab.db
    producto = db.get_one_product(id)
    return render_template('product-detail.html', producto=producto)


@app.route('/contacto')
def contact():
    return render_template('contact.html')


@app.route('/registroNatural', methods=['POST'])
def registro_nat():
    db = candyucab.db

    username = request.form['username']
    password = bcrypt.hashpw(request.form['password'].encode('utf-8'), bcrypt.gensalt())

    email = request.form['email']
    nombre = request.form['nombre']
    apellido = request.form['Apellido']
    apellido2 = request.form['Apellido2']
    rif = request.form['rif']
    ci = int(request.form['ci'])
    FK_Lugar = request.form.get('prq')

    db.registro_user(username, password)

    db.registro_nat(username, email, nombre, apellido, apellido2, FK_Lugar, ci, rif)

    session['logged_in'] = True
    session['username'] = username
    session['cart'] = 0

    return redirect(url_for('home'))


@app.route('/registroJuridico', methods=['POST'])
def registro_jur():
    db = candyucab.db
    username = request.form['username']
    password = request.form['password']

    db.registro_nat(username, password)

    email = request.form['email']
    razon_s = request.form['razon_s']
    denom_com = request.form['denom_com']
    pagina_web = request.form['pagina_web']
    rif = request.form['rif']
    FK_Lugar = request.form.get('prq')

    db.registro_jur(username, email, razon_s, denom_com, pagina_web, rif, FK_Lugar)

    return redirect(url_for('home'))


@app.route('/login', methods=['POST'])
def login():
    db = candyucab.db
    username = request.form['username']
    password = request.form['password']

    user = db.login(username)
    print(user)
    if len(user) > 0:
        if bcrypt.checkpw(password.encode('utf-8'), user[0]['contraseña'].encode('utf-8')):
            session['logged_in'] = True
            session['username'] = username
            session['cart'] = 0
            print(session)
            return redirect(url_for('home'))
        else:
            error = "Credenciales invalidas"
    else:
        error = "Usuario invalido"

    return render_template('index.html', error=error)


@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('logged_in', False)
    return redirect(url_for('home'))


@app.route('/municipio/<int:estado>')
def municipio(estado):
    db = candyucab.db

    municipios = db.get_all_municipios(estado)

    return jsonify({'municipios': municipios})


@app.route('/parroquia/<int:muni>')
def parroquia(muni):
    db = candyucab.db

    parroquia = db.get_parroquia(muni)

    return jsonify({'parroquia': parroquia})


###################### ADMIN ##################################3

@admin.route('/')
def home():
    return render_template('admin.html')


@admin.route('/addproducto', methods=['GET', 'POST'])
def addproduct():
    db = candyucab.db

    tipo_prod = db.get_tipoprod()

    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['description']
        precio = float(request.form['precio'])
        fk_tprod = request.form.get('t_prod')
        file = request.files['fileimage']
        image = secure_filename(file.filename)
        print(image)
        file.save(os.path.join(app.root_path, 'static/images', image))
        db.add_products(nombre, precio, descripcion, fk_tprod, image)
        return redirect(url_for('admin.home'))
    return render_template('addproducto.html', tipo_prod=tipo_prod)

@admin.route('/addsucursal', methods=['GET', 'POST'])
def addtienda():
    db = candyucab.db

    parroquias = db.get_parroquias()

    if request.method == 'POST':
        nombre = request.form['nombre']
        fk_lugar = request.form.get('parroquia')
        db.addsucursal(41,nombre, fk_lugar)
        return redirect(url_for('admin.home'))
    return render_template('addtienda.html', parroquias=parroquias)


@admin.route('/registroNatural', methods=['GET', 'POST'])
def registro_nat():
    db = candyucab.db
    estados = db.get_estados()

    if request.method == 'POST':
        email = request.form['email']
        nombre = request.form['nombre']
        apellido = request.form['Apellido']
        apellido2 = request.form['Apellido2']
        rif = request.form['rif']
        ci = int(request.form['ci'])
        FK_Lugar = 1122

        db.registro_nat_presencial(email, nombre, apellido, apellido2, FK_Lugar, ci, rif)

        return redirect(url_for('admin.home'))

    return render_template('addclientenat.html', estados=estados)


@admin.route('/registroJuridico', methods=['GET','POST'])
def registro_jur():
    db = candyucab.db
    estados = db.get_estados()

    if request.method == 'POST':
        email = request.form['email']
        razon_s = request.form['razon_s']
        denom_com = request.form['denom_com']
        pagina_web = request.form['pagina_web']
        rif = request.form['rif']
        FK_Lugar = 1122

        db.registro_jur_presencial(email, razon_s, denom_com, pagina_web, rif, FK_Lugar)

        return redirect(url_for('admin.home'))

    return render_template('addclientejur.html', estados=estados)


@admin.route('/productos')
def productos():
    db = candyucab.db
    productos = db.get_all_productos()

    return render_template('adminproductos.html', productos = productos)
