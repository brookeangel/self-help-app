from app import app
from flask import render_template, jsonify
from app.models import Program, Section
from sqlalchemy.orm import joinedload, Load

@app.route('/')
@app.route('/programs') # Handled by SPA
@app.route('/sections/<id>') # Handled by SPA
def index(id=None):
    return render_template('index.html')

@app.route('/api/programs')
def programs():
    programs = Program.query.options(joinedload(Program.sections, innerjoin=True)).all()

    return jsonify([i.serialize() for i in programs])

@app.route('/api/sections/<id>')
def sections(id):
    section = Section.query.get(id)

    return jsonify(section.serialize())
