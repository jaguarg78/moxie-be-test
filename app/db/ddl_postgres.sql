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
