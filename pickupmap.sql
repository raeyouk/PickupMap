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

DROP TABLE IF EXISTS dataFromDiplo;
CREATE TABLE dataFromDiplo
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	address			VARCHAR(255),
    company			VARCHAR(255)	DEFAULT "Diplo"
);

DROP TABLE IF EXISTS dataFromCarmel;
CREATE TABLE dataFromCarmel
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	address			VARCHAR(255),
    company			VARCHAR(255)	DEFAULT "Carmel"
);

DROP TABLE IF EXISTS dataFromDial7;
CREATE TABLE dataFromDial7
(
	id				INT	PRIMARY KEY	AUTO_INCREMENT,
	dateAndTime     DATETIME,
	address			VARCHAR(255),
    company			VARCHAR(255)	DEFAULT "Dial7"
);

-- trigger to remove New Jersey and Staten Island points
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
               SET NEW.dateAndTime = null; -- make point invalid
           END IF;
       END;//
delimiter ;

-- trigger to remove Staten Island points
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

-- to allow delete where dateAndTime is null
SET SQL_SAFE_UPDATES = 0; 

-- insert uber data into database
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/uber-trip-data/uber-raw-data-jul14.csv' 
INTO TABLE dataFromUberJul
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date_str, latitude, longitude, @dummy)
SET dateAndTime = STR_TO_DATE(@date_str, '%c/%e/%Y %T');

delete from dataFromUberJul
where id > 1000 or dateAndTime is null; -- limit and remove invalid points

SELECT * FROM dataFromUberJul;

-- insert lyft data into database
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

-- insert Diplo
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Diplo_B01196.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Diplo_B01196.csv' 
INTO TABLE dataFromDiplo
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@date_str, @time_str, address)
SET dateAndTime = STR_TO_DATE(CONCAT(@date_str, ' ', @time_str), '%c/%e/%Y %r');

delete from dataFromDiplo
where id > 50 or dateAndTime is null;

select * from dataFromDiplo;

-- insert Carmel
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Carmel_B00256.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Carmel_B00256.csv' 
INTO TABLE dataFromCarmel
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@date_str, @time_str, address, @dummy)
SET dateAndTime = STR_TO_DATE(CONCAT(@date_str, ' ', cast(@time_str as time)), '%c/%e/%Y %T');

delete from dataFromCarmel
where id > 50 or dateAndTime is null;

select * from dataFromCarmel;

-- insert Dial7
LOAD DATA INFILE 'D:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Dial7_B00887.csv' 
#LOAD DATA INFILE 'C:/wamp64/www/PickupMap/uber-tlc-foil-response-master/other-FHV-data/Dial7_B00887.csv' 
INTO TABLE dataFromDial7
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@date_str, @time_str, @dummy, @pu, @num, @st)
SET dateAndTime = STR_TO_DATE(CONCAT(@date_str, ' ', cast(@time_str as time)), '%Y.%m.%d %T'),
address = (CONCAT(@num, ' ', @st, @pu));

delete from dataFromDial7
where id > 50 or dateAndTime is null;

select * from dataFromDial7;

-- Late Uber trips
DROP VIEW IF EXISTS lateTripsUberJul;
CREATE VIEW lateTripsUberJul
AS SELECT id, dateAndTime, company
FROM dataFromUberJul
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsUberJul join dataFromUberJul using(id, dateAndTime, company);

-- Late Lyft trips
DROP VIEW IF EXISTS lateTripsLyft;
CREATE VIEW lateTripsLyft
AS SELECT id, dateAndTime, company
FROM dataFromLyft
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsLyft join dataFromLyft using(id, dateAndTime, company);

-- Late Diplo trips
DROP VIEW IF EXISTS lateTripsDiplo;
CREATE VIEW lateTripsDiplo
AS SELECT id, dateAndTime, company
FROM dataFromDiplo
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsDiplo join dataFromDiplo using(id, dateAndTime, company);

-- Late Carmel trips
DROP VIEW IF EXISTS lateTripsCarmel;
CREATE VIEW lateTripsCarmel
AS SELECT id, dateAndTime, company
FROM dataFromCarmel
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsCarmel join dataFromCarmel using(id, dateAndTime, company);

-- Late Dial7 trips
DROP VIEW IF EXISTS lateTripsDial7;
CREATE VIEW lateTripsDial7
AS SELECT id, dateAndTime, company
FROM dataFromDial7
WHERE hour(dateAndTime)  > 22 OR hour(dateAndTime)  < 4;

SELECT * FROM lateTripsDial7 join dataFromDial7 using(id, dateAndTime, company);

-- stored procedures to get late rides
DROP PROCEDURE IF EXISTS lateUberJul;
DELIMITER //
CREATE PROCEDURE lateUberJul()
BEGIN
SELECT *
FROM lateTripsUberJul join dataFromUberJul using(id, dateAndTime, company);
END //
DELIMITER ;
CALL lateUberJul;

DROP PROCEDURE IF EXISTS lateLyft;
DELIMITER //
CREATE PROCEDURE lateLyft()
BEGIN
SELECT *
FROM lateTripsLyft join dataFromLyft using(id, dateAndTime, company);
END //
DELIMITER ;
CALL lateLyft;

DROP PROCEDURE IF EXISTS lateDiplo;
DELIMITER //
CREATE PROCEDURE lateDiplo()
BEGIN
SELECT *
FROM lateTripsDiplo join dataFromDiplo using(id, dateAndTime, company);
END //
DELIMITER ;
CALL lateDiplo;

DROP PROCEDURE IF EXISTS lateCarmel;
DELIMITER //
CREATE PROCEDURE lateCarmel()
BEGIN
SELECT *
FROM lateTripsCarmel join dataFromCarmel using(id, dateAndTime, company);
END //
DELIMITER ;
CALL lateCarmel;

DROP PROCEDURE IF EXISTS lateDial7;
DELIMITER //
CREATE PROCEDURE lateDial7()
BEGIN
SELECT *
FROM lateTripsDial7 join dataFromDial7 using(id, dateAndTime, company);
END //
DELIMITER ;
CALL lateDial7;
