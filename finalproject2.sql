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

DROP TABLE IF EXISTS dataFromLyft;
CREATE TABLE dataFromLyft
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	latitude		DECIMAL(12,8),
	longitude 		DECIMAL(12,8),
    company			VARCHAR(255)	DEFAULT "Lyft"
);

drop trigger if exists yorkCheckUber;
delimiter //
CREATE TRIGGER yorkCheckUber BEFORE INSERT ON dataFromUberJul
       FOR EACH ROW
       BEGIN
           IF NEW.longitude < -74.05 -- remove Staten Island
           OR NEW.longitude < -74.019 AND NEW.latitude > 40.700 -- Jersey City
           OR NEW.latitude > 1.867*NEW.longitude + 178.923 AND NEW.latitude > 40.645 -- Jersey edge
           OR NEW.longitude > -73.731 -- right
           OR NEW.latitude < 40.567 -- bottom
           OR NEW.latitude > 40.92 THEN -- top
               SET NEW.dateAndTime = null;
           END IF;
       END;//
delimiter ;

drop trigger if exists yorkCheckLyft;

delimiter //
CREATE TRIGGER yorkCheckLyft BEFORE INSERT ON dataFromLyft
       FOR EACH ROW
       BEGIN
       IF NEW.longitude < -74.05 THEN -- remove Staten Island
               SET NEW.dateAndTime = null;
           END IF;
       END;//
delimiter ;

/*insert uber data into database*/
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
INTO TABLE dataFromUberJul
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

SET SQL_SAFE_UPDATES = 0;

delete from dataFromUberJul
where id > 1000 or dateAndTime is null;

SELECT * FROM dataFromUberJul;

/*insert lyft data into database*/
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Lyft_B02510.csv'
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Lyft_B02510.csv'
#LOAD DATA INFILE '/⁨Users⁩/⁨samanthaaxline⁩/⁨Downloads⁩'
INTO TABLE dataFromLyft
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

delete from dataFromLyft
where id > 1000 or dateAndTime is null;

SELECT * FROM dataFromLyft;

DROP TABLE IF EXISTS lateTripsLyft;
CREATE TABLE lateTripsLyft AS
SELECT id, dateAndTime, company
FROM dataFromLyft 
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;
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
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsUber join dataFromUberJul using(id, dateAndTime, company);

DROP TABLE IF EXISTS dataFromDiplo;
CREATE TABLE dataFromDiplo
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	address			VARCHAR(255),
    company			VARCHAR(255)	DEFAULT "Diplo"
);

LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Diplo_B01196.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Diplo_B01196.csv' 
INTO TABLE dataFromDiplo
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n'
#FIELDS TERMINATED BY ','
#ENCLOSED BY '"'
#LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, @time_str, address)
SET dateAndTime = STR_TO_DATE(CONCAT(@date_str, ' ', @time_str), '%c/%e/%Y %r');

delete from dataFromDiplo
where id > 70 or dateAndTime is null;

select * from dataFromDiplo;

DROP TABLE IF EXISTS dataFromCarmel;
CREATE TABLE dataFromCarmel
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	address			VARCHAR(255),
    company			VARCHAR(255)	DEFAULT "Carmel"
);

LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Carmel_B00256.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Diplo_B01196.csv' 
INTO TABLE dataFromCarmel
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n'
#FIELDS TERMINATED BY ','
#ENCLOSED BY '"'
#LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, @time_str, address, @dummy)
SET dateAndTime = STR_TO_DATE(CONCAT(@date_str, ' ', cast(@time_str as time)), '%c/%e/%Y %T');

delete from dataFromCarmel
where id > 70 or dateAndTime is null;

select * from dataFromCarmel;

#SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y') + CAST(@time_str AS time) 
#STR_TO_DATE(@time_str, '%r');

#SET dateAndTime = cast(@date_str as datetime) + cast(@time_str as datetime);
#SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');