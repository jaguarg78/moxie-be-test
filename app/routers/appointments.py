from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import and_, func
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound
from typing import List
from datetime import datetime, timedelta, date

from ..import schemas
from ..services import appointment_service
from ..dependencies import get_db

router = APIRouter(prefix="/customers/{customer_id}/appointments", tags=["appointments"])

@router.post("", status_code=status.HTTP_201_CREATED, response_model=schemas.AppointmentId)
def create_appointment(customer_id: int, appointment: schemas.AppointmentCreate,  db: Session = Depends(get_db)):
    try:
        return appointment_service.create_appointment(customer_id, appointment, db)
    except Exception as e:
        HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"{e}")
    
@router.put("/{appointment_id}/complete", status_code=status.HTTP_200_OK, response_model=schemas.AppointmentId)
def complete_appointment(customer_id: int, appointment_id: int, db: Session = Depends(get_db)):
    try:
        return appointment_service.complete_appointment(customer_id, appointment_id, db)
    except Exception as e:
        HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
        
@router.put("/{appointment_id}/cancel", status_code=status.HTTP_200_OK, response_model=schemas.AppointmentId)
def cancel_appointment(customer_id: int, appointment_id: int, db: Session = Depends(get_db)):
    try:
        return appointment_service.cancel_appointment(customer_id, appointment_id, db)
    except Exception as e:
        HTTPException(status_code=status.HTTP_400_NOT_FOUND, detail=f"{e}")

@router.get("", response_model=List[schemas.AppointmentInfo]) # TODO: Implement pagination
def get_appointments(customer_id: int, status: schemas.AppointmentStatus | None = None, start_date: date | None = None, db: Session = Depends(get_db)):
    return appointment_service.get_appointments(customer_id, db, status, start_date)

@router.get("/{appointment_id}", response_model=schemas.AppointmentInfo)
def get_appointment(customer_id: int, appointment_id: int, db: Session = Depends(get_db)):
    try:
        return appointment_service.get_appointment(customer_id, appointment_id, db)
    except NoResultFound:
        HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Appointment not found")
