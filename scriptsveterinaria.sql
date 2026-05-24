-- ==========================================
-- 1. Creación de Usuario
-- ==========================================
-- (Ejecutar como SYSTEM o SYS)
-- CREATE USER VETERINARIA_DB IDENTIFIED BY VETERINARIA_DB;
-- GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO VETERINARIA_DB;

-- Conectarse como el nuevo usuario
-- CONNECT VETERINARIA_DB/VETERINARIA_DB;

-- ==========================================
-- 2. Creación de Tablas
-- ==========================================

CREATE TABLE PROPIETARIO (
    id_propietario NUMBER PRIMARY KEY,
    cedula VARCHAR2(10) NOT NULL UNIQUE,
    nombres VARCHAR2(80) NOT NULL,
    telefono VARCHAR2(15),
    ciudad VARCHAR2(50) NOT NULL,
    correo VARCHAR2(100) UNIQUE
);

CREATE TABLE ESPECIE (
    id_especie NUMBER PRIMARY KEY,
    nombre_especie VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE MASCOTA (
    id_mascota NUMBER PRIMARY KEY,
    nombre_mascota VARCHAR2(60) NOT NULL,
    raza VARCHAR2(60),
    edad NUMBER(3) NOT NULL,
    peso NUMBER(5,2) NOT NULL,
    id_propietario NUMBER NOT NULL,
    id_especie NUMBER NOT NULL,
    CONSTRAINT fk_mascota_propietario FOREIGN KEY (id_propietario) 
        REFERENCES PROPIETARIO(id_propietario),
    CONSTRAINT fk_mascota_especie FOREIGN KEY (id_especie) 
        REFERENCES ESPECIE(id_especie)
);

CREATE TABLE ESPECIALIDAD (
    id_especialidad NUMBER PRIMARY KEY,
    nombre_especialidad VARCHAR2(80) NOT NULL UNIQUE
);

CREATE TABLE VETERINARIO (
    id_veterinario NUMBER PRIMARY KEY,
    nombres VARCHAR2(80) NOT NULL,
    cedula VARCHAR2(10) NOT NULL UNIQUE,
    sueldo NUMBER(8,2) NOT NULL,
    id_especialidad NUMBER NOT NULL,
    CONSTRAINT fk_veterinario_especialidad FOREIGN KEY (id_especialidad) 
        REFERENCES ESPECIALIDAD(id_especialidad)
);

CREATE TABLE CONSULTA (
    id_consulta NUMBER PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    diagnostico VARCHAR2(150) NOT NULL,
    costo NUMBER(8,2) NOT NULL,
    estado VARCHAR2(30) NOT NULL,
    id_mascota NUMBER NOT NULL,
    id_veterinario NUMBER NOT NULL,
    CONSTRAINT fk_consulta_mascota FOREIGN KEY (id_mascota) 
        REFERENCES MASCOTA(id_mascota),
    CONSTRAINT fk_consulta_veterinario FOREIGN KEY (id_veterinario) 
        REFERENCES VETERINARIO(id_veterinario),
    CONSTRAINT chk_estado_consulta CHECK (estado IN ('COMPLETADA', 'PENDIENTE', 'CANCELADA'))
);

-- ==========================================
-- 3. Inserts de Datos
-- ==========================================

INSERT INTO PROPIETARIO VALUES (1, '1801111111', 'Carlos Pérez', '0991111111', 'Ambato', 'carlos@mail.com');
INSERT INTO PROPIETARIO VALUES (2, '1802222222', 'María López', '0992222222', 'Quito', 'maria@mail.com');

INSERT INTO ESPECIE VALUES (1, 'Perro');
INSERT INTO ESPECIE VALUES (2, 'Gato');

INSERT INTO MASCOTA VALUES (1, 'Max', 'Labrador', 5, 28.5, 1, 1);
INSERT INTO MASCOTA VALUES (2, 'Luna', 'Siamés', 3, 5.2, 2, 2);

INSERT INTO ESPECIALIDAD VALUES (1, 'Medicina General');
INSERT INTO ESPECIALIDAD VALUES (2, 'Cirugía');

INSERT INTO VETERINARIO VALUES (1, 'Dr. Andrés Ramos', '1701111111', 1200, 1);
INSERT INTO VETERINARIO VALUES (2, 'Dra. Paola Vega', '1702222222', 1500, 2);

INSERT INTO CONSULTA VALUES (1, DATE '2025-05-01', 'Vacunación anual', 50, 'COMPLETADA', 1, 1);
INSERT INTO CONSULTA VALUES (2, DATE '2025-05-02', 'Cirugía de rodilla', 250, 'COMPLETADA', 2, 2);
INSERT INTO CONSULTA VALUES (3, DATE '2025-05-03', 'Revisión general', 40, 'COMPLETADA', 1, 1);

COMMIT;

-- CONSULTAS PRINCIPALES (1-10)

SELECT nombre_mascota, raza, edad FROM MASCOTA WHERE edad > 4;
SELECT id_consulta, fecha_consulta, diagnostico, costo FROM CONSULTA ORDER BY costo DESC;
SELECT m.nombre_mascota, p.nombres AS propietario, p.ciudad FROM MASCOTA m JOIN PROPIETARIO p ON m.id_propietario = p.id_propietario;
SELECT c.id_consulta, m.nombre_mascota, v.nombres AS veterinario, e.nombre_especialidad FROM CONSULTA c JOIN MASCOTA m ON c.id_mascota = m.id_mascota JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario JOIN ESPECIALIDAD e ON v.id_especialidad = e.id_especialidad;
SELECT e.nombre_especie, COUNT(m.id_mascota) AS total_mascotas FROM ESPECIE e LEFT JOIN MASCOTA m ON e.id_especie = m.id_especie GROUP BY e.nombre_especie;
SELECT e.nombre_especie, COUNT(m.id_mascota) AS total_mascotas FROM ESPECIE e JOIN MASCOTA m ON e.id_especie = m.id_especie GROUP BY e.nombre_especie HAVING COUNT(m.id_mascota) > 1;
SELECT id_consulta, diagnostico, costo FROM CONSULTA WHERE costo > (SELECT AVG(costo) FROM CONSULTA);
SELECT v.nombres, SUM(c.costo) AS total_generado FROM VETERINARIO v JOIN CONSULTA c ON v.id_veterinario = c.id_veterinario GROUP BY v.id_veterinario, v.nombres;
SELECT v.nombres, SUM(c.costo) AS total_generado FROM VETERINARIO v JOIN CONSULTA c ON v.id_veterinario = c.id_veterinario GROUP BY v.id_veterinario, v.nombres HAVING SUM(c.costo) > (SELECT AVG(costo) FROM CONSULTA);
SELECT p.nombres AS propietario, m.nombre_mascota, e.nombre_especie, c.diagnostico FROM PROPIETARIO p JOIN MASCOTA m ON p.id_propietario = m.id_propietario JOIN ESPECIE e ON m.id_especie = e.id_especie JOIN CONSULTA c ON m.id_mascota = c.id_mascota;

-- CONSULTAS ADICIONALES (11-25)

SELECT nombre_mascota, peso FROM MASCOTA WHERE peso > 10;
SELECT nombres, sueldo FROM VETERINARIO WHERE sueldo > 1300;
SELECT nombre_mascota FROM MASCOTA ORDER BY nombre_mascota;
SELECT id_consulta, diagnostico, costo FROM CONSULTA WHERE costo BETWEEN 30 AND 100;
SELECT nombres, ciudad FROM PROPIETARIO WHERE UPPER(ciudad) = 'AMBATO';
SELECT AVG(costo) AS promedio_costos FROM CONSULTA;
SELECT MAX(costo) AS costo_maximo, MIN(costo) AS costo_minimo FROM CONSULTA;
SELECT m.nombre_mascota, COUNT(c.id_consulta) AS total_consultas FROM MASCOTA m LEFT JOIN CONSULTA c ON m.id_mascota = c.id_mascota GROUP BY m.id_mascota, m.nombre_mascota;
SELECT v.nombres, SUM(c.costo) AS total_generado FROM VETERINARIO v JOIN CONSULTA c ON v.id_veterinario = c.id_veterinario GROUP BY v.id_veterinario, v.nombres HAVING SUM(c.costo) > 100;
SELECT m.nombre_mascota, c.costo FROM MASCOTA m JOIN CONSULTA c ON m.id_mascota = c.id_mascota WHERE c.costo = (SELECT MAX(costo) FROM CONSULTA);
SELECT c.id_consulta, v.nombres, e.nombre_especialidad FROM CONSULTA c JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario JOIN ESPECIALIDAD e ON v.id_especialidad = e.id_especialidad WHERE e.nombre_especialidad = 'Medicina General';
SELECT p.nombres, COUNT(m.id_mascota) AS total_mascotas FROM PROPIETARIO p LEFT JOIN MASCOTA m ON p.id_propietario = m.id_propietario GROUP BY p.id_propietario, p.nombres;
SELECT c.id_consulta, m.nombre_mascota, c.diagnostico FROM CONSULTA c JOIN MASCOTA m ON c.id_mascota = m.id_mascota;
SELECT id_consulta, diagnostico, costo FROM CONSULTA WHERE costo < (SELECT AVG(costo) FROM CONSULTA);
SELECT SUM(costo) AS total_general FROM CONSULTA;