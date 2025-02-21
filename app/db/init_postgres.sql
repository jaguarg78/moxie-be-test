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

INSERT INTO medspas(name, address, phone, email) VALUES('medspa_1', 'address_1', 'phone_1', 'email_1');
INSERT INTO medspas(name, address, phone, email) VALUES('medspa_2', 'address_2', 'phone_2', 'email_2');
INSERT INTO medspas(name, address, phone, email) VALUES('medspa_3', 'address_3', 'phone_3', 'email_3');

INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_1', 'description_1', 100.2, '1:30', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_2', 'description_2', 120.2, '0:30', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_3', 'description_3', 130.2, '1:00', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_4', 'description_4', 210.2, '3:00', (SELECT id FROM medspas WHERE name = 'medspa_2'));
INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_5', 'description_5', 220.2, '2:00', (SELECT id FROM medspas WHERE name = 'medspa_2'));
INSERT INTO services(name, description, price, duration, medspa_id) VALUES('service_6', 'description_6', 230.2, '0:30', (SELECT id FROM medspas WHERE name = 'medspa_2'));

INSERT INTO customers(name, username, password, medspa_id) VALUES('customer_1', 'username_1', 'password_1', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO customers(name, username, password, medspa_id) VALUES('customer_2', 'username_2', 'password_2', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO customers(name, username, password, medspa_id) VALUES('customer_3', 'username_3', 'password_3', (SELECT id FROM medspas WHERE name = 'medspa_1'));
INSERT INTO customers(name, username, password, medspa_id) VALUES('customer_4', 'username_4', 'password_4', (SELECT id FROM medspas WHERE name = 'medspa_2'));
INSERT INTO customers(name, username, password, medspa_id) VALUES('customer_5', 'username_5', 'password_5', (SELECT id FROM medspas WHERE name = 'medspa_2'));

INSERT INTO appointments(start_time, medspa_id, customer_id) VALUES('2025-03-01T14:00:00Z', (SELECT id FROM medspas WHERE name = 'medspa_1'), (SELECT id FROM customers WHERE username = 'username_1'));
INSERT INTO appointments(start_time, medspa_id, customer_id) VALUES('2025-03-02T14:00:00Z', (SELECT id FROM medspas WHERE name = 'medspa_1'), (SELECT id FROM customers WHERE username = 'username_1'));
INSERT INTO appointments(start_time, medspa_id, customer_id) VALUES('2025-03-03T14:00:00Z', (SELECT id FROM medspas WHERE name = 'medspa_1'), (SELECT id FROM customers WHERE username = 'username_1'));
INSERT INTO appointments(start_time, medspa_id, customer_id) VALUES('2025-03-04T14:00:00Z', (SELECT id FROM medspas WHERE name = 'medspa_1'), (SELECT id FROM customers WHERE username = 'username_1'));

INSERT INTO appointment_services(appointment_id, service_id) VALUES(3, 1);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(3, 2);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(3, 3);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(1, 1);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(1, 2);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(2, 3);
INSERT INTO appointment_services(appointment_id, service_id) VALUES(4, 2);

-- SELECT * FROM medspas;
-- SELECT * FROM services;
-- SELECT * FROM customers;
-- SELECT * FROM appointments;
-- SELECT * FROM appointment_services;