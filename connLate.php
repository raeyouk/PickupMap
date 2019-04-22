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

//Use Uber table
$result = mysqli_query($connection, "CALL lateUberJul") or die("Query fail: " . mysqli_error($connection));

while ($row = @mysqli_fetch_assoc($result)) {
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $row['latitude'] . '" ';
  echo 'lng="' . $row['longitude'] . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

mysqli_free_result($result);
mysqli_next_result($connection);

// Use Lyft table
$result = mysqli_query($connection, "CALL lateLyft") or die("Query fail: " . mysqli_error($connection));
// Iterate through the rows, printing XML nodes for each
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

mysqli_free_result($result);
mysqli_next_result($connection);

  // Use Diplo table
$result = mysqli_query($connection, "CALL lateDiplo") or die("Query fail: " . mysqli_error($connection));

while ($row = @mysqli_fetch_assoc($result)) {

  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $latitude . '" ';
  echo 'lng="' . $longitude . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

mysqli_free_result($result);
mysqli_next_result($connection);

// Use Carmel table
$result = mysqli_query($connection, "CALL lateCarmel") or die("Query fail: " . mysqli_error($connection));

while ($row = @mysqli_fetch_assoc($result)) {
  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }
  echo '<marker ';
  echo 'id="' . $row['id'] . '" ';
  echo 'timeanddate="' . $row['dateAndTime'] . '" ';
  echo 'lat="' . $latitude . '" ';
  echo 'lng="' . $longitude . '" ';
  echo 'company="' . $row['company'] . '" ';
  echo '/>';
  $ind = $ind + 1;
}

mysqli_free_result($result);
mysqli_next_result($connection);

// Use Dial7 table
$result = mysqli_query($connection, "CALL lateDial7") or die("Query fail: " . mysqli_error($connection));

while ($row = @mysqli_fetch_assoc($result)) {
  $prepAddr = str_replace(' ', '+', $row['address']);
  $geocode = file_get_contents('https://maps.googleapis.com/maps/api/geocode/json?address=' . $prepAddr . '&key=AIzaSyBj-r4sHkXI-faO_soZFTfSsBn0QPNpgmQ');

  $geocode = json_decode($geocode, true);
  if (isset($geocode['status']) && ($geocode['status'] == 'OK')) {
    $latitude = $geocode['results'][0]['geometry']['location']['lat']; // Latitude
    $longitude = $geocode['results'][0]['geometry']['location']['lng']; // Longitude
  }
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
