CREATE TABLE medspas (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    address    TEXT NOT NULL,
    phone      VARCHAR(20) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE customers (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    username   TEXT NOT NULL,
    password   TEXT NOT NULL,
    medspa_id  INTEGER NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (medspa_id) REFERENCES medspas(id)
);

CREATE TABLE appointments (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time   DATETIME NOT NULL,
    status       TEXT NOT NULL DEFAULT 'scheduled',
    medspa_id    INTEGER NOT NULL,
    customer_id  INTEGER NOT NULL,
    created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at   DATETIME,
    completed_at DATETIME,
    canceled_at  DATETIME,
    FOREIGN KEY (medspa_id) REFERENCES medspas(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE services (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    description TEXT NOT NULL,
    price       REAL NOT NULL,
    duration    TEXT NOT NULL,
    medspa_id   INTEGER NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at  DATETIME,
    FOREIGN KEY (medspa_id) REFERENCES medspas(id)
);

CREATE TABLE appointment_services (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    service_id     INTEGER NOT NULL,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at     DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);

CREATE INDEX idx_appointment_medspas ON appointments(medspa_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_appointments_customer ON appointments(customer_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_medspas ON services(medspa_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_customer_medspa ON customers(medspa_id) WHERE deleted_at IS NULL;

-- SQLite uses different syntax for unique constraints
CREATE UNIQUE INDEX uq_medspas_email ON medspas(name, email);
CREATE UNIQUE INDEX uq_services_medspas ON services(name, medspa_id);
CREATE UNIQUE INDEX uq_appointment_service ON appointment_services(appointment_id, service_id);
CREATE UNIQUE INDEX uq_customer_username ON customers(username);
