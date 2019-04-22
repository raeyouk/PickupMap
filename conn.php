<?php
require("dbinfo.php");

function parseToXML($htmlStr)
{
  $xmlStr = str_replace('<', '&lt;', $htmlStr);
  $xmlStr = str_replace('>', '&gt;', $xmlStr);
  $xmlStr = str_replace('"', '&quot;', $xmlStr);
  $xmlStr = str_replace("'", '&#39;', $xmlStr);
  $xmlStr = str_replace("&", '&amp;', $xmlStr);
  return $xmlStr;
}

// Opens connection to a MySQL server
$connection = mysqli_connect('localhost', $username, $password);
if (!$connection) {
  die('Not connected : ' . $connection->error());
}

// Set active MySQL database
$db_selected = $connection->select_db($database);
if (!$db_selected) {
  die('Can\'t use db : ' . $connection->error());
}

header("Content-type: text/xml");

// Start XML file, echo parent node
echo "<?xml version='1.0' ?>";
echo '<markers>';
$ind = 0;

// Select rows in Uber table
$query = "SELECT * FROM dataFromUberJul WHERE 1"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

// Iterate through the rows, printing XML nodes for each
while ($row = @mysqli_fetch_assoc($result)) {
  // Add to XML document node
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  //   echo 'name="' . parseToXML($row['name']) . '" ';
  //   echo 'address="' . parseToXML($row['address']) . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $row['latitude'] . '" ';
  echo 'lng="' . $row['longitude'] . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

// Use Lyft table

$query = "SELECT * FROM dataFromLyft WHERE 1"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

while ($row = @mysqli_fetch_assoc($result)) {
  // Add to XML document node
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $row['latitude'] . '" ';
  echo 'lng="' . $row['longitude'] . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

// Use Diplo table

$query = "SELECT * FROM dataFromDiplo WHERE 1"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

while ($row = @mysqli_fetch_assoc($result)) {

  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }

  // Add to XML document node
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $latitude . '" ';
  echo 'lng="' . $longitude . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

// Use Carmel table
$query = "SELECT * FROM dataFromCarmel WHERE 1"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

while ($row = @mysqli_fetch_assoc($result)) {
  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }
  // Add to XML document node
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $latitude . '" ';
  echo 'lng="' . $longitude . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

// Use Dial7 table
$query = "SELECT * FROM dataFromDial7 WHERE 1"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

while ($row = @mysqli_fetch_assoc($result)) {
  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }
  // Add to XML document node
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $latitude . '" ';
  echo 'lng="' . $longitude . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

// End XML file
echo '</markers>';
