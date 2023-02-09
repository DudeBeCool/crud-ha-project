import os
import sys
import psycopg2
from unicodedata import name
from jinja2.utils import markupsafe
from markupsafe import escape
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# SQLAlchemy handling database
if os.environ.get('DATABASE_URL') is None:
    print("DATABASE_URL is not set")
    sys.exit()
else:
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
    db = SQLAlchemy(app)

# define model/schema of data
class Item(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product = db.Column(db.String(80), unique=True, nullable=False)
    stock = db.Column(db.Integer, unique=False, nullable=False)

    def __init__(self, product, stock):
        self.product = product
        self.stock = stock

    # serialize for easy redable format
    @property
    def serialized(self):
        return {
            'id': self.id,
            'product': self.product,
            'stock': self.stock,
        }

# synchronize database with Postgres
db.create_all()


# endpoint for single item
@app.route("/product/<id>", methods=["GET"])
def get_item(id):
    try:
        item = Item.query.get(id)
        if item is None:
            raise Exception()
    except Exception as e:
        return {"status_code": 404, "msg": "This product does not exist"}, 404
    else:
        return jsonify(item.serialized)

# endpoint for get all products
@app.route("/product", methods=["GET"])
def get_items():
    items = []
    for item in db.session.query(Item).all():
        items.append(item.serialized)
    return jsonify(items)

# endpoint to create products
@app.route("/product", methods=["POST"])
def create_item():
    try:
        body = request.get_json()
        product = Item(body["product"], body["stock"])
        db.session.add(product)
        db.session.commit()
    except:
        db.session.rollback()
        return {"status_code": 409, "msg": "This product name is already taken, can't be added again"}, 409
    else:
        return {"status_code": 200, "msg": "Sucessfully added a new product", "id": str(product.id)}, 200

# endpoint to update existing product
@app.route("/product/<id>", methods=["PUT"])
def update_item(id):
    try:
        item = Item.query.get(id)
        if item is None:
            raise Exception()
    except Exception as e:
        return {"status_code": 404, "msg": "This product does not exist"}, 404  
    else:
        body = request.get_json()
        db.session.query(Item).filter_by(id=id).update(
            dict(name=body["product"], stock=body["stock"])
        )
        db.session.commit()
        return {"status_code": 200, "msg": "Product informations is sucessfully updated"}, 200

# endpoint to delete existing product
@app.route("/product/<id>", methods=["DELETE"])
def delete_item(id):
    try:
        item = Item.query.get(id)
        if item is None:
            raise Exception()
    except Exception as e:
        return {"status_code": 404, "msg": "This product does not exist"}, 404      
    else:
        db.session.query(Item).filter_by(id=id).delete()
        db.session.commit()
        return {"status_code": 200, "msg": "Product deleted"}, 200

# health check purpose
@app.route("/healthz")
def health_check():
    return "App is working"

