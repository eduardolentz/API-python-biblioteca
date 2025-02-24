from fastapi import FastAPI
from app.database.config import Base, engine, SessionLocal
from app.routers import livros
from app.models.livro import Livro

# Cria as tabelas no banco de dados
Base.metadata.create_all(bind=engine)

# Função para semear os dados iniciais
def seed_data():
    db = SessionLocal()
    try:
        if db.query(Livro).count() == 0:
            livros_iniciais = [
                Livro(titulo="A Cor Púrpura", autor="Alice Walker", ano_publicacao=1982),
                Livro(titulo="Cem anos de Solidão", autor="Gabriel García Márquez", ano_publicacao=1967),
                Livro(titulo="Moby Dick", autor="Herman Melville", ano_publicacao=1851),
                Livro(titulo="Ainda Estou Aqui", autor="Marcelo Rubens Paiva", ano_publicacao=2015),
                Livro(titulo="Todo o Amor", autor="Vinícius de Moraes", ano_publicacao=1982)
            ]
            db.add_all(livros_iniciais)
            db.commit()
    finally:
        db.close()

# Executa o seed para inserir os livros iniciais, se necessário
seed_data()

app = FastAPI(
    title="API Biblioteca com FastAPI",
    description="API para gerenciar livros em uma biblioteca.",
    version="1.0.0"
)

# Inclui as rotas da aplicação
app.include_router(livros.router)
