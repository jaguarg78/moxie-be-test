from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import os
from dotenv import load_dotenv

load_dotenv()

USE_PSQL = bool(int(os.environ.get("USE_PSQL")))
DATABASE_URL_PSQL = os.environ.get("DATABASE_URL_PSQL")
DATABASE_URL_SQLI = os.environ.get("DATABASE_URL_SQLI")
DATABASE_URL = DATABASE_URL_PSQL if USE_PSQL else DATABASE_URL_SQLI

engines_by_db = {
    'PSQL': create_engine(DATABASE_URL),
    'SQLI': create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
}

engine = engines_by_db['PSQL' if USE_PSQL else 'SQLI']
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
