/*final project*/

DROP DATABASE IF EXISTS drivingService;
CREATE DATABASE drivingService;
USE drivingService;

DROP TABLE IF EXISTS dataFromFile;
CREATE TABLE dataFromFile
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	latitude		DECIMAL(12,8),
	longitude 		DECIMAL(12,8),
    company			VARCHAR(255)	DEFAULT "Uber"
);

LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
INTO TABLE dataFromFile
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

delete from dataFromFile
where id > 1000;

SELECT * FROM dataFromFile;