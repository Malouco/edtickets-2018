<?php
require_once './app/config.php';
require_once './app/db.php';
require_once './app/send_mail.php';


function obtener_cupo ($actividad_id) {
  $sql = "SELECT a.actividad_id, a.bloque, a.disciplina, a.horario, a.cupo,
    ( SELECT COUNT(*) FROM registros AS r WHERE r.actividad = a.actividad_id ) AS registrados
    FROM actividades AS a WHERE a.actividad_id = ?";

  $data = array( $actividad_id );

  $result = db_query($sql, $data, true, true);

  return $result;
}

/* echo '<pre>';
var_dump( obtener_cupo('1Y') );
echo '</pre>'; */


function obtener_horarios ($disciplina) {
  $sql = "SELECT * FROM actividades WHERE disciplina = ? ORDER BY actividad_id";
  $data = array($disciplina);

  $result = db_query($sql, $data, true);

  if ( count($result) === 0 ) {
    echo "No existen horarios para $disciplina";
  } else {
    echo '<pre>';
      var_dump($result);
    echo '</pre>';
  }
}

/* obtener_horarios('PILATES'); */

function existe_registro ($email) {
  $sql = "SELECT p.email, p.nombre, p.apellidos, p.nacimiento,
    a.bloque, a.disciplina, a.horario, r.fecha
    FROM registros AS r
    INNER JOIN actividades AS a
      ON a.actividad_id = r.actividad
    INNER JOIN participantes AS p
      ON p.email = r.email
    WHERE r.email = ?";

  $data = array($email);
  $result = db_query($sql, $data, true, true);
  return $result;
}

/* echo '<pre>';
var_dump( existe_registro('test1@gmail.com') );
echo '</pre>'; */

function crear_registro($nombre, $apellidos, $email, $nacimiento, $actividad) {
  $registrado = existe_registro($email);

  if (!$registrado) {
    $cupo = obtener_cupo($actividad);

    if ( $cupo['registrados'] === $cupo['cupo'] ) {
      $res = array(
        'err' => true,
        'msg' => 'El horario y actividad que elegiste ya no está disponible, elige otra.'
      );
    } else {
      $sql = 'CALL registrar_participante(?, ?, ?, ?, ?)';
      $data = array(
        $email,
        $nombre,
        $apellidos,
        $nacimiento,
        $actividad
      );

      $result = db_query($sql, $data);

      if ($result) {
        $res = array(
          'err' => false,
          'msg' => 'Tu registro se efectuó con éxito. En breve recibirás un email con la agenda del bloque que elegiste.'
        );

        $registro = existe_registro($email);
        enviar_email($registro);
      } else {
        $res = array(
          'err' => true,
          'msg' => 'Ocurrió un error con el registro. Intenta nuevamente.'
        );
      }
    }
  } else {
    $res = array(
      'err' => true,
      'msg' => 'Tu correo electrónico ya ha sido registrado previamente, sólo puedes registrarte una vez.'
    );
  }

  header( 'Content-type: application/json' );
  echo json_encode($res);
}

/* echo '<pre>';
var_dump( crear_registro('Jona', 'MirCha', 'hola@jonmircha.com', '1984-05-23', '2P') );
echo '</pre>'; */

function obtener_registros () {
  $sql = "SELECT p.email, p.nombre, p.apellidos, p.nacimiento,
    a.bloque, a.disciplina, a.horario, r.fecha
    FROM registros AS r
    INNER JOIN actividades AS a
      ON a.actividad_id = r.actividad
    INNER JOIN participantes AS p
      ON p.email = r.email
    ORDER BY r.fecha, a.bloque, a.disciplina, a.horario";

  $result = db_query($sql, null, true);

  if (count($result) === 0) {
     return 'No existen registros';
  } else {
    return $result;
  }
}

/* echo '<pre>';
var_dump( obtener_registros() );
echo '</pre>'; */

function eliminar_registro($email) {
  $sql = "CALL eliminar_participante(?)";
  $data = array($email);
  $result = db_query($sql, $data);
  return $result;
}

/* echo '<pre>';
var_dump( eliminar_registro('hola@jonmircha.com') );
echo '</pre>'; */
