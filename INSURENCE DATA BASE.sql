-- Show available databases
SHOW DATABASES;

-- Select the mysql database
USE mysql;

-- Create PERSON table
CREATE TABLE PERSON (
    driver_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

-- Describe PERSON table
DESC PERSON;

-- Create CAR table
CREATE TABLE CAR (
    reg_num VARCHAR(15) PRIMARY KEY,
    model VARCHAR(30),
    year INT
);

-- Describe CAR table
DESC CAR;

-- Create ACCIDENT table
CREATE TABLE ACCIDENT (
    report_num INT PRIMARY KEY,
    accident_date DATE,
    location VARCHAR(100)
);

-- Describe ACCIDENT table
DESC ACCIDENT;

-- Create OWNS table
CREATE TABLE OWNS (
    driver_id VARCHAR(10),
    reg_num VARCHAR(15),
    PRIMARY KEY (driver_id, reg_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num)
);

-- Describe OWNS table
DESC OWNS;

-- Create PARTICIPATED table
CREATE TABLE PARTICIPATED (
    driver_id VARCHAR(10),
    reg_num VARCHAR(15),
    report_num INT,
    damage_amount INT,
    PRIMARY KEY (driver_id, reg_num, report_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num),
    FOREIGN KEY (report_num) REFERENCES ACCIDENT(report_num)
);

-- Insert data into PERSON
INSERT INTO PERSON (driver_id, name, address) VALUES
    ('A01','Richard','Srinivas Nagar'),
    ('A02','Pradeep','Rajaji Nagar'),
    ('A03','Smith','Ashok Nagar'),
    ('A04','Venu','NR Colony'),
    ('A05','Jhon','Hanumanth Nagar');

-- View data in PERSON
SELECT * FROM PERSON;

-- Insert data into CAR
INSERT INTO CAR (reg_num, model, year) VALUES
    ('KA052250','Indica',1990),
    ('KA031181','Lancer',1957),
    ('KA095477','Toyota',1998),
    ('KA053408','Honda',2008),
    ('KA041702','Audi',2005),
    ('KA032180','Suzuki',2001),
    ('KA058849','Ford',2003),
    ('KA052003','Hyundai',2006),
    ('KA014266','BMW',2004);

-- View data in CAR
SELECT * FROM CAR;

-- Insert data into ACCIDENT
INSERT INTO ACCIDENT (report_num, accident_date, location) VALUES
    (11,'2003-01-01','Mysore road'),
    (12,'2004-02-02','South End circle'),
    (13,'2003-01-21','Bull Temple road'),
    (14,'2008-02-17','Mysore road'),
    (15,'2005-03-04','Kanakpura road');

-- View data in ACCIDENT
SELECT * FROM ACCIDENT;

-- Insert data into OWNS
INSERT INTO OWNS (driver_id, reg_num) VALUES
    ('A01','KA052250'),
    ('A02','KA031181'),
    ('A03','KA095477'),
    ('A04','KA053408'),
    ('A05','KA041702'),
    ('A01','KA032180'),
    ('A02','KA058849'),
    ('A03','KA052003'),
    ('A04','KA014266');

-- View data in OWNS
SELECT * FROM OWNS;

-- Insert data into PARTICIPATED
INSERT INTO PARTICIPATED (driver_id, reg_num, report_num, damage_amount) VALUES
    ('A01','KA052250',11,5000),
    ('A02','KA031181',12,3000),
    ('A03','KA095477',13,7000),
    ('A04','KA053408',14,2500),
    ('A05','KA041702',15,4000);
    
SELECT * FROM PARTICIPATED;

UPDATE PARTICIPATED SET damage_amount=5000 WHERE reg_num= 'KA032180' and report_num=12;

SELECT COUNT(DISTINCT p.driver_id) AS CNT
FROM PARTICIPATED p
JOIN ACCIDENT a ON p.report_num = a.report_num
WHERE a.accident_date LIKE '%17';

INSERT INTO ACCIDENT VALUES (16,'2016-03-08','samartha');
SELECT * FROM ACCIDENT;
SELECT accident_date,location from ACCIDENT;
SELECT driver_id FROM PARTICIPATED WHERE damage_amount >= 5000;

SELECT * FROM PARTICIPATED ORDER BY damage_amount DESC;
SELECT AVG(damage_amount) from PARTICIPATED;

SELECT a.name
FROM PERSON a
JOIN PARTICIPATED b ON a.driver_id = b.driver_id
WHERE b.damage_amount < (
    SELECT AVG(damage_amount)
    FROM PARTICIPATED
);

SELECT max(damage_amount) FROM (PARTICIPATED);
SELECT driver_id, damage_amount
FROM PARTICIPATED
WHERE damage_amount >= 5000;

SELECT p.driver_id, p.name, o.reg_num, c.model
FROM PERSON p
JOIN OWNS o ON p.driver_id = o.driver_id
JOIN CAR c ON o.reg_num = c.reg_num;

SELECT a.report_num, a.accident_date, a.location, p.driver_id, p.name, pr.damage_amount
FROM ACCIDENT a
JOIN PARTICIPATED pr ON a.report_num = pr.report_num
JOIN PERSON p ON pr.driver_id = p.driver_id;

SELECT report_num, SUM(damage_amount) AS total_damage
FROM PARTICIPATED
GROUP BY report_num;

SELECT *
FROM ACCIDENT
ORDER BY accident_date DESC
LIMIT 1;

UPDATE PARTICIPATED
SET damage_amount = 25000
WHERE reg_num = 'KA052250' AND report_num = 11;

SELECT driver_id, reg_num, report_num, damage_amount
FROM PARTICIPATED
WHERE damage_amount = (
    SELECT MAX(damage_amount) FROM PARTICIPATED
);

CREATE VIEW AccidentSummary AS
SELECT report_num,
       COUNT(DISTINCT driver_id) AS participant_count,
       SUM(damage_amount) AS total_damage
FROM PARTICIPATED
GROUP BY report_num;








