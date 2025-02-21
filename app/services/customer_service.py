from sqlalchemy.orm import Session
from typing import List

from .. import models

def get_customers(db: Session) -> List[models.Customer]:
    return db.query(models.Customer).all()