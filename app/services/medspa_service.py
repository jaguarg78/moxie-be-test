from sqlalchemy.orm import Session
from typing import List

from .. import models

def get_medspas(db: Session) -> List[models.Medspa]:
    return db.query(models.Medspa).all()