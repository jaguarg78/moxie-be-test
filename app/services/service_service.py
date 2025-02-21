from sqlalchemy import and_, func
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound
from typing import List
from datetime import datetime, timedelta, date

from .. import models, schemas

def create_service(medspa_id: int, service: schemas.ServiceCreate, db: Session) -> schemas.ServiceId:
    service = models.Service(**service.model_dump(), medspa_id=medspa_id)
    db.add(service)
    db.commit()
    db.refresh(service)
    return service

def update_service(medspa_id: int, service_id: int, service: schemas.ServiceUpdate, db: Session) -> schemas.ServiceId:
    service_query = db.query(models.Service).filter(and_(models.Service.medspa_id == medspa_id, models.Service.id == service_id))
    new_attributes = service.model_dump(exclude_unset=True)
    service_query.update(new_attributes)
    
    existing_service = service_query.first()
    
    db.commit()
    db.refresh(existing_service)
    
    return existing_service
    
def get_services(medspa_id: int, db: Session) -> List[schemas.ServiceInfo]: # TODO: Implement pagination
    services = db.query(models.Service).filter(models.Service.medspa_id == medspa_id).all()

    return services

def get_service(medspa_id: int, service_id: int, db: Session) -> schemas.ServiceInfo:
    service = db.query(models.Service).filter(and_(models.Service.medspa_id == medspa_id, models.Service.id == service_id)).one()
    
    return service
