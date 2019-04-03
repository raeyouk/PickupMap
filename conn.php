<?php

$dbhost = 'localhost';
$dbuname = 'root';
$dbpass = 'QAZwsxEDC`1';
$dbname = 'create_my_guitar_shop.sql';


$dbo = new PDO('mysql:host=localhost;port=8889;dbname=$dbname, $dbuname, $dbpass);

//$dbo = new PDO('mysql:host=localhost' . $dbhost . ';port=8889;dbname=create_my_guitar_shop.sql' . $dbname, $dbuname, $dbpass);

?>
