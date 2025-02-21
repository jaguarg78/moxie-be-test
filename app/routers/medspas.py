from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from .. import schemas
from ..services import medspa_service
from ..dependencies import get_db

router = APIRouter(prefix="/medspas", tags=["medspas"])

@router.get("", response_model=List[schemas.MedspasInfo]) # TODO: Implement pagination
def get_medspas(db: Session = Depends(get_db)):
    return medspa_service.get_medspas(db)
