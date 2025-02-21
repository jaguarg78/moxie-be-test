from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import and_, func
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound
from typing import List
from datetime import datetime, timedelta, date

from .. import schemas
from ..services import service_service
from ..dependencies import get_db

router = APIRouter(prefix="/medspa/{medspa_id}/services", tags=["services"])

@router.post("", status_code=status.HTTP_201_CREATED, response_model=schemas.ServiceId | None)
def create_service(medspa_id: int, service: schemas.ServiceCreate, db: Session = Depends(get_db)):
    try:
        return service_service.create_service(medspa_id, service, db)
    except Exception as e:
        HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")

@router.put("/{service_id}", status_code=status.HTTP_200_OK, response_model=schemas.ServiceId | None)
def update_service(medspa_id: int, service_id: int, service: schemas.ServiceUpdate, db: Session = Depends(get_db)):
    try:
        return service_service.update_service(medspa_id, service_id, service, db)
    except Exception as e:
        HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"{e}")
    
@router.get("", response_model=List[schemas.ServiceInfo] | None)
def get_services(medspa_id: int, db: Session = Depends(get_db)): # TODO: Implement pagination
    try:
        return service_service.get_services(medspa_id, db)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"{e}")

@router.get("/{service_id}", response_model=schemas.ServiceInfo)
def get_service(medspa_id: int, service_id: int, db: Session = Depends(get_db)):
    try:
        return service_service.get_service(medspa_id, service_id, db)
    except NoResultFound:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Service not found")

