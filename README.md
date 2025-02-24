# API Biblioteca - Python

Uma API para gerenciamento de livros, desenvolvida em **Python** utilizando **FastAPI**, **SQLAlchemy** e **Alembic** para migrações de banco de dados. O objetivo do projeto é fornecer endpoints RESTful para manipular um catálogo de livros.

## 🚀 Tecnologias Utilizadas
- **Python 3.10+**
- **FastAPI**
- **SQLAlchemy**
- **Alembic**
- **PostgreSQL**
- **Docker & Docker Compose**

## 📂 Estrutura do Projeto
```
API-python-biblioteca/
│   main.py             # Ponto de entrada da aplicação
│   alembic.ini         # Configuração do Alembic
│   requirements.txt    # Dependências do projeto
│
├───app
│   ├───database
│   │   ├── config.py   # Configuração do banco de dados
│   │   ├── __init__.py
│   │
│   ├───models
│   │   ├── livro.py    # Modelo SQLAlchemy para a tabela de livros
│   │   ├── __init__.py
│   │
│   ├───routers
│   │   ├── livros.py   # Rotas da API
│   │   ├── __init__.py
│   │
│   ├───migrations      # Migrações do Alembic
│
├───docker
│   ├── Dockerfile
│   ├── docker-compose.yml
│
└───.env               # Variáveis de ambiente
```

## 🛠️ Configuração e Execução
### 1️⃣ Clonar o Repositório
```sh
git clone https://github.com/seu-usuario/API-python-biblioteca.git
cd API-python-biblioteca
```

### 2️⃣ Criar e Ativar o Ambiente Virtual
```sh
python -m venv venv
# Ativar no Windows (PowerShell)
venv\Scripts\Activate.ps1
# Ativar no Linux/Mac
source venv/bin/activate
```

### 3️⃣ Instalar as Dependências
```sh
pip install -r requirements.txt
```

### 4️⃣ Configurar o Banco de Dados (PostgreSQL)
1. Configure suas credenciais no arquivo **.env**:
```ini
POSTGRES_USER=postgres
POSTGRES_PASSWORD=admin
POSTGRES_DB=biblioteca
POSTGRES_HOST=localhost
```
2. Criar as tabelas:
```sh
alembic upgrade head
```

### 5️⃣ Rodar a Aplicação
```sh
uvicorn main:app --reload
```

A API estará disponível em: **http://127.0.0.1:8000**

## 📖 Endpoints
### ✅ Listar Todos os Livros
**GET** `/api/livros`

### ✅ Adicionar um Livro
**POST** `/api/livros`
```json
{
  "titulo": "1984",
  "autor": "George Orwell",
  "anoPublicacao": 1949
}
```

### ✅ Atualizar um Livro
**PUT** `/api/livros/{id}`

### ✅ Deletar um Livro
**DELETE** `/api/livros/{id}`

## 🐳 Executando com Docker
```sh
docker-compose up --build
```
A API estará rodando em **http://localhost:8000**

---
📌 **Autor:** [Eduardo Lentz](https://github.com/seu-usuario)  
📌 **Licença:** MIT

