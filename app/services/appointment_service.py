from sqlalchemy import and_, func
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound
from typing import List
from datetime import datetime, timedelta, date

from .. import models, schemas
from ..config import USE_PSQL

def create_appointment(customer_id: int, appointment: schemas.AppointmentCreate,  db: Session) -> schemas.AppointmentId:
    new_appointment = models.Appointment(start_time=appointment.start_time, medspa_id =  appointment.medspa_id, customer_id = customer_id)
    db.add(new_appointment)
    db.commit()
    db.refresh(new_appointment)

    service_ids = appointment.service_ids
    services = db.query(models.Service).filter(models.Service.medspa_id == appointment.medspa_id, models.Service.id.in_(service_ids)).all()

    if len(services) != len(service_ids):
        raise ValueError("Not valid service(s)")
    
    for service in services:
        new_appointment.services.append(service)
            
    db.commit()
    return new_appointment
    
def complete_appointment(customer_id: int, appointment_id: int, db: Session) -> schemas.AppointmentId:
    appointment_query = db.query(models.Appointment).filter(and_(models.Appointment.id == appointment_id, models.Appointment.customer_id == customer_id))
        
    appointment = appointment_query.first()
    if appointment.status != schemas.AppointmentStatus.SCHEDULED: # TODO: Implement statemachine
        raise NoResultFound("Wrong prev state to transition")
    
    appointment_query.update({'status': schemas.AppointmentStatus.COMPLETED, 'updated_at': datetime.utcnow(), 'completed_at': datetime.utcnow()})
    
    db.commit()
    db.refresh(appointment)
    
    return appointment      
        
def cancel_appointment(customer_id: int, appointment_id: int, db: Session) -> schemas.AppointmentId:
    appointment_query = db.query(models.Appointment).filter(and_(models.Appointment.id == appointment_id, models.Appointment.customer_id == customer_id))
    
    appointment = appointment_query.first()
    if appointment.status != schemas.AppointmentStatus.SCHEDULED: # TODO: Implement statemachine
        raise NoResultFound("Wrong prev state to transition")
    
    appointment_query.update({'status': schemas.AppointmentStatus.CANCELED, 'updated_at': datetime.utcnow(), 'canceled_at': datetime.utcnow()})

    db.commit()
    db.refresh(appointment)
    
    return appointment

def str_to_timedelta(str_duration):
    if not str_duration:
        return timedelta(0)
    
    try:
        hours, minutes = map(int, str_duration.split(':'))
        return timedelta(hours=hours, minutes=minutes)
    except ValueError:
        return timedelta(0)

def get_appointments(customer_id: int, db: Session, status: schemas.AppointmentStatus | None = None, start_date: date | None = None) -> List[schemas.AppointmentInfo]:
    # TODO: Improve sqlalchemy query to have something like:
    # SELECT appointment_services.appointment_id, 
    #        SUM(services.price) as total_price,
    #        SUM(services.duration) as total_duration
    #   FROM appointments 
    #        JOIN appointment_services ON appointment_services.appointment_id = appointments.id 
    #        JOIN services ON appointment_services.service_id = services.id
    # avoiding n+1
    # Option 2: eager loading
    appointments = db.query(models.Appointment).join(models.Customer).filter(and_(models.Appointment.customer_id == customer_id))
    if status is not None:
        appointments = appointments.filter(models.Appointment.status == status) 
    if start_date is not None:
        appointments = appointments.filter(func.date(models.Appointment.start_time) >= start_date)  
    
    appointment_infos = [
        schemas.AppointmentInfo(
            id=appointment.id,
            start_time=appointment.start_time,
            services=appointment.services,
            status=appointment.status,
            total_price=sum(service.price for service in appointment.services),
            total_duration=sum(((service.duration if USE_PSQL else str_to_timedelta(service.duration)) for service in appointment.services), timedelta(0))
        ) for appointment in appointments.all()
    ]
    
    return appointment_infos

def get_appointment(customer_id: int, appointment_id: int, db: Session) -> schemas.AppointmentInfo:
    appointment = db.query(models.Appointment).join(models.Customer).filter(and_(models.Appointment.customer_id == customer_id, models.Appointment.id == appointment_id)).first()
    
    services = appointment.services
    appointment_info = schemas.AppointmentInfo(
        id=appointment.id,
        start_time=appointment.start_time,
        services=services,
        status=appointment.status,
        total_price=sum(service.price for service in services),
        total_duration=sum(((service.duration if USE_PSQL else str_to_timedelta(service.duration)) for service in services), timedelta(0))
    ) 

    return appointment_info
