DROP DATABASE IF EXISTS edtickets;

CREATE DATABASE IF NOT EXISTS edtickets;

USE edtickets;

CREATE TABLE actividades(
  actividad_id CHAR(2) PRIMARY KEY,
  bloque ENUM('Bloque 1', 'Bloque 2', 'Bloque 3') NOT NULL,
  disciplina ENUM('KICK BOXING', 'YOGA', 'PILATES', 'ZUMBA') NOT NULL,
  horario VARCHAR(30) NOT NULL,
  cupo INTEGER NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO actividades (actividad_id, bloque, disciplina, horario, cupo) VALUES
  ('1K', 'Bloque 1', 'KICK BOXING', '9:00 a 12:00', 10),
  ('1Y', 'Bloque 1', 'YOGA', '9:00 a 12:00', 20),
  ('1P', 'Bloque 1', 'PILATES', '9:00 a 12:00', 10),
  ('1Z', 'Bloque 1', 'ZUMBA', '9:00 a 12:00', 10),
  ('2K', 'Bloque 2', 'KICK BOXING', '14:00 a 17:00', 10),
  ('2Y', 'Bloque 2', 'YOGA', '14:00 a 17:00', 20),
  ('2P', 'Bloque 2', 'PILATES', '14:00 a 17:00', 10),
  ('2Z', 'Bloque 2', 'ZUMBA', '14:00 a 17:00', 10),
  ('3K', 'Bloque 3', 'KICK BOXING', '18:00 a 21:00', 10),
  ('3Y', 'Bloque 3', 'YOGA', '18:00 a 21:00', 20),
  ('3P', 'Bloque 3', 'PILATES', '18:00 a 21:00', 10),
  ('3Z', 'Bloque 3', 'ZUMBA', '18:00 a 21:00', 10);

CREATE TABLE participantes (
  email VARCHAR(50) PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  nacimiento DATE NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE registros (
  registro_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(50) UNIQUE NOT NULL,
  actividad CHAR(2) NOT NULL,
  fecha DATE NOT NULL,
  FOREIGN KEY (email) REFERENCES participantes(email)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (actividad) REFERENCES actividades(actividad_id)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



DROP PROCEDURE IF EXISTS registrar_participante;

DELIMITER $$

CREATE PROCEDURE registrar_participante(
  IN _email VARCHAR(50),
  IN _nombre VARCHAR(50),
  IN _apellidos VARCHAR(50),
  IN _nacimiento DATE,
  IN _actividad CHAR(2)
)

BEGIN
  DECLARE existe_registro INT DEFAULT 0;
  DECLARE limite INT DEFAULT 0;
  DECLARE registrados INT DEFAULT 0;
  DECLARE respuesta VARCHAR(255) DEFAULT 'ok';

  START TRANSACTION;

    SELECT COUNT(*) INTO existe_registro FROM registros
      WHERE email = _email;

    IF existe_registro = 1 THEN

      SELECT 'Tu correo electrónico ya ha sido registrado previamente, sólo puedes registrarte una vez.' AS respuesta;

    ELSE

      SELECT cupo INTO limite FROM actividades
        WHERE actividad_id = _actividad;

      SELECT COUNT(*) INTO registrados FROM registros
        WHERE actividad = _actividad;

      IF registrados < limite THEN

        INSERT INTO participantes (email, nombre, apellidos, nacimiento)
          VALUES (_email, _nombre, _apellidos, _nacimiento);

        INSERT INTO registros (email, actividad, fecha)
          VALUES (_email, _actividad, NOW());

        SELECT respuesta;

      ELSE

        SELECT 'El bloque y actividad seleccionados, ya no tiene lugares disponibles.' AS respuesta;

      END IF;

    END IF;

  COMMIT;

END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS eliminar_participante;

DELIMITER $$

CREATE PROCEDURE eliminar_participante(
  IN _email VARCHAR(50)
)

BEGIN

  DECLARE respuesta VARCHAR(255) DEFAULT 'ok';

  START TRANSACTION;

    DELETE FROM participantes
      WHERE email = _email;

    DELETE FROM registros
      WHERE email = _email;

    SELECT respuesta;

  COMMIT;

END $$

DELIMITER ;


/*
CALL registrar_participante('test1@gmail.com', 'Prueba 1', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test2@gmail.com', 'Prueba 2', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test3@gmail.com', 'Prueba 3', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test4@gmail.com', 'Prueba 4', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test5@gmail.com', 'Prueba 5', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test6@gmail.com', 'Prueba 6', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test7@gmail.com', 'Prueba 7', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test8@gmail.com', 'Prueba 8', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test9@gmail.com', 'Prueba 9', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test10@gmail.com', 'Prueba 10', 'Test', '1984-05-23', '1K');
CALL registrar_participante('test11@gmail.com', 'Prueba 11', 'Test', '1984-05-23', '1Y');
CALL eliminar_participante('test11@gmail.com');
*/
