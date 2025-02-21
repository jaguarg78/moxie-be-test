from enum import Enum
from datetime import datetime, timedelta, date
from typing import Union, Optional, List

from pydantic import BaseModel, EmailStr

def format_timedelta(td):
    if td is None:
        return None
    
    total_seconds = td.total_seconds()
    hours = int(total_seconds // 3600)
    minutes = int((total_seconds % 3600) // 60)
    
    return f"{hours:02d}:{minutes:02d}"

class AppointmentStatus(str, Enum):
    SCHEDULED = 'scheduled'
    COMPLETED = 'completed'
    CANCELED = 'canceled'

class CustomerInfo(BaseModel):
    id: int
    name: str
    
    class Config:
        from_attributes = True
        
class MedspasInfo(BaseModel):
    id: int
    name: str
    
    class Config:
        from_attributes = True

class MedspaBase(BaseModel):
    id: int
    name: str
    address: str
    phone: str
    email: EmailStr
    
    appointments: List["AppointmentBase"] = []
    services: List["ServiceBase"] = []
    
    class Config:
        from_attributes = True

class CustomerBase(BaseModel):
    id: int
    name: str
    username: str
    password: str

    class Config:
        from_attributes = True

class ServiceId(BaseModel):
    id: int
    
    class Config:
        from_attributes = True

class ServiceBase(BaseModel):
    name: str
    description: str
    price: float
       
    class Config:
        from_attributes = True
        
class ServiceCreate(ServiceBase):
    duration: str
       
    class Config:
        from_attributes = True


class ServiceUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    duration: Optional[str] = None

    class Config:
        from_attributes = True
        extra = "allow"
  
class ServiceInfo(ServiceId, ServiceBase):
    duration: Optional[Union[str, timedelta]] = None

    class Config:
        from_attributes = True
        json_encoders = {
            timedelta: lambda td: format_timedelta(td)
        }

class AppointmentId(BaseModel):
    id: int
    
    class Config:
        from_attributes = True
        json_encoders = {
            timedelta: lambda td: format_timedelta(td)
        }

   
class AppointmentBase(BaseModel):
    start_time: datetime
    
    class Config:
        from_attributes = True
    
class AppointmentCreate(AppointmentBase):
    service_ids: List[int]
    medspa_id: int

    class Config:
        from_attributes = True

class AppointmentInfo(AppointmentId, AppointmentBase):
    total_duration: timedelta
    total_price: float = 0.0
    services: List[ServiceInfo]
    status: AppointmentStatus = AppointmentStatus.SCHEDULED

    class Config:
        from_attributes = True
        json_encoders = {
            timedelta: lambda td: format_timedelta(td)
        }
