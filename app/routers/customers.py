from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from .. import schemas
from ..services import customer_service  # Import the service
from ..dependencies import get_db

router = APIRouter(prefix="/customers", tags=["customers"])

@router.get("", response_model=List[schemas.CustomerInfo]) # TODO: Implement pagination
def get_customers(db: Session = Depends(get_db)):
    return customer_service.get_customers(db)
