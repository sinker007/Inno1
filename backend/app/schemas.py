from pydantic import BaseModel

class VendorBase(BaseModel):
    name: str
    url: str

class VendorCreate(VendorBase):
    pass

class Vendor(VendorBase):
    id: int

    class Config:
        orm_mode = True