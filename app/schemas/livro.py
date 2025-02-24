from pydantic import BaseModel

class LivroBase(BaseModel):
    titulo: str
    autor: str
    ano_publicacao: int

class LivroCreate(LivroBase):
    pass

class LivroResponse(LivroBase):
    id: int

    class Config:
        orm_mode = True
