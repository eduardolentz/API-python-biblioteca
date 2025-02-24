#!/bin/bash

# Nome do projeto
PROJECT_NAME="API-python-biblioteca"

# Criar diretórios
echo "🛠 Criando diretórios..."
mkdir -p $PROJECT_NAME/{app/{models,database,routers,migrations},Config,Infra,Docs}

# Criar virtualenv
echo "🐍 Criando ambiente virtual..."
cd $PROJECT_NAME
python -m venv venv

# Criar arquivos principais
echo "📜 Criando arquivos principais..."
touch app/__init__.py
touch app/models/__init__.py
touch app/database/__init__.py
touch app/routers/__init__.py
touch app/migrations/__init__.py
touch Config/.env
touch Config/alembic.ini
touch Infra/docker-compose.yml
touch Infra/Dockerfile
touch Docs/README.md
touch requirements.txt
touch .gitignore
touch main.py

# Adicionar conteúdo ao .gitignore
echo "🔒 Configurando .gitignore..."
cat <<EOL > .gitignore
venv/
__pycache__/
*.pyc
*.pyo
.env
alembic/
EOL

# Criar arquivo models/livro.py
echo "📌 Criando modelo Livro..."
cat <<EOL > app/models/livro.py
from sqlalchemy import Column, Integer, String
from app.database.config import Base

class Livro(Base):
    __tablename__ = "livros"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    autor = Column(String, nullable=False)
    ano_publicacao = Column(Integer, nullable=False)
EOL

# Criar arquivo database/config.py
echo "📌 Configurando o banco de dados..."
cat <<EOL > app/database/config.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:admin@localhost/biblioteca")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
EOL

# Criar arquivo routers/livros.py
echo "📌 Criando as rotas..."
cat <<EOL > app/routers/livros.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.config import SessionLocal
from app.models.livro import Livro

router = APIRouter(prefix="/api/livros", tags=["Livros"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/")
def listar_livros(db: Session = Depends(get_db)):
    return db.query(Livro).all()

@router.post("/")
def adicionar_livro(livro: Livro, db: Session = Depends(get_db)):
    db.add(livro)
    db.commit()
    db.refresh(livro)
    return livro
EOL

# Criar arquivo main.py
echo "📌 Criando main.py..."
cat <<EOL > main.py
from fastapi import FastAPI
from app.database.config import Base, engine
from app.routers import livros

# Criar tabelas no banco
Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Biblioteca com FastAPI")

# Incluir rotas
app.include_router(livros.router)
EOL

# Criar requirements.txt
echo "📦 Adicionando dependências ao requirements.txt..."
cat <<EOL > requirements.txt
fastapi
uvicorn
sqlalchemy
psycopg2
alembic
python-dotenv
EOL

# Criar Config/.env
echo "🔑 Criando arquivo .env..."
cat <<EOL > Config/.env
DATABASE_URL=postgresql://postgres:admin@localhost/biblioteca
EOL

# Criar alembic.ini
echo "🛠 Criando arquivo de configuração Alembic..."
cat <<EOL > Config/alembic.ini
[alembic]
script_location = app/migrations
EOL

# Criar Dockerfile
echo "🐳 Criando Dockerfile..."
cat <<EOL > Infra/Dockerfile
FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL

# Criar docker-compose.yml
echo "🐳 Criando docker-compose.yml..."
cat <<EOL > Infra/docker-compose.yml
version: "3.8"

services:
  api:
    build: .
    container_name: api-python-biblioteca
    ports:
      - "8000:8000"
    depends_on:
      - postgres
    environment:
      - DATABASE_URL=postgresql://postgres:admin@postgres-db/biblioteca
    networks:
      - app-network

  postgres:
    image: postgres:15
    container_name: postgres-db
    restart: always
    environment:
      POSTGRES_DB: biblioteca
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: admin
    ports:
      - "5432:5432"
    networks:
      - app-network

networks:
  app-network:
EOL

echo "✅ Setup concluído! 🚀"
