<html>

<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1.0">
<link href="style.css" type="text/css" rel="stylesheet">

<body>
  <center>
    <h2 style="font-family:helvetica; font-size:60px;">Pickup<span style="color:#2FF2DC;">Map</span></h2>

    <br />

    <form autocomplete="off" action="javascript:find();">
      <div class="autocomplete" style="width:300px;">
        <input id='myInput' type="text" name="myCollege" placeholder="Search College">
      </div>
      <input type="submit" value="Search">
    </form>
      <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCNIYNUYOcAiAFpnEvtUoCzMm53035jV3I&"></script>

    <script>
      function autocomplete(inp, arr) {
        var currentFocus;
        inp.addEventListener("input", function(e) {
          var a, b, i, val = this.value;
          closeAllLists();
          if (!val) { return false;}
          currentFocus = -1;
          a = document.createElement("DIV");
          a.setAttribute("id", this.id + "autocomplete-list");
          a.setAttribute("class", "autocomplete-items");
          this.parentNode.appendChild(a);
          for (i = 0; i < arr.length; i++) {
            if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
              b = document.createElement("DIV");
              b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
              b.innerHTML += arr[i].substr(val.length);
              b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
              b.addEventListener("click", function(e) {
                inp.value = this.getElementsByTagName("input")[0].value;
                closeAllLists();
              });
              a.appendChild(b);
            }
          }
        });
        inp.addEventListener("keydown", function(e) {
          var x = document.getElementById(this.id + "autocomplete-list");
          if (x) x = x.getElementsByTagName("div");
          if (e.keyCode == 40) {
            currentFocus++;
            addActive(x);
      } else if (e.keyCode == 38) { //up
        currentFocus--;
        addActive(x);
      } else if (e.keyCode == 13) {
        e.preventDefault();
        if (currentFocus > -1) {
          if (x) x[currentFocus].click();
        }
      }
    });
        function addActive(x) {
          if (!x) return false;
          removeActive(x);
          if (currentFocus >= x.length) currentFocus = 0;
          if (currentFocus < 0) currentFocus = (x.length - 1);
          x[currentFocus].classList.add("autocomplete-active");
        }
        function removeActive(x) {
          for (var i = 0; i < x.length; i++) {
            x[i].classList.remove("autocomplete-active");
          }
        }
        function closeAllLists(elmnt) {
          var x = document.getElementsByClassName("autocomplete-items");
          for (var i = 0; i < x.length; i++) {
            if (elmnt != x[i] && elmnt != inp) {
              x[i].parentNode.removeChild(x[i]);
            }
          }
        }
        document.addEventListener("click", function (e) {
          closeAllLists(e.target);
        });
      }

      var colleges = ["Vanderbilt University", "University of Tennessee - Knoxville", "University of Alabama", "Georgia Institute of Technology", "University of South Carolina", "Massachusetts Institute of Technology", "Stanford University", "Harvard University", "University of California - Berkeley", "Rutgers University", "University of Michigan", "Rutgers University", "University of Michigan", "University of Kentucky", "Tulane University", "Belmont University", "University of Florida", "American University", "University of Arizona", "University of Washington", "Yale University", "Carnegie Mellon University"];

      autocomplete(document.getElementById("myInput"), colleges);

      var coll1 = {name:"Vanderbilt University", x:"36.1447034", y:"-86.80265509999998"}
      var coll2 = {name:"University of Tennessee - Knoxville", x:"35.9544013", y:"-83.92945639999999"}
      var collegeLoc =[coll1, coll2];

      function find() {
        var i;
        for (i = 0; i < collegeLoc.length; i++) {
          if (document.getElementById('myInput').value === collegeLoc[i].name) {
            search(collegeLoc[i].x, collegeLoc[i].y);
          }
        }
      }

    </script>

    <p>or</p>

    <input type="submit" onclick="getLocation()" value="Use My Location">

    <p id="demo"></p>

    <script>
      var x = document.getElementById("demo");

      function getLocation() {
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(showPosition);
        } else { 
          x.innerHTML = "Geolocation is not supported by this browser.";
        }
      }

      function showPosition(position) {
        search(position.coords.latitude,position.coords.longitude);
      }

    </script>

    <div id="map" style="width:1000px;height:600px;background:white;"></div>

    <script>

      var ev1 = {name:"Lit party", x:"36.1447034", y:"-86.80265509999998"}
      var ev2 = {name:"Barbeque", x:"35.9544013", y:"-83.92945639999999"}
      var ev3 = {name:"Saxophone Club", x:"35.95150586367683", y:"-83.93164227523886"}
      var ev4 = {name:"Air hockey", x:"35.95228752286814", y:"-83.937792044854"}
      var ev5 = {name:"Taco Night", x:"35.95484088899484", y:"-83.93106721119767"}
      var ev6 = {name:"Hackathon", x:"35.95626517981751", y:"-83.92511485373763"}
      var ev7 = {name:"Swim Meet", x:"36.143854337489664", y:"-86.80487811561733"}
      var ev8 = {name:"Yoga", x:"36.14220816970762", y:"-86.80383956507256"}
      var ev9 = {name:"Family Dinner", x:"36.14579503829523", y:"-86.80181396161032"}

      var event = [ev1, ev2, ev3, ev4, ev5, ev6, ev7, ev8, ev9];

      function myMap() {

      }

      function search(x, y) {

        var latlng = new google.maps.LatLng(x, y);

        var mapOptions = {
          center: latlng,
          zoom: 15,
          mapTypeId: google.maps.MapTypeId.ROADMAP 
        }
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);


        var marker = new google.maps.Marker({
          position: latlng,
          map: map,
          icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
          title: 'You are here'
        });


        var i;
        for (i = 0; i < event.length; i++) {

         latlng = new google.maps.LatLng(event[i].x, event[i].y);

         marker = new google.maps.Marker({
          position: latlng,
          map: map,
          icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
          title: event[i].name
        });
       }
     }

   </script>



   <script async defer src="../VOLhacks2018API"></script>


 </center>
 <p align="right"> Created by Sithara Samudrala, Sai Thatigotla, and Young-Rae Kim at VolHacks 2018 </p>
</body>

<body>

<h1> Test </h1>

<?php

require_once("conn.php");

$query = "SELECT * FROM Products";
    
  $prepared_stmt = $dbo->prepare($query);
  $prepared_stmt->execute();
  print json_encode($prepared_stmt->fetchAll(PDO::FETCH_ASSOC));

?>

echo "<table>"; // start a table tag in the HTML

while($row = mysql_fetch_array($result)){   //Creates a loop to loop through results
echo "<tr><td>" . $row['name'] . "</td><td>" . $row['age'] . "</td></tr>";  //$row['index'] the index here is a field name
}

echo "</table>"; //Close the table in HTML

mysql_close(); //Make sure to close out the database connection

</body>
</html>