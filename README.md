# Test

## Configuration

This test application can be used either with `sqlite` or `postgres` locally.

1. Clone the repository to your local. `git clone https://github.com/jaguarg78/moxie-be-test.git`.
2. Change the `USE_PSQL` in the `.env` file depending on the DB that is going to be used. 1 to use `postgres`, 0 to use `sqlite`.
3. In the case `postgres` is the selected DB to be used, execute the docker-compose to create the `postgres` container `docker-compose up -d`.
4. Create and activate a venv for the project `python -m venv .venv && source .venv/bin/activate`.
5. Install all requirements `.venv/bin/pip install --no-cache-dir -r requirements.txt`.
6. Run the server `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
7. All the published endpoints will be shown visiting `http://localhost:8000/docs` in a browser. 
8. The doc presented can be used to test the full list of available endpoints.

### sqlite
1. After clonning the repo locally set `USE_PSQL` in the `.env` as `0`.
2. Continue from step `4.`.

## ERD

![Moxie_diagram](https://github.com/user-attachments/assets/e86fa9a9-140f-4856-bb93-f4e60eeb3c96)

## APIs

![Screenshot 2025-02-21 011930](https://github.com/user-attachments/assets/0335ac43-fba2-468e-8408-85fc822e0407)

- `./test.http` can be used to test the implemented endpoints.

## Tech Notes
### Stack
- Python
  - fastapi
  - sqlalchemy
- postgres and sqlite

### Other
- Postgres used to present a technology used by the company.
- Sqlite option provided to help with local test validation.
- Main issue is associated with types:
  - `Interval` type used for duration in `postgres`.
  - `Text` type used for duration in `sqlite`.
- `duration` and `total_duration` fields are expected to have `hh:mm` format.  

## Pending work
- Create authentication layer using either `jwt` or `oauth2`. Based on the provided token the `Customer` can be validated and it would not be necessary to pass the `customer_id` as param.
- Use `statemachine` or `transitions` library to handle the `Appointments` life cycle.
- Create unit tests.
