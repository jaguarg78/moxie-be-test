CREATE TABLE IF NOT EXISTS medspas (
  id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name       TEXT         NOT NULL,
  address    TEXT         NOT NULL,
  phone      VARCHAR(20)  NOT NULL,
  email      VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS customers (
  id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name       TEXT    NOT NULL,
  username   TEXT    NOT NULL,
  password   TEXT    NOT NULL,
  medspa_id  INTEGER NOT NULL REFERENCES medspas(id),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS appointments (
  id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  start_time     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status         TEXT    NOT NULL DEFAULT 'scheduled',
  medspa_id      INTEGER NOT NULL REFERENCES medspas(id),
  customer_id    INTEGER NOT NULL REFERENCES customers(id),
  completed_at   TIMESTAMP WITHOUT TIME ZONE,
  canceled_at    TIMESTAMP WITHOUT TIME ZONE,
  created_at     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  deleted_at     TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS services (
  id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name        TEXT          NOT NULL,
  description TEXT          NOT NULL,
  price       NUMERIC(10,2) NOT NULL,
  duration    INTERVAL      NOT NULL,
  medspa_id   INTEGER       NOT NULL REFERENCES medspas(id),
  created_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  deleted_at  TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS appointment_services (
  id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  appointment_id  INTEGER NOT NULL REFERENCES appointments(id),
  service_id      INTEGER NOT NULL REFERENCES services(id),
  created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  deleted_at      TIMESTAMP WITHOUT TIME ZONE
);

CREATE INDEX idx_appointment_medspas ON appointments(medspa_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_appointments_customer ON appointments(customer_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_medspas ON services(medspa_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_customer_medspa ON customers(medspa_id) WHERE deleted_at IS NULL;

ALTER TABLE medspas ADD CONSTRAINT uq_medspas_email UNIQUE (name, email);
ALTER TABLE services ADD CONSTRAINT uq_services_medspas UNIQUE (name, medspa_id);
ALTER TABLE appointment_services ADD CONSTRAINT uq_appointment_service UNIQUE (appointment_id, service_id);
ALTER TABLE customers ADD CONSTRAINT uq_customer_username UNIQUE (username);
