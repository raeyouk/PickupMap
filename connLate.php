<?php
require("dbinfo.php");

function parseToXML($htmlStr)
{
$xmlStr=str_replace('<','&lt;',$htmlStr);
$xmlStr=str_replace('>','&gt;',$xmlStr);
$xmlStr=str_replace('"','&quot;',$xmlStr);
$xmlStr=str_replace("'",'&#39;',$xmlStr);
$xmlStr=str_replace("&",'&amp;',$xmlStr);
return $xmlStr;
}

// Opens a connection to a MySQL server
$connection=mysqli_connect ('localhost', $username, $password);
if (!$connection) {
  die('Not connected : ' . $connection->error());
}

// Set the active MySQL database
$db_selected = $connection->select_db($database);
if (!$db_selected) {
  die ('Can\'t use db : ' . $connection->error());
}

// Select all the rows in the markers table
$query = "SELECT id, dateAndTime, latitude, longitude, company
FROM lateTripsLyft join dataFromLyft using(id, dateAndTime, company)"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

header("Content-type: text/xml");

// Start XML file, echo parent node
echo "<?xml version='1.0' ?>";
echo '<markers>';
$ind=0;
// Iterate through the rows, printing XML nodes for each
while ($row = @mysqli_fetch_assoc($result)){
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

$query = "SELECT * FROM lateTripsUber join dataFromUberJul using(id, dateAndTime, company)"; // database here
$result = $connection->query($query);
if (!$result) {
  die('Invalid query: ' . $connection());
}

while ($row = @mysqli_fetch_assoc($result)){
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


// End XML file
echo '</markers>';
