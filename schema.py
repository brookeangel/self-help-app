import graphene
from graphene import relay
from graphene_sqlalchemy import SQLAlchemyObjectType, SQLAlchemyConnectionField
from app.models import Program as ProgramModel, Section as SectionModel

class Program(SQLAlchemyObjectType):
    class Meta:
        model = ProgramModel
        interfaces = (relay.Node, )

class Section(SQLAlchemyObjectType):
    class Meta:
        model = SectionModel
        interfaces = (relay.Node, )

class Query(graphene.ObjectType):
    node = relay.Node.Field()
    all_programs = SQLAlchemyConnectionField(Program)

schema = graphene.Schema(query=Query, types=[Program, Section])
