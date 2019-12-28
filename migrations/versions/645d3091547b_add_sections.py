"""add sections

Revision ID: 645d3091547b
Revises: e80734511bf8
Create Date: 2019-12-27 20:30:13.783478

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '645d3091547b'
down_revision = 'e80734511bf8'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('sections',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('program_id', sa.Integer(), nullable=True),
    sa.Column('name', sa.String(), nullable=False),
    sa.Column('description', sa.String(), nullable=False),
    sa.Column('overview_image', sa.String(), nullable=False),
    sa.Column('order_index', sa.Integer(), nullable=False),
    sa.Column('html_content', sa.String(), nullable=False),
    sa.ForeignKeyConstraint(['program_id'], ['programs.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('sections')
    # ### end Alembic commands ###
