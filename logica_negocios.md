# Lógica de Negocios ENTRENA TU GLAMOUR

## Teoría:

* [Conceptos básicos de bases de datos](https://ed.team/blog/conceptos-basicos-de-bases-de-datos) 🤓.
* [Modelo Entidad-Relación](https://ed.team/blog/modelo-entidad-relacion) 🤓.
* [Normalización de bases de datos](https://ed.team/blog/normalizacion-de-bases-de-datos) 🤓.

## Glosario:

* ***PK*** - Primary Key
* ***FK*** - Foreign Key
* ***UQ*** - Unique
* ***CAT*** - Catalog
* ***1 - 1*** - One to One
* ***1 - M*** - One to Many
* ***M - M*** - Many to Many

## Reglas de Negocio:

* Registrar participantes para el evento Entrena tu Glamour.
* El evento tendrá 4 disciplinas:
  * KickBoxing
  * Pilates
  * Yoga
  * Zumba
* Cada disciplina tendrá 3 bloques de horarios:
  * Bloque 1 de 9:00 a 12:00
  * Bloque 2 de 14:00 a 17:00
  * Bloque 3 de 18:00 a 21:00
* Cada actividad tendrá un máximo de 10 participantes, excepto los de Yoga que tendrán 20.
* Cada participante sólo se podrá registrar a una sóla actividad.

## Entidades

### Actividades (***CAT***)

* actividad_id (***PK***)
* bloque
* disciplina
* horario
* cupo

### Participantes

* email (***PK***) y (***UQ***)
* nombre
* apellidos
* nacimiento

### Registros

* registro_id (***PK***)
* email (***FK***)
* actividad (***FK***)
* fecha


## Relaciones del Modelo

1. Los **Participantes** crean un **Registro** (*1 - 1*).
1. Las **Actividades** se asignan a un  **Registro** (*1 - 1*).

## Información de catálogo de actividades

* ('1K', 'Bloque 1', 'KICK BOXING', '9:00 a 12:00', 10)
* ('1Y', 'Bloque 1', 'YOGA', '9:00 a 12:00', 20)
* ('1P', 'Bloque 1', 'PILATES', '9:00 a 12:00', 10)
* ('1Z', 'Bloque 1', 'ZUMBA', '9:00 a 12:00', 10)
* ('2K', 'Bloque 2', 'KICK BOXING', '14:00 a 17:00', 10)
* ('2Y', 'Bloque 2', 'YOGA', '14:00 a 17:00', 20)
* ('2P', 'Bloque 2', 'PILATES', '14:00 a 17:00', 10)
* ('2Z', 'Bloque 2', 'ZUMBA', '14:00 a 17:00', 10)
* ('3K', 'Bloque 3', 'KICK BOXING', '18:00 a 21:00', 10)
* ('3Y', 'Bloque 3', 'YOGA', '18:00 a 21:00', 20)
* ('3P', 'Bloque 3', 'PILATES', '18:00 a 21:00', 10)
* ('3Z', 'Bloque 3', 'ZUMBA', '18:00 a 21:00', 10)

## Operaciones CRUD:

* Registrar Participantes:
  * Validar cupo de la actividad.
  * Insertar datos a las entidades Participantes y Registros.
* Listar Registro.
* Eliminar Participante:
  * Eliminar datos a las entidades Participantes y Registros.