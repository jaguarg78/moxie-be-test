from fastapi import FastAPI

from . import models
from .config import engine
from .routers import customers, medspas, appointments, services

app = FastAPI()

app.include_router(customers.router)
app.include_router(medspas.router)
app.include_router(appointments.router)
app.include_router(services.router)
