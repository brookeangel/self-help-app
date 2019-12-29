from app import app
from flask import render_template, jsonify
from app.models import Program, Section
from sqlalchemy.orm import joinedload, Load

@app.route('/')
def index():
    return render_template('index.html', title="Self Help Programs")

@app.route('/programs')
def programs():
    programs = Program.query.options(joinedload(Program.sections, innerjoin=True)).all()

    return jsonify([i.serialize() for i in programs])
