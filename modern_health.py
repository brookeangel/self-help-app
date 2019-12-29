from app import app, db
from app.models import Program, Section

@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'Program': Program, 'Section': Section}
