from app import app, db
from app.models import Program, Section
from flask.cli import with_appcontext
import click

@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'Program': Program, 'Section': Section}

@click.command()
@with_appcontext
def seed():
    Program.seed()
    Section.seed()

app.cli.add_command(seed)
