from app import db

class Program(db.Model):
    __tablename__ = 'programs'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), nullable=False, unique=True)
    description = db.Column(db.String(), nullable=False)
    sections = db.relationship('Section', backref='program')

    def __repr__(self):
        return '<Program {}>'.format(self.name)

    def serialize(self):
        return {
            'id'           : self.id,
            'name'         : self.name,
            'description'  : self.description,
            'sections'     : [i.serialize_minimal() for i in self.sections]
        }

class Section(db.Model):
    __tablename__ = 'sections'
    __table_args__ = (
        db.UniqueConstraint('program_id', 'order_index', name='program_order_index'),
    )

    id = db.Column(db.Integer, primary_key=True)
    program_id = db.Column(db.Integer, db.ForeignKey('programs.id'))
    name = db.Column(db.String(), nullable=False)
    description = db.Column(db.String(), nullable=False)
    overview_image = db.Column(db.String(), nullable=False)
    order_index = db.Column(db.Integer, nullable=False)
    html_content = db.Column(db.String(), nullable=False)

    def __repr__(self):
        return '<Program {}>'.format(self.name)

    def serialize_minimal(self):
        return {
            'id'           : self.id,
            'name'         : self.name,
            'overview_image'  : self.overview_image,
            'order_index'  : self.order_index,
        }

    def serialize(self):
        return {
            'id'           : self.id,
            'name'         : self.name,
            'description'  : self.description,
            'overview_image'  : self.overview_image,
            'order_index'  : self.order_index,
            'html_content' : self.html_content
        }
