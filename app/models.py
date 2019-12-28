from app import db

class Program(db.Model):
    __tablename__ = 'programs'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), nullable=False, unique=True)
    description = db.Column(db.String(), nullable=False)
    sections = db.relationship('Section', backref='program', lazy='dynamic')

    def __repr__(self):
        return '<Program {}>'.format(self.name)

class Section(db.Model):
    __tablename__ = 'sections'

    id = db.Column(db.Integer, primary_key=True)
    program_id = db.Column(db.Integer, db.ForeignKey('programs.id'))
    name = db.Column(db.String(), nullable=False)
    description = db.Column(db.String(), nullable=False)
    overview_image = db.Column(db.String(), nullable=False)
    order_index = db.Column(db.Integer, nullable=False)
    html_content = db.Column(db.String(), nullable=False)

    def __repr__(self):
        return '<Program {}>'.format(self.name)
