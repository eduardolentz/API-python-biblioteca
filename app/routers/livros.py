from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database.config import SessionLocal
from app.models.livro import Livro
from app.schemas.livro import LivroCreate, LivroResponse

router = APIRouter(prefix="/api/livros", tags=["Livros"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=List[LivroResponse])
def listar_livros(db: Session = Depends(get_db)):
    return db.query(Livro).all()

@router.post("/", response_model=LivroResponse)
def adicionar_livro(livro: LivroCreate, db: Session = Depends(get_db)):
    livro_model = Livro(**livro.dict())
    db.add(livro_model)
    db.commit()
    db.refresh(livro_model)
    return livro_model

@router.get("/{livro_id}", response_model=LivroResponse)
def obter_livro(livro_id: int, db: Session = Depends(get_db)):
    livro = db.query(Livro).filter(Livro.id == livro_id).first()
    if livro is None:
        raise HTTPException(status_code=404, detail="Livro não encontrado")
    return livro

@router.put("/{livro_id}", response_model=LivroResponse)
def atualizar_livro(livro_id: int, livro_atualizado: LivroCreate, db: Session = Depends(get_db)):
    livro = db.query(Livro).filter(Livro.id == livro_id).first()
    if livro is None:
        raise HTTPException(status_code=404, detail="Livro não encontrado")
    for key, value in livro_atualizado.dict().items():
        setattr(livro, key, value)
    db.commit()
    db.refresh(livro)
    return livro

@router.delete("/{livro_id}", response_model=dict)
def remover_livro(livro_id: int, db: Session = Depends(get_db)):
    livro = db.query(Livro).filter(Livro.id == livro_id).first()
    if livro is None:
        raise HTTPException(status_code=404, detail="Livro não encontrado")
    db.delete(livro)
    db.commit()
    return {"detail": "Livro removido com sucesso"}
