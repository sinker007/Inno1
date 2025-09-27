from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

class Vendor(Base):
    __tablename__ = "vendors"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    url = Column(String, unique=True, index=True)

    scores = relationship("Score", back_populates="vendor")

class Risk(Base):
    __tablename__ = "risks"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    description = Column(String)

class Score(Base):
    __tablename__ = "scores"

    id = Column(Integer, primary_key=True, index=True)
    value = Column(Float, index=True)
    vendor_id = Column(Integer, ForeignKey("vendors.id"))
    risk_id = Column(Integer, ForeignKey("risks.id"))

    vendor = relationship("Vendor", back_populates="scores")
    risk = relationship("Risk")