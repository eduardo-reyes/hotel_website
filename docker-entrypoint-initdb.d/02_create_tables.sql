DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE IF NOT EXISTS hotel(
    id_hotel SERIAL PRIMARY KEY,
    numero INTEGER,
    nombre VARCHAR(100) NOT NULL,
    calle VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    colonia VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    latitud REAL,
    longitud REAL
);

ALTER TABLE hotel ADD CONSTRAINT nombreh1 CHECK(nombre <> '');
ALTER TABLE hotel ADD CONSTRAINT nombreh2 CHECK(nombre ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\&\/\,\(\)'' ]*$');
ALTER TABLE hotel ADD CONSTRAINT calleh1 CHECK(calle <> '');
ALTER TABLE hotel ADD CONSTRAINT calleh2 CHECK(calle ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\&\/\,\(\)'' ]*$');
ALTER TABLE hotel ADD CONSTRAINT estadoh1 CHECK(estado <> '');
ALTER TABLE hotel ADD CONSTRAINT estadoh2 CHECK(estado ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\&\/\,\(\)'' ]*$');
ALTER TABLE hotel ADD CONSTRAINT coloniah1 CHECK(colonia <> '');
ALTER TABLE hotel ADD CONSTRAINT coloniah2 CHECK(colonia ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\&\/\,\(\)'' ]*$');
ALTER TABLE hotel ADD CONSTRAINT paish1 CHECK(pais <> '');
ALTER TABLE hotel ADD CONSTRAINT paish2 CHECK(pais ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\&\/\,\(\)'' ]*$');

CREATE TABLE IF NOT EXISTS habitacion(
    id_habitacion SERIAL,
    id_hotel INT NOT NULL,
    numero INTEGER NOT NULL,
    esta_disponible BOOLEAN NOT NULL,
    costo FLOAT NOT NULL,
    tipo VARCHAR(20) NOT NULL
);

ALTER TABLE habitacion ADD CONSTRAINT habitacion_pk PRIMARY KEY (id_hotel, id_habitacion);
ALTER TABLE habitacion ADD CONSTRAINT habitacion_fk FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS servicio(
    id_servicio SERIAL PRIMARY KEY,
    esta_activo BOOLEAN NOT NULL,
    costo FLOAT NOT NULL,
    tipo VARCHAR(50) NOT NULL
);

ALTER TABLE servicio ADD CONSTRAINT tipo1 CHECK (tipo <> '');
ALTER TABLE servicio ADD CONSTRAINT tipo2 CHECK (tipo ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-\/'' ]*$');

CREATE TABLE IF NOT EXISTS trabajador(
    id_trabajador SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    telefono VARCHAR(10) NOT NULL UNIQUE,
    nombre_completo VARCHAR(300) GENERATED ALWAYS AS (nombre || ' ' || apellido_paterno || ' ' || apellido_materno) STORED,
    fecha_de_nacimiento DATE
);

ALTER TABLE trabajador ADD CONSTRAINT nombret1 CHECK(nombre <> '');
ALTER TABLE trabajador ADD CONSTRAINT nombret2 CHECK(nombre ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');
ALTER TABLE trabajador ADD CONSTRAINT apellido_maternot1 CHECK(apellido_materno <> '');
ALTER TABLE trabajador ADD CONSTRAINT apellido_maternot2 CHECK(apellido_materno ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');
ALTER TABLE trabajador ADD CONSTRAINT apellido_paternot1 CHECK(apellido_paterno <> '');
ALTER TABLE trabajador ADD CONSTRAINT apellido_paternot2 CHECK(apellido_paterno ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');
ALTER TABLE trabajador ADD CONSTRAINT telefonot1 CHECK(telefono <> '');

CREATE TABLE IF NOT EXISTS cliente(
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    nombre_completo VARCHAR(300) GENERATED ALWAYS AS (nombre || ' ' || apellido_paterno || ' ' || apellido_materno) STORED,
    telefono VARCHAR(10) NOT NULL UNIQUE,
    fecha_de_nacimiento DATE NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT nombret1 CHECK(nombre <> '');
ALTER TABLE cliente ADD CONSTRAINT nombret2 CHECK(nombre ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');
ALTER TABLE cliente ADD CONSTRAINT apellido_maternot1 CHECK(apellido_materno <> '');
ALTER TABLE cliente ADD CONSTRAINT apellido_maternot2 CHECK(apellido_materno ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');
ALTER TABLE cliente ADD CONSTRAINT apellido_paternot1 CHECK(apellido_paterno <> '');
ALTER TABLE cliente ADD CONSTRAINT apellido_paternot2 CHECK(apellido_paterno ~ '^[a-zÑñA-ZáéíóúÁÉÍÓÚüÜ0-9:\.\-'' ]*$');

CREATE TABLE IF NOT EXISTS cuenta(
    id_cuenta SERIAL PRIMARY KEY,
    correo_electronico VARCHAR(100) NOT NULL,
    contrasena VARCHAR(128) CHECK (LENGTH(contrasena) >= 8), 
    id_cliente INTEGER
);

ALTER TABLE cuenta ADD CONSTRAINT correo_electronicoc1 CHECK(correo_electronico <> '');
ALTER TABLE cuenta ADD CONSTRAINT correo_electronicoc2 CHECK(correo_electronico ~ '^[a-zA-Z0-9._-]*@[a-zA-Z0-9.-]*\.[a-zA-Z]{2,}$');
ALTER TABLE cuenta ADD CONSTRAINT contrasenac1 CHECK(contrasena <> '');
ALTER TABLE cuenta ADD CONSTRAINT cuenta_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS reservacion(
    id_reservacion SERIAL PRIMARY KEY,
    costo FLOAT NOT NULL,
    check_in TIMESTAMP NOT NULL,
    check_out TIMESTAMP NOT NULL,
    id_habitacion INTEGER,
    id_hotel INTEGER,
    id_cliente INTEGER
);

ALTER TABLE reservacion ADD CONSTRAINT reservacion_fk1 FOREIGN KEY (id_hotel, id_habitacion) REFERENCES habitacion(id_hotel, id_habitacion)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE reservacion ADD CONSTRAINT reservacion_fk2 FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS comentario(
    id_comentario SERIAL,
    id_cliente INT NOT NULL,
    opinion VARCHAR(200) NOT NULL,
    valoracion INTEGER CHECK (valoracion BETWEEN 1 AND 5)
);

ALTER TABLE comentario ADD CONSTRAINT comentario_pk PRIMARY KEY (id_cliente, id_comentario);
ALTER TABLE comentario ADD CONSTRAINT comentario_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS disponer(
    id_trabajador INTEGER,
    nombre VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    telefono VARCHAR(10) NOT NULL UNIQUE,
    nombre_completo VARCHAR(300) GENERATED ALWAYS AS (nombre || ' ' || apellido_paterno || ' ' || apellido_materno) STORED,
    fecha_de_nacimiento DATE,
    id_hotel INTEGER,
    id_cuenta INTEGER,
    correo_electronico VARCHAR(100) NOT NULL,
    contrasena VARCHAR(128) CHECK (LENGTH(contrasena) >= 8), 
    id_cliente INTEGER
);

ALTER TABLE disponer ADD CONSTRAINT disponer_pk PRIMARY KEY (id_trabajador, id_cuenta);
ALTER TABLE disponer ADD CONSTRAINT disponer_fk1 FOREIGN KEY (id_trabajador) REFERENCES trabajador(id_trabajador)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE disponer ADD CONSTRAINT disponer_fk2 FOREIGN KEY (id_cuenta) REFERENCES cuenta(id_cuenta)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS poseer(
    id_cuenta INTEGER,
    correo_electronico VARCHAR(100) NOT NULL,
    contrasena VARCHAR(128) CHECK (LENGTH(contrasena) >= 8), 
    id_cliente INTEGER,
    nombre VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    nombre_completo VARCHAR(300) GENERATED ALWAYS AS (nombre || ' ' || apellido_paterno || ' ' || apellido_materno) STORED,
    telefono VARCHAR(10) NOT NULL UNIQUE,
    fecha_de_nacimiento DATE NOT NULL
);

ALTER TABLE poseer ADD CONSTRAINT poseer_pk PRIMARY KEY (id_cliente, id_cuenta);
ALTER TABLE poseer ADD CONSTRAINT poseer_fk1 FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE poseer ADD CONSTRAINT poseer_fk2 FOREIGN KEY (id_cuenta) REFERENCES cuenta(id_cuenta)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS adquirir(
    id_reservacion INTEGER NOT NULL,
    id_servicio INTEGER NOT NULL
);

ALTER TABLE adquirir ADD CONSTRAINT adquirir_pk PRIMARY KEY (id_reservacion, id_servicio);
ALTER TABLE adquirir ADD CONSTRAINT adquirir_fk1 FOREIGN KEY (id_reservacion) REFERENCES reservacion(id_reservacion)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE adquirir ADD CONSTRAINT adquirir_fk2 FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS factura(
    id_factura SERIAL PRIMARY KEY,
    vencimiento DATE NOT NULL,
    emision DATE NOT NULL,
    total FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS generar(
    id_generar INTEGER,
    id_reservacion INTEGER,
    id_factura INTEGER
);

ALTER TABLE generar ADD CONSTRAINT generar_fk1 FOREIGN KEY (id_reservacion) REFERENCES reservacion(id_reservacion)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE generar ADD CONSTRAINT generar_fk2 FOREIGN KEY (id_factura) REFERENCES factura(id_factura)
ON UPDATE CASCADE ON DELETE CASCADE;

-- INSERTS

-- hotel
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (1, '1315', 'Gran Hotel Hacienda de La Noria', 'Avenida Héroe de Nacozari', 'Aguascalientes', 'Barrio de la Salud', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (2, '601', 'Quinta Real Aguascalientes', 'Avenida Aguascalientes Sur', 'Aguascalientes', 'Jardines de la Asunción', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (3, NULL, 'Fiesta Americana Aguascalientes', 'Los Laureles', 'Aguascalientes', 'Desarrollo Especial Zona de la Feria', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (4, '821', 'Hotel Alameda Grand', 'Antigua Alameda', 'Aguascalientes', 'Héroes', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (5, NULL, 'Hotel Las Trojes', 'Boulevard Luis Donaldo Colosio Murrieta', 'Aguascalientes', 'Desarrollo Especial Galerías', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (6, NULL, 'Hotel Francia Aguascalientes', 'Avenida Francisco I. Madero', 'Aguascalientes', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (7, NULL, 'Hyatt Place Aguascalientes/Bonaterra', 'Avenida Josemaría Escrivá de Balaguer', 'Aguascalientes', 'Villa Bonaterra', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (8, '3421', 'Hotel Coral Y Marina', 'Carretera Tijuana-Ensenada', 'Baja California', 'Zona Playitas', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (9, '10902', 'Hotel Lucerna Tijuana', 'Paseo de los Héroes', 'Baja California', 'Zona Urbana Rio Tijuana', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (10, NULL, 'Vista Hermosa Resort', 'Rosarito - Ensenada', 'Baja California', 'Vista Hermosa Resort', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (11, '4558', 'Grand Hotel Tijuana', 'Boulevard Agua Caliente', 'Baja California', 'Aviacion', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (12, NULL, 'Esperanza, Auberge Resorts Collection', 'Carretera Federal 1', 'Baja California Sur', 'Tourist Corridor', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (13, NULL, 'Grand Velas', 'Carretera Federal 1', 'Baja California Sur', 'Corredor Turístico', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (14, NULL, 'Las Ventanas al Paraiso, A Rosewood Resort', 'Carretera Transpeninsular', 'Baja California Sur', 'Cabo Real', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (15, '1', 'Waldorf Astoria Los Cabos Pedregal', 'Camino del Mar', 'Baja California Sur', 'Pedregal', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (16, '1', 'Pueblo Bonito Montecristo Estates Luxury Villas', 'Paraíso Escondido', 'Baja California Sur', 'Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (17, '71', 'Hacienda Puerta Campeche, an IHG Hotel, Campeche', 'Calle 59', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (18, NULL, 'Hotel Ocean View', 'Joaquín Clausell', 'Campeche', 'Área Ah', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (19, '126', 'Hotel Plaza Campeche', 'Calle 10', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (20, '207', 'Hotel Francis Drake by DOT Tradition', 'Calle 12', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (21, '128', 'Hotel Baluartes', 'Avenida 16 de Septiembre', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (22, '40', 'Hotel El Navegante', 'Calle 65', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (23, '177', 'H177 Hotel', 'Calle 14', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (24, '55', 'Hotel Debliz', 'Gustavo Díaz Ordaz', 'Campeche', 'Barrio de la Ermita', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (25, '15', 'Hotel Plaza Colonial', 'Calle 10', 'Campeche', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (26, '38', 'Hotel Bo', '5 de Mayo', 'Chiapas', 'Barrio de Mexicanos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (27, '24', 'Casa del Alma Hotel Boutique & Spa', '16 de Septiembre', 'Chiapas', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (28, '19', 'Mision Grand San Cristobal de las Casas', 'Francisco I. Madero', 'Chiapas', 'Centro Historico', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (29, '55', 'Hotel Guayaba Inn', 'Calle Comitan', 'Chiapas', 'Barrio del Cerrillo', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (30, '3211', 'Sheraton Chihuahua Soberano', 'Barranca del cobre', 'Chihuahua', 'Barrancas', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (31, NULL, 'Courtyard by Marriott Chihuahua', 'Citadela', 'Chihuahua', 'Saucito', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (32, '3115', 'Highland Chihuahua', 'Periférico de la Juventud', 'Chihuahua', 'Puerta de Hierro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (33, '702', 'Holiday Inn & Suites Chihuahua Expo, an IHG Hotel', 'Escudero', 'Chihuahua', 'San Felipe I Etapa', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (34, '11315', 'Hotel El Casón', 'Avenida Tecnológico', 'Chihuahua', 'Deportistas', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (35, '8800', 'Best Western Plus Chihuahua Aeropuerto', 'Vialidad Ch-P', 'Chihuahua', 'Nueva España I y II', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (36, '8510', 'Los Cedros Hotel Inn Chihuahua', 'Avenida de la Cantera', 'Chihuahua', 'Colonia Las Misiones I', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (37, '3501', 'One Chihuahua Fashion Mall', 'Periférico de la Juventud', 'Chihuahua', 'Puerta de Hierro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (38, '1385', 'Quinta Real Saltillo', 'José Sarmiento', 'Coahuila de Zaragoza', 'Rancho de Peña', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (39, '100', 'Torreon Marriott Hotel', 'Boulevard Independencia', 'Coahuila de Zaragoza', 'Primero de Cobián Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (40, '285', 'La Casona del Banco', 'Ramos Arizpe', 'Coahuila de Zaragoza', 'Colonia Hacienda del Rosario', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (41, '264', 'Hotel Rancho El Morillo', 'Del Morillo', 'Coahuila de Zaragoza', 'Rancho el Morillo', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (42, NULL, 'Wyndham Torreon', 'San Pedro de las Colonias - Torreón', 'Coahuila de Zaragoza', 'Colonia Villas las Margaritas', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (43, NULL, 'Hotel Bluu', 'Libramiento Licenciado Carlos Salinas de Gortari', 'Coahuila de Zaragoza', 'Fracc. Industrial', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (44, '124', 'Hotel Boutique Hacienda del Gobernador Colima', 'Gildardo Gómez', 'Colima', 'Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (45, '1100', 'Hotel Gamma Colima', 'Tercer Anillo Periférico', 'Colima', 'Residencial Esmeralda Norte', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (46, '351', 'Hotel María Isabel', 'Boulevard Camino Real', 'Colima', 'Jardines Vista Hermosa III', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (47, '134', 'Hotel Aldama de Colima', 'Aldama', 'Colima', 'Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (48, '399', 'Hotel San Joaquin', 'Boulevard Camino Real', 'Colima', 'José María Morelos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (49, '399', 'Hotel Los Candiles', 'Boulevard Camino Real', 'Colima', 'José María Morelos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (50, '896', 'Hotel Montroi Express', 'Boulevard Camino Real', 'Colima', 'El Porvenir II', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (51, NULL, 'Hotel America', 'Calle Morelos', 'Colima', 'Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (52, '257', 'Hotel Gobernador', 'Avenida 20 de Noviembre', 'Durango', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (53, '214', 'Hostal de la Monja', 'Calle Constitución', 'Durango', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (54, '906', 'Hotel Posada San Agustin', 'Avenida 20 de Noviembre', 'Durango', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (55, '806', 'Gamma Durango Plaza Vizcaya', 'Gines Vázquez del Mercado', 'Durango', 'Nueva Vizcaya', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (56, NULL, 'Posada San Jorge', 'Calle Constitución', 'Durango', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (57, '4021', 'City Express by Marriott Durango', 'Boulevard Francisco Villa', 'Durango', '20 de Noviembre', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (58, NULL, 'Hotel Casa Ma Elena', 'Calle Pino Suárez', 'Durango', 'Privada de Sahuaro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (59, '2204', 'Hotel Los Arcos', 'Avenida Heroico Colegio Militar', 'Durango', 'Colonia del Maestro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (60, NULL, 'Hotel Town Express', 'Boulevard Felipe Pescador', 'Durango', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (61, '7', '1850 Hotel Boutique', 'Jardín de la Unión', 'Guanajuato', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (62, '7', 'Edelmira Hotel Boutique', 'Allende', 'Guanajuato', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (63, '76', 'Hotel Villa María Cristina', 'Presa de La Olla', 'Guanajuato', 'Barrio de la Presa', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (64, '69', 'Nueve 25 Hotel Boutique', 'Calle Ponciano Aguilar', 'Guanajuato', 'Colonia Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (65, '13', 'Hotel Misión Grand Casa Colorada', 'Cerro de San Miguel', 'Guanajuato', 'Colonia Lomas de Pozuelo', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (66, '168', 'Hotel Quinta Las Acacias', 'Presa de La Olla', 'Guanajuato', 'Barrio de la Presa', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (67, '17', 'Hotel Real De Minas Guanajuato', 'Nejayote', 'Guanajuato', 'Los Pastitos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (68, '13', 'Hotel Chocolate', 'Constancia', 'Guanajuato', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (69, '12', 'Hotel Posada Santa Fe', 'Jardín de la Unión', 'Guanajuato', 'Zona Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (70, NULL, 'Banyan Tree Cabo Marqués', 'Boulevard Cabo Marqués', 'Guerrero', 'Punta Diamante', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (71, NULL, 'Cala de Mar Resort & Spa Ixtapa', 'Punta Ixtapa', 'Guerrero', 'Zona Hotelera II', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (72, NULL, 'Hotel Montetaxco', 'Alfredo Checa Curi', 'Guerrero', 'Lomas de', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (73, NULL, 'La Casa Que Canta', 'Playa La Ropa', 'Guerrero', 'Playa la Ropa', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (74, NULL, 'Playa Viva', 'Zihuatanejo - Acapulco', 'Guerrero', 'Playa Icacos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (75, '51', 'Encanto Acapulco', 'Jacques Cousteau', 'Guerrero', 'Brisas del Marqués', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (76, NULL, 'Azul Ixtapa', 'Punta Ixtapa', 'Guerrero', 'Zona Hotelera II', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (77, NULL, 'Hotel Real del Bosque', 'Calle Tula - San Marcos', 'Hidalgo', 'San Marcos', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (78, NULL, 'Camino Real Pachuca', 'Camino Real de La Plata', 'Hidalgo', 'Zona Plateada', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (79, NULL, 'Las Alamandas', 'Carretera Federal 200', 'Jalisco', 'Las Alamandas', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (80, '311', 'Casa Velas', 'Calle Pelícanos', 'Jalisco', 'Marina Vallarta', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (81, '164', 'Secrets Vallarta Bay Puerto Vallarta', 'David Alfaro Siqueiros', 'Jalisco', 'Las Glorias', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (82, NULL, 'Hyatt Ziva Puerto Vallarta', 'Carretera Costera a Barra de Navidad', 'Jalisco', 'Zona Hotelera', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (83, '11', 'Hotel Boutique Matea Inn (De lujo)', 'Blvd. Ixtapan', 'Estado de México', 'Ixtapan de la Sal', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (84, '44', 'Ixtapan de la Sal Marriott Hotel & Spa', 'José María Morelos Norte', 'Estado de México', 'Fraccionamiento Bugambilias', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (85, '20', 'Danzaluna Hotel Boutique & Spa', 'Cerro de La Bolita', 'Estado de México', 'Centro', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (86, NULL, 'Hotel Boutique Casa Chichipicas', 'Chichipicas', 'Estado de México', 'Agua Fria', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (87, NULL, 'Hotel Ixtapan Spas & Resort', 'Boulevard Arturo San Roman Pontente', 'Estado de México', 'Barrio de San Gaspar', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (88, NULL, 'Hacienda Panoaya', 'Carretera Federal México-Cuautla', 'Estado de México', 'Panoaya', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (89, '201', 'Villa Montaña Hotel & Spa', 'Calle Patzimba', 'Michoacán', 'Vista Bella', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (90, '21', 'Maja Hotel Boutique', 'Calle Manuel Carpio', 'Michoacán', 'Vista Bella', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (91, '70', 'Grand María Hotel Boutique', 'P. Casals', 'Michoacán', 'La Loma', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (92, '31', 'Hotel Porton Del Cielo', 'Camino Real al Estribo', 'Michoacán', 'El Calvario', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (93, '344', 'Hotel Mansión Solís by HOTSSON', 'Avenida Acueducto', 'Michoacán', 'Chapultepec Norte', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (94, '90', 'Hotel de la Soledad', 'Ignacio Zaragoza', 'Michoacán', 'Centro histórico de Morelia', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (95, '117', 'Cantera Diez Hotel Boutique', 'Avenida Francisco I. Madero Poniente', 'Michoacán', 'Centro histórico de Morelia', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (96, '115', 'Amomoxtli', 'Calle Netzahualcóyotl', 'Morelos', 'Valle de Atongo', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (97, '90', 'Hotel & Spa Hacienda de Cortes', 'Plaza Kennedy', 'Morelos', 'Atlacomulco', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (98, NULL, 'Anticavilla', 'Río Amacuzac', 'Morelos', 'Vista Hermosa', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (99, '31', 'Misión del Sol Resort & Spa', 'General Diego Díaz González Mtz.', 'Morelos', 'Jose G. Parres', 'Mexico');
INSERT INTO hotel(id_hotel, numero, nombre, calle, estado, colonia, pais) VALUES (100, '7', 'La Buena Vibra Retreat and Spa Hotel Adults Only', 'San Lorenzo', 'Morelos', 'Valle de Atongo', 'Mexico');



-- Habitacion

INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (1,90,132,'FALSE',5992.43,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (2,2,307,'FALSE',1498.16,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (3,61,302,'FALSE',4454.59,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (4,6,445,'TRUE',9088.41,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (5,53,24,'TRUE',1002.03,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (6,68,384,'FALSE',7613.08,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (7,71,283,'FALSE',3597.47,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (8,72,474,'TRUE',5436.2,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (9,94,213,'FALSE',9833.91,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (10,93,361,'FALSE',3950.63,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (11,76,482,'TRUE',7169.86,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (12,34,356,'FALSE',2572.29,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (13,57,102,'TRUE',5928.29,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (14,64,317,'FALSE',9670.47,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (15,52,297,'TRUE',2165.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (16,26,451,'FALSE',9951.4,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (17,39,155,'FALSE',6977.11,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (18,62,109,'TRUE',8573.54,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (19,48,300,'TRUE',9832.32,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (20,28,401,'TRUE',7815.52,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (21,52,235,'FALSE',3341.8,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (22,95,229,'TRUE',7829.74,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (23,63,29,'TRUE',8410.34,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (24,94,321,'TRUE',9462.41,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (25,91,448,'FALSE',5408.99,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (26,67,323,'TRUE',9690.8,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (27,78,356,'FALSE',1648.26,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (28,56,206,'TRUE',9003.37,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (29,84,266,'TRUE',1681.48,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (30,58,233,'TRUE',5535.15,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (31,4,49,'FALSE',4336.85,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (32,20,414,'FALSE',6678.72,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (33,50,463,'TRUE',6093.23,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (34,77,340,'TRUE',7848.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (35,82,91,'FALSE',5851.96,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (36,71,167,'TRUE',8983.8,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (37,10,336,'TRUE',1655.77,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (38,46,439,'TRUE',8552.41,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (39,57,367,'FALSE',3743.23,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (40,42,451,'TRUE',4608.81,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (41,89,377,'TRUE',1129.13,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (42,37,439,'FALSE',4253.04,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (43,81,197,'FALSE',7565.55,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (44,72,392,'FALSE',6719.17,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (45,87,375,'TRUE',4594.41,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (46,28,490,'TRUE',2985.95,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (47,11,115,'FALSE',7521.38,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (48,18,53,'FALSE',7570.43,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (49,67,459,'TRUE',4613.87,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (50,45,333,'FALSE',4932.44,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (51,40,241,'TRUE',2432.08,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (52,82,166,'FALSE',9917.08,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (53,47,320,'FALSE',5312.41,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (54,44,385,'FALSE',3069.8,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (55,63,367,'FALSE',8920.26,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (56,20,132,'TRUE',7538.55,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (57,51,197,'FALSE',7220.34,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (58,56,107,'TRUE',2471.61,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (59,56,255,'FALSE',8312.11,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (60,89,470,'FALSE',1366.24,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (61,50,486,'FALSE',7953.91,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (62,57,133,'TRUE',9419.48,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (63,9,143,'FALSE',3678.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (64,40,455,'TRUE',9781.16,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (65,96,401,'TRUE',7594.63,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (66,35,360,'TRUE',5562.17,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (67,91,117,'TRUE',1384.29,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (68,73,436,'TRUE',1403.33,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (69,63,473,'TRUE',5939.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (70,19,389,'FALSE',4384.96,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (71,82,83,'TRUE',2925.5,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (72,94,34,'TRUE',8059.11,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (73,7,39,'FALSE',1304.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (74,4,107,'FALSE',6315.2,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (75,16,479,'TRUE',2896.97,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (76,36,419,'FALSE',7472.17,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (77,88,450,'FALSE',8898.06,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (78,46,40,'TRUE',4901.69,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (79,79,429,'TRUE',3590.49,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (80,35,124,'TRUE',8899.43,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (81,70,88,'FALSE',5626.39,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (82,97,255,'TRUE',9946.12,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (83,79,434,'FALSE',5064.68,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (84,34,51,'TRUE',7782.63,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (85,35,347,'FALSE',8102.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (86,86,349,'TRUE',8844.69,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (87,45,62,'TRUE',7675.75,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (88,74,441,'FALSE',6510.71,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (89,74,70,'TRUE',7027.25,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (90,22,328,'TRUE',6836.46,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (91,46,314,'FALSE',2340.19,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (92,63,147,'FALSE',1492.84,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (93,73,428,'TRUE',1098.22,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (94,11,316,'FALSE',2423.71,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (95,11,178,'TRUE',3059.4,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (96,61,374,'FALSE',9116.29,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (97,73,259,'FALSE',9371.34,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (98,94,424,'TRUE',5196.87,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (99,100,90,'FALSE',2061.88,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (100,80,398,'TRUE',9468.8,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (101,27,43,'FALSE',3778.1,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (102,1,324,'TRUE',3028.66,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (103,98,91,'TRUE',3721.38,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (104,40,465,'TRUE',2279.93,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (105,35,52,'FALSE',1545.66,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (106,97,18,'TRUE',8728.33,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (107,8,37,'TRUE',2881.8,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (108,10,476,'TRUE',1283.46,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (109,23,226,'FALSE',6221.09,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (110,18,98,'FALSE',4995.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (111,42,17,'FALSE',8351.7,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (112,81,92,'FALSE',5335.51,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (113,34,475,'TRUE',8667.12,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (114,57,242,'FALSE',4859.33,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (115,1,83,'TRUE',7984.9,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (116,66,92,'FALSE',8341.33,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (117,60,232,'FALSE',7054.2,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (118,33,173,'TRUE',5254.5,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (119,76,371,'TRUE',2885.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (120,42,348,'FALSE',7086.08,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (121,1,213,'TRUE',6879.2,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (122,87,480,'TRUE',5599.58,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (123,44,37,'FALSE',4394.97,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (124,43,126,'TRUE',2485.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (125,40,486,'FALSE',9320.19,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (126,84,468,'TRUE',1579.13,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (127,66,400,'TRUE',4242.8,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (128,10,194,'FALSE',6278.85,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (129,41,293,'TRUE',6006.51,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (130,76,105,'FALSE',8254.51,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (131,38,434,'TRUE',9671.49,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (132,79,34,'TRUE',7368.83,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (133,25,372,'TRUE',3692.22,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (134,8,31,'FALSE',2591.64,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (135,95,9,'TRUE',9439.49,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (136,24,399,'FALSE',3620.14,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (137,14,429,'TRUE',7019.16,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (138,68,48,'FALSE',9299.25,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (139,84,403,'FALSE',3164.86,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (140,85,335,'FALSE',9687.52,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (141,72,30,'TRUE',2082.43,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (142,61,366,'TRUE',9353.99,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (143,46,87,'FALSE',8523.33,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (144,82,151,'FALSE',2806.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (145,7,229,'FALSE',3150.64,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (146,99,360,'FALSE',1942.17,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (147,82,413,'FALSE',2833.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (148,16,432,'FALSE',8980.06,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (149,57,380,'FALSE',3653.09,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (150,14,483,'TRUE',4190.68,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (151,7,234,'TRUE',3766.21,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (152,69,104,'TRUE',4761.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (153,60,40,'TRUE',3052.85,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (154,63,401,'TRUE',8067.99,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (155,96,14,'FALSE',5470.43,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (156,29,432,'TRUE',5534.14,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (157,15,120,'TRUE',5499.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (158,52,494,'TRUE',3079.5,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (159,67,302,'FALSE',4503.61,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (160,52,214,'TRUE',7276.07,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (161,44,64,'TRUE',6266.11,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (162,28,478,'FALSE',6549.86,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (163,26,280,'FALSE',8240.25,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (164,65,263,'FALSE',3136.65,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (165,11,296,'FALSE',4101.41,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (166,32,149,'TRUE',2470.13,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (167,35,360,'FALSE',8475.56,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (168,34,407,'FALSE',1717.14,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (169,75,435,'TRUE',7251.81,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (170,84,75,'FALSE',1624.43,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (171,48,369,'FALSE',9644.0,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (172,12,239,'FALSE',3414.48,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (173,85,476,'TRUE',4045.46,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (174,78,349,'TRUE',4438.74,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (175,55,366,'FALSE',3592.38,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (176,57,174,'FALSE',6367.89,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (177,50,447,'FALSE',6265.11,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (178,67,179,'TRUE',8242.41,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (179,35,500,'FALSE',3963.82,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (180,86,360,'TRUE',7410.83,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (181,99,70,'FALSE',8722.2,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (182,98,266,'TRUE',3732.33,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (183,60,109,'TRUE',8697.01,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (184,34,195,'TRUE',3514.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (185,94,65,'TRUE',5977.53,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (186,28,47,'FALSE',3653.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (187,35,94,'TRUE',9244.63,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (188,84,105,'TRUE',8527.83,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (189,3,268,'TRUE',8323.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (190,39,390,'FALSE',5920.06,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (191,64,374,'FALSE',6378.6,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (192,23,231,'FALSE',4501.8,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (193,90,287,'TRUE',6449.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (194,13,468,'TRUE',9889.68,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (195,20,177,'FALSE',8404.11,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (196,17,456,'TRUE',1791.87,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (197,15,421,'TRUE',2427.86,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (198,79,365,'FALSE',4697.83,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (199,24,160,'FALSE',6132.29,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (200,60,270,'TRUE',2218.48,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (201,40,198,'FALSE',8762.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (202,24,93,'TRUE',1537.06,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (203,6,92,'TRUE',3392.94,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (204,11,194,'TRUE',3253.23,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (205,72,199,'FALSE',3241.6,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (206,11,425,'FALSE',6478.63,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (207,92,68,'TRUE',7594.83,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (208,27,49,'FALSE',6442.15,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (209,69,161,'FALSE',7017.24,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (210,16,94,'TRUE',3595.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (211,71,4,'FALSE',9997.57,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (212,42,446,'FALSE',6322.54,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (213,9,273,'FALSE',4011.37,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (214,16,1,'FALSE',1870.31,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (215,29,240,'FALSE',9887.01,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (216,68,262,'TRUE',6065.62,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (217,86,26,'FALSE',4314.62,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (218,20,349,'FALSE',5606.54,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (219,33,203,'FALSE',1707.73,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (220,93,380,'TRUE',5891.24,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (221,12,138,'FALSE',7324.6,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (222,83,17,'FALSE',8971.35,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (223,61,145,'FALSE',1344.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (224,39,169,'FALSE',8748.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (225,7,374,'TRUE',5432.66,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (226,69,423,'TRUE',3371.22,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (227,83,272,'TRUE',5147.67,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (228,20,319,'FALSE',9337.82,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (229,98,54,'FALSE',7395.0,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (230,55,217,'TRUE',5377.73,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (231,77,46,'FALSE',6870.91,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (232,62,1,'TRUE',9997.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (233,33,322,'FALSE',3323.7,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (234,63,301,'FALSE',4634.95,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (235,98,212,'TRUE',7487.56,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (236,27,460,'TRUE',2265.54,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (237,47,308,'TRUE',2807.71,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (238,86,261,'FALSE',2328.52,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (239,83,392,'FALSE',5650.42,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (240,56,312,'FALSE',5190.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (241,44,379,'TRUE',5730.8,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (242,44,257,'TRUE',5562.6,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (243,50,477,'TRUE',5159.18,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (244,83,167,'FALSE',1064.97,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (245,97,231,'FALSE',6339.08,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (246,78,78,'FALSE',2532.04,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (247,4,78,'FALSE',8769.92,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (248,98,233,'FALSE',3556.09,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (249,80,366,'FALSE',6250.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (250,45,259,'TRUE',9334.58,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (251,74,266,'TRUE',4147.85,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (252,30,267,'FALSE',1848.57,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (253,92,362,'FALSE',3991.58,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (254,62,477,'FALSE',3077.38,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (255,28,431,'FALSE',3588.69,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (256,58,146,'FALSE',7128.21,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (257,100,49,'TRUE',1479.3,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (258,70,48,'TRUE',2877.95,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (259,81,352,'TRUE',6220.35,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (260,87,421,'FALSE',6775.69,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (261,23,240,'TRUE',5682.0,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (262,100,448,'FALSE',8250.26,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (263,44,142,'TRUE',9489.8,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (264,51,283,'FALSE',1079.35,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (265,95,410,'TRUE',1996.18,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (266,75,153,'FALSE',3171.91,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (267,91,460,'TRUE',9929.96,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (268,44,127,'TRUE',8229.38,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (269,63,78,'TRUE',9133.3,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (270,5,467,'TRUE',1734.6,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (271,41,331,'FALSE',4017.2,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (272,3,172,'TRUE',5506.58,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (273,97,493,'FALSE',8863.11,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (274,22,133,'FALSE',5324.83,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (275,71,202,'FALSE',7820.49,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (276,55,455,'TRUE',9144.25,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (277,31,273,'FALSE',1468.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (278,90,282,'TRUE',2246.32,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (279,77,94,'TRUE',5453.68,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (280,9,303,'TRUE',6339.81,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (281,92,311,'TRUE',9969.86,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (282,83,473,'FALSE',2416.67,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (283,65,29,'TRUE',9999.55,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (284,47,480,'FALSE',9463.63,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (285,78,51,'TRUE',5430.88,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (286,84,360,'FALSE',1215.7,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (287,6,404,'TRUE',8961.0,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (288,30,130,'TRUE',9299.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (289,16,333,'FALSE',2253.87,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (290,16,460,'FALSE',6483.45,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (291,48,65,'FALSE',8102.56,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (292,37,190,'FALSE',3896.81,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (293,31,108,'TRUE',5388.76,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (294,71,221,'TRUE',2738.25,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (295,95,335,'TRUE',4483.42,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (296,43,203,'FALSE',1694.39,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (297,66,227,'TRUE',4738.49,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (298,5,68,'FALSE',1509.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (299,70,117,'FALSE',2252.54,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (300,96,155,'FALSE',6213.51,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (301,63,353,'FALSE',5887.02,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (302,68,121,'FALSE',9892.73,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (303,68,226,'TRUE',4748.47,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (304,53,183,'FALSE',6092.82,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (305,38,11,'FALSE',5033.58,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (306,25,218,'FALSE',5451.03,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (307,9,325,'TRUE',2468.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (308,90,297,'FALSE',2513.08,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (309,56,204,'TRUE',8991.2,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (310,22,383,'TRUE',1337.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (311,77,155,'FALSE',2301.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (312,69,393,'TRUE',2148.97,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (313,81,315,'FALSE',8997.13,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (314,27,108,'FALSE',7911.57,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (315,73,84,'FALSE',5516.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (316,55,55,'FALSE',7265.65,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (317,60,185,'FALSE',4186.05,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (318,100,367,'FALSE',2109.02,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (319,76,160,'FALSE',5943.97,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (320,39,316,'TRUE',4447.44,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (321,7,499,'FALSE',6090.48,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (322,68,190,'FALSE',3676.33,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (323,93,81,'TRUE',9037.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (324,38,159,'FALSE',5952.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (325,13,243,'FALSE',8164.53,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (326,48,421,'TRUE',6534.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (327,19,495,'TRUE',6952.08,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (328,5,331,'TRUE',3694.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (329,9,13,'FALSE',4732.8,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (330,83,372,'FALSE',9666.96,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (331,20,389,'TRUE',8775.61,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (332,16,437,'FALSE',4908.05,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (333,50,349,'FALSE',6920.62,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (334,86,382,'FALSE',1404.75,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (335,32,436,'FALSE',7958.44,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (336,59,88,'TRUE',7233.12,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (337,46,173,'TRUE',2013.42,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (338,47,370,'TRUE',2603.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (339,4,133,'TRUE',6033.87,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (340,99,301,'FALSE',9811.18,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (341,65,282,'FALSE',3096.27,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (342,73,217,'TRUE',2901.44,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (343,59,44,'FALSE',9629.31,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (344,77,266,'TRUE',3288.17,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (345,77,143,'TRUE',8042.77,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (346,6,34,'TRUE',9604.83,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (347,40,165,'FALSE',3738.12,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (348,21,152,'FALSE',3351.71,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (349,45,454,'FALSE',3248.43,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (350,64,339,'TRUE',1793.9,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (351,92,233,'TRUE',9926.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (352,77,267,'TRUE',9924.34,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (353,29,491,'FALSE',3979.25,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (354,52,57,'FALSE',3569.38,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (355,48,496,'FALSE',3075.87,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (356,77,220,'TRUE',6443.62,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (357,19,400,'FALSE',7269.4,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (358,28,450,'TRUE',4743.8,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (359,37,80,'FALSE',6573.53,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (360,30,346,'TRUE',9026.52,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (361,28,233,'TRUE',9862.25,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (362,65,351,'TRUE',4687.01,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (363,31,458,'FALSE',3219.82,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (364,18,170,'FALSE',7354.03,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (365,53,79,'TRUE',3232.41,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (366,88,327,'FALSE',1185.66,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (367,30,119,'TRUE',7258.68,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (368,46,462,'FALSE',1233.78,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (369,43,368,'TRUE',6761.64,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (370,40,418,'TRUE',8874.45,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (371,84,342,'FALSE',6263.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (372,4,288,'FALSE',4246.01,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (373,69,129,'FALSE',7328.56,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (374,19,150,'TRUE',7205.83,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (375,60,431,'TRUE',8099.57,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (376,42,168,'FALSE',5529.56,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (377,48,166,'FALSE',3163.33,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (378,15,320,'TRUE',5116.86,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (379,96,303,'TRUE',6346.19,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (380,29,480,'TRUE',6748.57,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (381,8,10,'FALSE',7200.04,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (382,55,480,'TRUE',4174.35,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (383,94,490,'FALSE',8153.79,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (384,34,320,'FALSE',3430.09,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (385,77,253,'TRUE',3279.36,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (386,43,360,'FALSE',1277.69,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (387,75,159,'TRUE',4292.51,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (388,24,44,'FALSE',6714.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (389,21,173,'FALSE',6246.26,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (390,12,309,'FALSE',8171.46,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (391,37,374,'TRUE',4532.59,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (392,83,202,'TRUE',2704.91,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (393,52,404,'FALSE',3577.01,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (394,86,135,'TRUE',5117.67,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (395,85,224,'TRUE',9691.87,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (396,82,120,'FALSE',3059.13,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (397,27,462,'FALSE',6413.94,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (398,61,124,'TRUE',4233.24,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (399,44,333,'FALSE',1927.46,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (400,87,190,'FALSE',8360.31,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (401,39,412,'FALSE',9233.6,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (402,43,351,'FALSE',4579.13,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (403,15,205,'FALSE',1022.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (404,72,137,'TRUE',4083.99,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (405,34,110,'TRUE',5044.6,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (406,68,218,'TRUE',2087.62,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (407,87,182,'TRUE',1609.27,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (408,19,163,'TRUE',2741.89,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (409,93,396,'FALSE',1881.72,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (410,93,85,'FALSE',7255.22,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (411,87,306,'TRUE',1374.15,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (412,68,500,'TRUE',4168.37,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (413,86,425,'TRUE',9692.56,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (414,69,500,'FALSE',5460.82,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (415,25,191,'FALSE',9621.22,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (416,77,44,'TRUE',2630.96,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (417,39,256,'TRUE',3277.82,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (418,52,370,'TRUE',9886.8,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (419,43,480,'TRUE',6314.04,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (420,37,408,'FALSE',1571.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (421,59,95,'FALSE',6562.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (422,58,274,'TRUE',8134.83,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (423,79,304,'FALSE',1253.47,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (424,27,272,'TRUE',1522.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (425,68,334,'FALSE',7209.52,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (426,80,104,'TRUE',3207.26,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (427,42,184,'TRUE',3155.24,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (428,14,440,'TRUE',4890.98,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (429,12,106,'FALSE',1699.7,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (430,27,145,'FALSE',5972.79,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (431,63,366,'FALSE',9269.44,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (432,83,396,'TRUE',6053.1,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (433,92,263,'TRUE',5950.34,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (434,26,422,'FALSE',8890.26,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (435,37,18,'TRUE',8566.31,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (436,16,113,'TRUE',1566.83,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (437,16,498,'FALSE',6554.43,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (438,80,382,'FALSE',2577.72,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (439,12,498,'FALSE',1566.73,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (440,71,68,'TRUE',1992.48,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (441,23,281,'TRUE',5075.41,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (442,63,199,'FALSE',7819.68,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (443,59,150,'TRUE',1324.87,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (444,15,162,'TRUE',1412.49,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (445,18,229,'FALSE',3004.07,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (446,32,500,'TRUE',5725.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (447,27,22,'TRUE',1334.17,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (448,82,63,'TRUE',8325.22,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (449,87,268,'TRUE',8755.5,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (450,16,234,'TRUE',3980.92,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (451,18,170,'TRUE',8021.36,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (452,37,368,'FALSE',8037.3,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (453,3,391,'FALSE',8151.1,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (454,25,376,'TRUE',5613.88,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (455,34,414,'FALSE',3554.85,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (456,3,139,'FALSE',6302.67,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (457,67,151,'TRUE',6634.53,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (458,96,206,'FALSE',7614.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (459,6,406,'FALSE',2437.98,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (460,86,479,'TRUE',2223.52,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (461,67,110,'FALSE',9923.34,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (462,40,370,'FALSE',4871.08,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (463,6,37,'FALSE',1188.67,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (464,97,331,'FALSE',4052.27,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (465,48,378,'FALSE',3402.32,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (466,16,230,'TRUE',8010.52,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (467,8,402,'TRUE',2466.3,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (468,56,352,'FALSE',8919.9,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (469,71,221,'FALSE',7149.23,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (470,41,214,'TRUE',7320.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (471,99,294,'TRUE',1476.82,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (472,58,311,'TRUE',1227.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (473,36,210,'FALSE',8501.65,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (474,3,59,'FALSE',4047.99,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (475,59,403,'TRUE',4673.38,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (476,46,424,'TRUE',4685.82,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (477,92,331,'TRUE',3483.8,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (478,96,492,'FALSE',5003.47,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (479,96,357,'TRUE',4479.65,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (480,95,246,'TRUE',8390.5,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (481,45,480,'FALSE',1728.93,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (482,82,109,'TRUE',6875.98,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (483,11,437,'FALSE',7656.72,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (484,46,78,'FALSE',1848.65,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (485,61,65,'FALSE',8975.22,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (486,24,467,'FALSE',2609.1,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (487,27,286,'TRUE',6139.37,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (488,88,33,'FALSE',5947.7,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (489,60,282,'TRUE',6715.3,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (490,99,298,'TRUE',6996.3,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (491,73,473,'FALSE',1485.27,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (492,43,479,'TRUE',1311.75,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (493,22,410,'FALSE',3340.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (494,64,355,'FALSE',9192.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (495,34,67,'TRUE',9585.7,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (496,72,204,'TRUE',1267.05,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (497,86,382,'FALSE',7298.33,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (498,79,461,'TRUE',8900.58,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (499,86,90,'TRUE',2661.06,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (500,98,295,'FALSE',2962.35,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (501,31,499,'FALSE',4309.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (502,100,420,'TRUE',5393.84,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (503,34,418,'FALSE',7057.23,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (504,11,68,'FALSE',2535.77,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (505,2,291,'FALSE',6885.38,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (506,10,137,'TRUE',2695.18,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (507,56,251,'FALSE',9333.15,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (508,100,147,'FALSE',3492.96,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (509,41,6,'TRUE',8244.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (510,53,125,'TRUE',6465.62,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (511,74,471,'TRUE',8498.93,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (512,22,163,'TRUE',8556.77,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (513,95,385,'TRUE',6124.38,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (514,83,117,'FALSE',2882.01,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (515,21,69,'TRUE',1745.04,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (516,40,194,'FALSE',9339.4,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (517,39,132,'FALSE',4520.85,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (518,30,489,'TRUE',6911.86,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (519,37,348,'TRUE',7235.44,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (520,22,336,'FALSE',8034.75,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (521,21,72,'TRUE',7581.79,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (522,38,152,'FALSE',1560.72,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (523,82,433,'FALSE',3346.95,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (524,39,37,'FALSE',2810.08,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (525,17,300,'TRUE',7247.86,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (526,2,427,'TRUE',6513.09,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (527,47,371,'FALSE',6159.27,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (528,58,394,'FALSE',8552.44,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (529,94,270,'FALSE',7425.64,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (530,60,105,'FALSE',9454.1,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (531,86,249,'TRUE',6352.31,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (532,50,329,'FALSE',7276.88,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (533,85,258,'TRUE',5445.81,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (534,72,154,'FALSE',7389.68,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (535,79,141,'FALSE',9705.31,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (536,52,16,'TRUE',6592.38,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (537,59,373,'TRUE',1381.12,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (538,10,203,'FALSE',4542.49,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (539,82,340,'TRUE',2793.71,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (540,4,218,'FALSE',8798.04,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (541,54,295,'FALSE',3091.0,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (542,79,142,'FALSE',2285.35,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (543,10,135,'TRUE',9486.32,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (544,43,488,'TRUE',5460.66,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (545,66,58,'TRUE',9845.42,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (546,19,454,'FALSE',5366.52,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (547,31,339,'TRUE',6600.89,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (548,44,278,'FALSE',5828.62,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (549,52,83,'FALSE',5581.9,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (550,81,376,'FALSE',3770.97,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (551,60,401,'TRUE',2312.76,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (552,39,322,'TRUE',6062.4,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (553,66,49,'FALSE',7918.31,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (554,59,440,'FALSE',5355.29,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (555,57,290,'FALSE',8312.45,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (556,12,202,'TRUE',6847.79,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (557,78,91,'TRUE',1117.56,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (558,75,129,'FALSE',9006.2,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (559,100,287,'TRUE',2420.61,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (560,93,297,'TRUE',7541.22,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (561,73,484,'TRUE',3036.02,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (562,31,433,'TRUE',8962.68,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (563,65,242,'FALSE',9372.55,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (564,23,98,'TRUE',4720.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (565,98,8,'FALSE',7822.21,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (566,76,84,'TRUE',8157.03,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (567,33,466,'TRUE',8959.47,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (568,22,218,'TRUE',5138.85,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (569,23,240,'FALSE',6150.7,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (570,52,64,'TRUE',8533.5,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (571,26,72,'TRUE',7692.2,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (572,77,395,'FALSE',5525.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (573,84,209,'FALSE',7197.19,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (574,84,293,'FALSE',5338.3,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (575,36,165,'FALSE',4623.5,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (576,35,245,'TRUE',9603.07,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (577,32,359,'TRUE',4273.49,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (578,19,270,'TRUE',4119.58,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (579,56,366,'TRUE',8511.51,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (580,75,218,'TRUE',4598.86,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (581,29,481,'TRUE',6477.25,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (582,53,8,'FALSE',3507.6,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (583,8,47,'TRUE',9318.24,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (584,6,454,'FALSE',8306.09,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (585,56,206,'FALSE',8536.5,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (586,23,389,'FALSE',8725.77,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (587,91,415,'TRUE',6520.84,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (588,70,413,'FALSE',7890.32,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (589,28,55,'TRUE',9073.98,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (590,92,388,'TRUE',4764.47,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (591,79,485,'TRUE',1085.88,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (592,5,382,'FALSE',7856.6,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (593,15,397,'TRUE',5073.39,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (594,87,199,'FALSE',3467.63,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (595,19,186,'FALSE',2559.81,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (596,8,374,'FALSE',8438.55,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (597,41,68,'FALSE',5459.85,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (598,22,23,'TRUE',5087.42,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (599,5,219,'FALSE',6360.41,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (600,36,473,'FALSE',3085.15,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (601,74,64,'FALSE',3652.51,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (602,84,374,'FALSE',7233.71,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (603,45,320,'TRUE',4847.99,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (604,73,114,'TRUE',3076.84,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (605,25,158,'FALSE',1008.81,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (606,2,127,'TRUE',3411.36,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (607,81,149,'TRUE',7908.37,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (608,30,467,'TRUE',1541.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (609,81,437,'FALSE',3747.74,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (610,35,327,'FALSE',5239.41,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (611,63,156,'TRUE',9707.92,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (612,64,258,'FALSE',1678.27,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (613,79,343,'TRUE',1631.31,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (614,97,62,'TRUE',2295.47,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (615,98,293,'FALSE',2274.6,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (616,34,288,'TRUE',9604.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (617,73,4,'TRUE',1628.46,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (618,7,494,'TRUE',8861.25,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (619,47,67,'FALSE',8092.88,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (620,79,171,'FALSE',5824.74,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (621,39,78,'FALSE',5411.32,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (622,24,183,'TRUE',4120.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (623,45,244,'TRUE',1808.73,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (624,67,297,'TRUE',7460.32,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (625,93,414,'TRUE',7118.11,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (626,45,156,'FALSE',5443.33,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (627,47,193,'TRUE',3673.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (628,96,153,'TRUE',3652.26,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (629,6,494,'TRUE',2154.23,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (630,30,208,'TRUE',4630.27,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (631,31,471,'FALSE',1895.22,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (632,82,215,'TRUE',2716.15,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (633,58,167,'TRUE',6287.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (634,50,284,'FALSE',3018.85,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (635,93,391,'TRUE',8223.15,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (636,86,273,'FALSE',8152.49,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (637,75,104,'TRUE',9696.96,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (638,67,7,'TRUE',3581.82,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (639,59,394,'TRUE',1807.69,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (640,28,57,'TRUE',9679.36,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (641,25,126,'FALSE',3202.0,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (642,29,222,'TRUE',2110.79,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (643,9,326,'TRUE',3489.45,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (644,89,140,'TRUE',9880.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (645,65,207,'FALSE',7670.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (646,92,114,'TRUE',4704.21,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (647,92,183,'FALSE',7367.77,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (648,22,453,'FALSE',1210.82,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (649,67,433,'TRUE',9592.88,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (650,45,487,'TRUE',7894.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (651,51,190,'TRUE',6375.24,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (652,76,87,'TRUE',4447.29,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (653,55,129,'FALSE',2400.7,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (654,15,325,'TRUE',3905.2,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (655,6,454,'TRUE',7697.07,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (656,20,249,'FALSE',7911.48,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (657,34,112,'FALSE',3238.19,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (658,77,274,'TRUE',8242.72,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (659,28,194,'FALSE',4104.03,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (660,37,223,'FALSE',4517.73,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (661,46,23,'TRUE',5335.23,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (662,97,323,'FALSE',4990.2,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (663,59,22,'FALSE',1401.32,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (664,20,139,'FALSE',9466.78,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (665,87,458,'FALSE',4685.9,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (666,30,47,'TRUE',4473.79,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (667,99,318,'FALSE',1819.23,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (668,46,429,'TRUE',9151.98,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (669,99,33,'TRUE',8451.64,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (670,28,409,'FALSE',8195.72,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (671,64,53,'TRUE',7811.76,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (672,11,22,'FALSE',8872.46,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (673,13,81,'TRUE',9181.86,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (674,3,251,'FALSE',6232.68,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (675,71,200,'TRUE',1812.05,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (676,16,59,'FALSE',6182.17,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (677,46,192,'TRUE',5696.19,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (678,87,175,'FALSE',3409.58,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (679,24,213,'FALSE',2049.04,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (680,11,185,'FALSE',4721.7,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (681,93,99,'TRUE',8346.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (682,36,167,'TRUE',6310.4,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (683,62,103,'TRUE',4812.66,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (684,28,37,'FALSE',9288.08,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (685,68,235,'TRUE',1770.8,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (686,93,470,'FALSE',8329.68,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (687,98,150,'FALSE',8186.13,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (688,38,68,'TRUE',2783.65,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (689,6,166,'TRUE',2479.11,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (690,22,219,'FALSE',8191.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (691,3,489,'TRUE',7828.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (692,74,306,'TRUE',2840.46,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (693,66,250,'TRUE',5628.41,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (694,46,406,'TRUE',9432.23,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (695,63,278,'FALSE',3325.56,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (696,16,220,'TRUE',4177.32,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (697,65,458,'FALSE',7823.66,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (698,48,134,'FALSE',5027.98,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (699,27,365,'TRUE',6263.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (700,48,125,'FALSE',7880.81,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (701,51,471,'FALSE',8097.56,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (702,48,173,'TRUE',5630.04,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (703,50,231,'TRUE',4811.97,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (704,32,470,'TRUE',2065.64,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (705,16,62,'FALSE',5072.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (706,74,306,'TRUE',4015.34,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (707,30,78,'TRUE',9259.99,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (708,19,295,'TRUE',5949.31,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (709,8,27,'TRUE',7369.39,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (710,82,376,'FALSE',8346.8,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (711,26,428,'FALSE',8519.59,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (712,91,216,'FALSE',4057.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (713,8,400,'TRUE',9478.18,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (714,38,53,'TRUE',9455.24,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (715,95,376,'TRUE',8565.08,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (716,63,354,'FALSE',4231.25,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (717,31,109,'TRUE',2905.63,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (718,51,381,'TRUE',7761.03,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (719,63,183,'FALSE',2027.44,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (720,1,228,'TRUE',8624.2,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (721,12,397,'FALSE',6309.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (722,2,95,'TRUE',6597.1,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (723,89,198,'FALSE',8287.8,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (724,13,135,'FALSE',5778.45,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (725,83,402,'TRUE',2892.04,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (726,75,203,'TRUE',5019.58,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (727,69,41,'FALSE',2931.77,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (728,24,313,'FALSE',9538.64,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (729,13,198,'FALSE',1061.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (730,12,346,'TRUE',3719.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (731,71,468,'TRUE',4926.12,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (732,63,124,'TRUE',4670.55,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (733,94,447,'TRUE',9068.25,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (734,54,136,'TRUE',1597.59,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (735,97,177,'TRUE',6786.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (736,4,69,'FALSE',2374.29,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (737,59,449,'FALSE',5075.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (738,91,34,'FALSE',2576.65,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (739,87,59,'FALSE',2157.18,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (740,57,138,'TRUE',6219.06,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (741,21,243,'FALSE',1918.19,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (742,72,106,'TRUE',2363.48,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (743,38,79,'TRUE',1202.27,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (744,6,304,'TRUE',6241.67,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (745,56,321,'TRUE',5504.14,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (746,95,307,'TRUE',5047.84,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (747,19,405,'FALSE',6477.1,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (748,98,366,'FALSE',5108.24,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (749,59,407,'FALSE',9746.6,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (750,75,126,'FALSE',4337.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (751,17,210,'TRUE',9609.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (752,45,498,'TRUE',4233.35,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (753,45,185,'FALSE',6384.39,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (754,32,261,'FALSE',6319.95,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (755,55,499,'FALSE',3273.36,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (756,4,418,'TRUE',6293.74,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (757,57,74,'TRUE',9927.97,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (758,100,386,'FALSE',8963.73,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (759,53,376,'FALSE',7280.5,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (760,92,49,'FALSE',7364.97,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (761,83,161,'TRUE',3110.81,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (762,63,248,'TRUE',8103.29,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (763,16,376,'TRUE',8468.49,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (764,67,21,'FALSE',6006.71,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (765,54,401,'FALSE',2644.66,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (766,14,494,'TRUE',6206.36,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (767,98,129,'TRUE',5134.95,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (768,26,380,'TRUE',4952.48,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (769,20,327,'FALSE',6976.04,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (770,33,279,'FALSE',4211.2,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (771,17,174,'FALSE',5124.57,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (772,79,322,'FALSE',8895.01,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (773,93,345,'TRUE',9594.17,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (774,30,391,'FALSE',4671.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (775,76,187,'FALSE',1535.72,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (776,90,41,'FALSE',6035.37,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (777,37,256,'TRUE',1265.12,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (778,55,375,'TRUE',3005.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (779,62,393,'FALSE',6930.75,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (780,100,375,'FALSE',9375.02,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (781,68,318,'TRUE',6327.37,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (782,22,190,'FALSE',5124.48,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (783,28,347,'TRUE',2761.63,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (784,43,322,'FALSE',8087.03,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (785,77,327,'TRUE',7521.86,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (786,93,397,'FALSE',6761.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (787,83,369,'FALSE',4892.86,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (788,79,178,'TRUE',4097.19,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (789,68,138,'FALSE',2654.2,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (790,53,380,'FALSE',4181.03,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (791,24,308,'TRUE',4020.84,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (792,28,180,'TRUE',2903.12,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (793,22,310,'FALSE',9285.75,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (794,98,219,'TRUE',7302.39,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (795,86,299,'TRUE',1059.57,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (796,2,301,'FALSE',7573.34,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (797,32,372,'TRUE',7958.75,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (798,16,142,'TRUE',2071.58,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (799,56,339,'FALSE',2115.68,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (800,23,23,'FALSE',6562.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (801,36,152,'TRUE',1847.65,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (802,89,316,'FALSE',5178.25,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (803,68,486,'TRUE',2862.11,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (804,29,437,'TRUE',7334.53,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (805,18,491,'TRUE',3057.15,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (806,95,401,'FALSE',6368.93,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (807,42,243,'TRUE',9749.87,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (808,57,321,'TRUE',5691.35,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (809,40,89,'FALSE',1430.13,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (810,76,85,'TRUE',9073.09,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (811,42,215,'TRUE',5648.05,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (812,91,136,'TRUE',5033.62,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (813,1,393,'TRUE',2801.93,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (814,84,338,'TRUE',1157.64,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (815,84,86,'TRUE',2799.59,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (816,92,315,'FALSE',5641.75,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (817,90,276,'FALSE',3875.11,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (818,92,426,'FALSE',1198.25,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (819,8,433,'TRUE',8558.04,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (820,13,2,'FALSE',9048.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (821,20,325,'FALSE',7562.3,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (822,64,22,'FALSE',1863.47,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (823,43,307,'TRUE',2986.41,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (824,18,374,'FALSE',2364.2,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (825,46,292,'TRUE',6791.72,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (826,65,223,'TRUE',4438.65,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (827,13,87,'TRUE',1923.34,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (828,71,220,'TRUE',3775.66,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (829,86,282,'TRUE',8113.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (830,51,273,'FALSE',3118.68,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (831,84,85,'FALSE',2356.12,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (832,68,101,'TRUE',8855.62,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (833,94,94,'TRUE',9238.83,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (834,69,245,'FALSE',9223.79,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (835,73,108,'FALSE',9155.03,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (836,25,240,'TRUE',2581.9,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (837,99,84,'TRUE',9573.69,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (838,52,450,'FALSE',7826.25,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (839,38,63,'FALSE',2542.18,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (840,76,231,'FALSE',8368.73,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (841,57,80,'TRUE',8906.46,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (842,10,414,'FALSE',2715.32,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (843,47,296,'FALSE',3517.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (844,27,115,'FALSE',7721.46,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (845,84,432,'TRUE',8967.01,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (846,77,207,'TRUE',3329.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (847,33,306,'FALSE',3239.64,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (848,46,429,'TRUE',6811.68,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (849,17,65,'TRUE',2967.41,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (850,34,366,'TRUE',7153.03,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (851,40,437,'FALSE',1737.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (852,83,320,'TRUE',9108.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (853,49,24,'FALSE',2889.04,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (854,61,320,'TRUE',5535.6,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (855,97,141,'FALSE',1197.18,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (856,98,4,'TRUE',2956.96,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (857,86,452,'FALSE',5090.86,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (858,88,43,'TRUE',9185.09,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (859,68,294,'TRUE',4736.14,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (860,70,28,'FALSE',3485.01,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (861,41,230,'TRUE',1012.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (862,20,315,'FALSE',4946.11,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (863,61,440,'FALSE',6361.76,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (864,90,69,'TRUE',7101.61,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (865,31,360,'FALSE',8883.13,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (866,97,11,'TRUE',7662.15,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (867,74,427,'FALSE',8883.13,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (868,82,61,'FALSE',6795.23,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (869,38,277,'FALSE',9647.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (870,17,396,'FALSE',7216.33,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (871,23,35,'FALSE',8381.17,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (872,80,151,'FALSE',5105.27,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (873,18,181,'TRUE',5650.28,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (874,3,402,'TRUE',9172.96,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (875,63,88,'TRUE',1856.09,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (876,96,43,'FALSE',1556.96,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (877,61,116,'FALSE',2065.4,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (878,32,446,'TRUE',3019.54,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (879,60,68,'FALSE',4522.33,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (880,98,207,'FALSE',7928.82,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (881,71,298,'TRUE',3131.36,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (882,40,194,'TRUE',8312.59,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (883,12,239,'TRUE',8424.5,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (884,66,434,'TRUE',1662.54,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (885,49,78,'FALSE',6228.9,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (886,51,341,'TRUE',2128.73,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (887,54,26,'FALSE',8498.16,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (888,11,367,'TRUE',1447.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (889,95,498,'TRUE',7491.76,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (890,34,166,'TRUE',6437.63,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (891,37,426,'TRUE',4227.71,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (892,99,364,'TRUE',2494.14,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (893,35,94,'TRUE',8175.16,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (894,48,454,'TRUE',6288.14,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (895,85,74,'TRUE',7869.55,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (896,73,464,'TRUE',2652.37,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (897,50,291,'TRUE',7432.53,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (898,17,449,'TRUE',5871.81,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (899,75,12,'TRUE',6153.81,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (900,20,184,'FALSE',8793.01,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (901,48,316,'FALSE',4321.12,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (902,93,185,'FALSE',1602.59,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (903,35,320,'FALSE',4668.22,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (904,30,247,'FALSE',6361.86,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (905,5,402,'TRUE',8814.56,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (906,49,255,'TRUE',4429.29,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (907,94,200,'FALSE',8205.48,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (908,43,150,'TRUE',2225.28,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (909,67,349,'FALSE',8026.3,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (910,90,55,'FALSE',5065.21,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (911,62,170,'FALSE',1059.56,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (912,79,499,'FALSE',7008.08,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (913,55,21,'FALSE',7974.62,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (914,74,58,'TRUE',4042.56,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (915,59,233,'TRUE',6168.38,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (916,88,475,'TRUE',8097.95,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (917,23,18,'FALSE',7439.52,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (918,16,399,'TRUE',1569.86,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (919,96,446,'TRUE',7649.13,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (920,13,350,'TRUE',8140.64,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (921,86,54,'TRUE',1016.17,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (922,51,296,'FALSE',3688.59,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (923,47,389,'FALSE',3409.53,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (924,8,85,'FALSE',1927.47,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (925,46,99,'TRUE',3528.47,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (926,87,328,'FALSE',6049.95,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (927,64,383,'FALSE',6133.4,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (928,44,427,'TRUE',3544.66,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (929,80,251,'FALSE',1277.03,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (930,1,480,'TRUE',9429.43,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (931,87,471,'FALSE',6352.45,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (932,29,58,'TRUE',6162.5,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (933,49,312,'TRUE',5693.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (934,4,150,'FALSE',6347.19,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (935,63,431,'TRUE',7214.58,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (936,95,89,'FALSE',4992.31,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (937,36,259,'TRUE',9250.89,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (938,90,27,'FALSE',4916.83,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (939,54,140,'TRUE',9000.52,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (940,55,139,'TRUE',9284.74,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (941,56,113,'TRUE',1105.3,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (942,11,269,'TRUE',5018.44,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (943,1,2,'TRUE',4562.26,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (944,71,192,'TRUE',4267.3,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (945,2,420,'TRUE',6789.66,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (946,17,396,'FALSE',6740.45,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (947,49,106,'FALSE',5688.49,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (948,1,415,'FALSE',7852.83,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (949,8,26,'TRUE',3828.41,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (950,66,74,'FALSE',6601.7,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (951,58,490,'FALSE',1160.78,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (952,78,416,'FALSE',6325.78,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (953,91,308,'FALSE',1647.05,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (954,84,321,'TRUE',1102.49,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (955,6,309,'FALSE',3429.32,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (956,74,461,'FALSE',8898.27,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (957,68,158,'TRUE',4587.16,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (958,85,346,'TRUE',7688.19,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (959,83,14,'FALSE',8260.93,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (960,94,24,'TRUE',7287.11,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (961,98,43,'FALSE',1842.56,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (962,5,450,'FALSE',6297.88,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (963,13,71,'FALSE',4872.24,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (964,9,411,'TRUE',5328.68,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (965,52,70,'FALSE',7616.99,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (966,81,56,'FALSE',6425.57,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (967,4,93,'FALSE',3490.35,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (968,1,192,'FALSE',9562.89,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (969,59,160,'FALSE',6707.68,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (970,41,486,'TRUE',6676.79,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (971,98,412,'TRUE',4422.81,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (972,31,332,'FALSE',2551.45,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (973,79,353,'FALSE',1192.49,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (974,80,45,'TRUE',2678.46,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (975,55,375,'TRUE',7230.25,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (976,73,98,'TRUE',7542.1,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (977,43,305,'FALSE',6191.79,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (978,73,375,'TRUE',2686.7,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (979,4,278,'FALSE',2246.92,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (980,100,113,'TRUE',4405.5,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (981,63,396,'TRUE',7349.83,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (982,29,275,'TRUE',9202.21,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (983,62,252,'FALSE',3153.36,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (984,41,155,'FALSE',6741.07,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (985,42,137,'FALSE',2508.25,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (986,44,127,'TRUE',7079.4,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (987,66,279,'TRUE',1300.01,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (988,51,322,'FALSE',2170.59,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (989,14,416,'FALSE',2028.79,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (990,14,135,'FALSE',6436.23,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (991,7,494,'FALSE',3247.66,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (992,67,493,'FALSE',9856.59,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (993,48,243,'FALSE',6758.67,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (994,74,180,'TRUE',7040.47,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (995,38,183,'TRUE',6217.13,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (996,7,9,'FALSE',6454.1,'Triple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (997,31,68,'TRUE',5273.94,'Cuadruple');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (998,23,196,'FALSE',8741.43,'Doble');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (999,100,317,'FALSE',7994.42,'Individual');
INSERT INTO habitacion(id_habitacion,id_hotel,numero,esta_disponible,costo,tipo) VALUES (1000,36,260,'TRUE',4746.94,'Triple');

-- Servicio 

INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (1,'true',7194.92,'Servicio de habitaciones');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (2,'false',8139.68,'Desayuno buffet');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (3,'true',720.31,'Alquiler de bicicletas');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (4,'false',6494.22,'Spa y centro de bienestar');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (5,'false',5794.62,'Clases de yoga');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (6,'true',8495.54,'Masajes');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (7,'false',9226.33,'Excursiones guiadas');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (8,'false',7552.7,'Servicio de lavandería');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (9,'true',7375.76,'Servicio de planchado');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (10,'true',5429.24,'Alquiler de coches');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (11,'true',1758.64,'Cuidado de niños');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (12,'true',1343.47,'Traslado al aeropuerto');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (13,'true',6124.17,'Reservación de restaurantes');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (14,'false',2027.76,'Servicio de bar en la piscina');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (15,'false',6506.24,'Club nocturno / DJ');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (16,'true',3446.6,'Catas de vino');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (17,'true',9943.83,'Degustación de cócteles');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (18,'true',9496.13,'Cenas temáticas');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (19,'true',8760.72,'Actividades de deportes acuáticos');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (20,'false',3116.47,'Alquiler de equipos de deportes');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (21,'true',1076.46,'Clases de cocina');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (22,'false',6478.67,'Servicio de banquetes');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (23,'false',6707.84,'Alquiler de salas de conferencias');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (24,'true',2911.74,'Servicio de bodas');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (25,'false',7057.39,'Alquiler de equipos audiovisuales');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (26,'false',4583.72,'Servicio de traducción');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (27,'false',9227.82,'Alquiler de juegos de mesa');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (28,'false',2643.97,'Alquiler de películas');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (29,'false',2818.63,'Servicio de biblioteca');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (30,'true',2743.72,'Visitas guiadas por la ciudad');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (31,'true',6955.04,'Excursiones en helicóptero');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (32,'true',6835.8,'Clases de surf');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (33,'true',4162.39,'Alquiler de tablas de surf');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (34,'false',2127.23,'Sesiones de fotografía profesional');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (35,'false',2418.22,'Acceso a la playa privada');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (36,'true',8940.71,'Excursiones a lugares cercanos');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (37,'true',6437.09,'Senderismo guiado');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (38,'false',6059.52,'Observación de aves');
INSERT INTO servicio(id_servicio,esta_activo,costo,tipo) VALUES (39,'false',9319.02,'Paseos en bicicleta por la ciudad');
