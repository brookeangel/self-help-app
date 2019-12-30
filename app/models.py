from app import db
import forgery_py as forgery

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
    
    @staticmethod
    def seed(records=10):
        for record in range(records):
            program = Program(
                name = forgery.lorem_ipsum.title(),
                description = forgery.lorem_ipsum.sentence(),
            )
            db.session.add(program)
        try:
            print("commiting program seed data")
            db.session.commit()
        except:
            db.session.rollback()


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

    @staticmethod
    def seed(records=4):
        programs = Program.query.all()

        # TODO: why not seeding properly
        for program in programs:
            for record in range(records):
                section = Section(
                    name = forgery.lorem_ipsum.title(),
                    program_id = program.id,
                    description = forgery.lorem_ipsum.sentence(),
                    overview_image = "http://placecorgi.com/250",
                    order_index = record,
                    html_content = "<ul><li>Point 1</li><li>Point 2</li><li>Point3</li></ul>"
                )
                db.session.add(section)
        try:
            db.session.commit()
        except:
            db.session.rollback()
