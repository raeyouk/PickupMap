/*final project*/

DROP DATABASE IF EXISTS drivingService;
CREATE DATABASE drivingService;
USE drivingService;

DROP TABLE IF EXISTS dataFromUberJul;
CREATE TABLE dataFromUberJul
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	latitude		DECIMAL(12,8),
	longitude 		DECIMAL(12,8),
    company			VARCHAR(255)	DEFAULT "Uber"
);

/*insert uber data into database*/
#LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
INTO TABLE dataFromUberJul
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

delete from dataFromUberJul
where id > 1000;

SELECT * FROM dataFromUberJul;

DROP TABLE IF EXISTS dataFromLyft;
CREATE TABLE dataFromLyft
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	latitude		DECIMAL(12,8),
	longitude 		DECIMAL(12,8),
    company			VARCHAR(255)	DEFAULT "Lyft"
);

/*insert lyft data into database*/
LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Lyft_B02510.csv'
#LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Lyft_B02510.csv'
#LOAD DATA INFILE '/⁨Users⁩/⁨samanthaaxline⁩/⁨Downloads⁩'
INTO TABLE dataFromLyft
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

delete from dataFromLyft
where id > 1000;

SELECT * FROM dataFromLyft;

DROP TABLE IF EXISTS lateTripsLyft;
CREATE TABLE lateTripsLyft AS
SELECT id, dateAndTime, company
FROM dataFromLyft 
WHERE hour(dateAndTime)  > 10;
ALTER TABLE lateTripsLyft ADD PRIMARY KEY(id);

SELECT id, dateAndTime, latitude, longitude, company FROM lateTripsLyft join dataFromLyft using(id, dateAndTime, company);

DROP PROCEDURE IF EXISTS showData;
DELIMITER //
CREATE PROCEDURE showData()
BEGIN
SELECT * 
FROM lateTripsLyft;
END //
DELIMITER ;
CALL showData;


DROP VIEW IF EXISTS lateTripsUber;
CREATE VIEW lateTripsUber
AS SELECT id, dateAndTime, company
FROM dataFromUberJul
WHERE hour(dateAndTime)  > 10;

SELECT * FROM lateTripsUber join dataFromUberJul using(id, dateAndTime, company);