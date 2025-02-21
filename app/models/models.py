from enum import Enum
from datetime import datetime, timedelta

from sqlalchemy import create_engine, Table, Column, Integer, String, Float, DateTime, ForeignKey, Interval, Numeric, Boolean, Text, and_, func
from sqlalchemy.orm import Session, sessionmaker, relationship, declarative_base

from ..schemas import AppointmentStatus
from ..config import USE_PSQL


Base = declarative_base()

appointment_services_association = Table(
    "appointment_services",
    Base.metadata,
    Column("appointment_id", Integer, ForeignKey("appointments.id"), primary_key=True),
    Column("service_id", Integer, ForeignKey("services.id"), primary_key=True),
)

class Medspa(Base):
    __tablename__ = "medspas"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    phone = Column(String(20), nullable=False)
    email = Column(String(255), nullable=False, unique=True)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    deleted_at = Column(DateTime)
    appointments = relationship("Appointment", back_populates="medspa")
    services = relationship("Service", back_populates="medspa")

class Service(Base):
    __tablename__ = "services"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    description = Column(Text, nullable=False)
    price = Column(Numeric(10, 2), nullable=False)
    duration = Column((Interval if USE_PSQL else Text), nullable=False)
    medspa_id = Column(Integer, ForeignKey("medspas.id"), nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    deleted_at = Column(DateTime)
    medspa = relationship("Medspa", back_populates="services")
    appointments = relationship("Appointment", secondary=appointment_services_association, back_populates="services")

class Customer(Base):
    __tablename__ = "customers"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    username = Column(Text, nullable=False)
    password = Column(Text, nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    deleted_at = Column(DateTime)
    appointments = relationship("Appointment", back_populates="customer")
   
class Appointment(Base):
    __tablename__ = "appointments"
    
    id = Column(Integer, primary_key=True, index=True)
    start_time = Column(DateTime, nullable=False)
    status = Column(Text, nullable=False, default=AppointmentStatus.SCHEDULED)
    medspa_id = Column(Integer, ForeignKey("medspas.id"), nullable=False)
    customer_id = Column(Integer, ForeignKey("customers.id"), nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    deleted_at = Column(DateTime)
    completed_at = Column(DateTime)
    canceled_at = Column(DateTime)
    medspa = relationship("Medspa", back_populates="appointments")
    customer = relationship("Customer", back_populates="appointments")
    services = relationship("Service", secondary=appointment_services_association, back_populates="appointments")
