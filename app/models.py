from app import db

class Program(db.Model):
    __tablename__ = 'programs'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), nullable=False, unique=True)
    description = db.Column(db.String(), nullable=False)

    def __repr__(self):
        return '<Program {}>'.format(self.name)
