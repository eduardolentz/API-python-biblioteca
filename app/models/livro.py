from sqlalchemy import Column, Integer, String
from app.database.config import Base

class Livro(Base):
    __tablename__ = "livros"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    autor = Column(String, nullable=False)
    ano_publicacao = Column(Integer, nullable=False)
