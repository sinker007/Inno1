from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from . import models, database, schemas
from typing import List

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

@app.post("/vendors/", response_model=schemas.Vendor)
def create_vendor(vendor: schemas.VendorCreate, db: Session = Depends(database.get_db)):
    db_vendor = models.Vendor(name=vendor.name, url=vendor.url)
    db.add(db_vendor)
    db.commit()
    db.refresh(db_vendor)
    return db_vendor

@app.get("/vendors/", response_model=List[schemas.Vendor])
def read_vendors(skip: int = 0, limit: int = 100, db: Session = Depends(database.get_db)):
    vendors = db.query(models.Vendor).offset(skip).limit(limit).all()
    return vendors

@app.get("/")
def read_root():
    return {"message": "Third-Party Risk Radar API"}