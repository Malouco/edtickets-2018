<?php
define('ENV', 'dev');

define('DB', array(
  'dsn' => (ENV === 'dev') ? 'mysql:host=localhost;dbname=edtickets' : '',
  'user' => (ENV === 'dev') ? 'root' : '',
  'pass' => (ENV === 'dev') ? 'qwerty' : ''
));
