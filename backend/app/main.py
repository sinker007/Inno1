from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from . import models, database

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

@app.post("/vendors/")
def create_vendor(name: str, url: str, db: Session = Depends(database.get_db)):
    db_vendor = models.Vendor(name=name, url=url)
    db.add(db_vendor)
    db.commit()
    db.refresh(db_vendor)
    return db_vendor

@app.get("/")
def read_root():
    return {"message": "Third-Party Risk Radar API"}