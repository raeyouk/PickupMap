<h2> FindMyRide </h2>

This website uses a dataset containing the locations, times, and other information on where rideshare users were picked up around New York City. The rideshare companies include Uber, Lyft, Diplo, Carmel, and Dial7. With input from the user, the map is populated with these pickup locations, serving as a coverage map of rideshare companies around the user's area. This can help users make informed decisions on which company would be the best option to use based on their current location.

If you really want to give it a try, do the following (slightly convoluted) steps:

Windows:
1. Install WAMP and run the server
2. Clone this repo into the server root directory (C:\wamp64\www by default)
3. Open MySQL and connect to WAMP
4. Open pickupmap.sql
5. Make sure the LOAD DATA statements point to the files in the sampledata folder
6. Run the file
7. Open a browser and go to localhost/PickupMap
8. Mess around

Mac:
1. Install MAMP and run the server
2. Clone this repo into the server root directory (/Applications/MAMP/htdocs by default I think)
Steps 3-6 are the same as above
7. Open a browser and go to localhost:8888/PickupMap
8. Do stuff

(It'll take a while to load the markers when you click the button)

Thanks to Samantha Axline and Sreeja Kondeti for helping me with the backend.
