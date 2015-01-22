/*
Jas Sohi - Pivotal Tracker Database - Data Analyst Internship Project
January 22, 2015
*/

USE master --Use Master database

--Check for existence of existing database objects
if exists (SELECT * FROM sysdatabases WHERE name ='Pivotal_Tracker')
 BEGIN
 raiserror('Dropping existing Pivotal_Tracker database...',0,1)
 DROP database Pivotal_Tracker --This ensures that this script can be run periodically when the tables are updated in the csv file as long as no new field names added. 
 END

CREATE DATABASE Pivotal_Tracker

GO

USE Pivotal_Tracker

--CREATE TABLES AS PER SPECIFICATIONS

CREATE TABLE Table1
(
story_id int NOT NULL,
story_name varchar(50), 
story_type varchar(50),
estimate int
);

CREATE TABLE Table2
(
story_id int NOT NULL,
requested_by_id int NOT NULL,
owner_id int NOT NULL,
);

CREATE TABLE Table3
(
user_id int NOT NULL,
user_name varchar(50),
);

GO

--SET PRIMARY AND FOREIGN KEY CONSTRAINTS

ALTER TABLE Table1
ADD PRIMARY KEY (story_id);
ALTER TABLE Table2
ADD PRIMARY KEY (story_id,owner_id);
ALTER TABLE Table3
ADD PRIMARY KEY (user_id)

GO

ALTER TABLE Table2
ADD CONSTRAINT FK_Table2_Table1 FOREIGN KEY (story_id)
REFERENCES Table1
(story_id);
ALTER TABLE Table2
ADD CONSTRAINT FK_Table2_Table3 FOREIGN KEY (requested_by_id)
REFERENCES Table3
(user_id);
ALTER TABLE Table2
ADD CONSTRAINT FK_Table2_Table3_2 FOREIGN KEY (owner_id)
REFERENCES Table3
(user_id);

GO

BULK INSERT Table1
FROM 'C:\Users\user\Documents\Python Scripts\table1.csv' --needs to be changed if running locally on your own system
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)

BULK INSERT Table2
FROM 'C:\Users\user\Documents\Python Scripts\table2.csv' --needs to be changed if running locally on your own system
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)

INSERT INTO Table3
VALUES (1462570,'XZ')

INSERT INTO Table3
VALUES (1420764,'PA')

GO

--QUERY TIME!
--Total estimates (requested) and total owned estimates by user(s) who have requested more than two stories of ‘bug’ type.


--1. TOTAL ESTIMATES (REQUESTED)
--INNER QUERY is evaluated first and finds the users who have requested more than two stories of 'bug' type

SELECT Table2.requested_by_id, SUM(Table1.estimate) as 'Total Estimates'
FROM Table2
INNER JOIN Table1 ON Table1.story_id = Table2.story_id
WHERE Table2.requested_by_id IN
	(SELECT Table2.requested_by_id
	 FROM Table2
	 INNER JOIN Table1 ON Table1.story_id = Table2.story_id
	 WHERE Table1.story_type = 'bug'
	 GROUP BY Table2.requested_by_id
	 HAVING COUNT(*) > 2)
GROUP BY Table2.requested_by_id

--2. TOTAL OWNED ESTIMATES
--Similar to above except, this time we are looking at owner_id in the OUTER query only - inner query still the same

SELECT Table2.owner_id, SUM(Table1.estimate) as 'Total Estimates'
FROM Table2
INNER JOIN Table1 ON Table1.story_id = Table2.story_id
WHERE Table2.owner_id IN
	(SELECT Table2.requested_by_id
	 FROM Table2
	 INNER JOIN Table1 ON Table1.story_id = Table2.story_id
	 WHERE Table1.story_type = 'bug'
	 GROUP BY Table2.requested_by_id
	 HAVING COUNT(*) > 2)
GROUP BY Table2.owner_id

/*NOTES AND ASSUMPTIONS
-Need to be careful if any text field has a comma in it as the parser seperates values by commas (not in the test set provided, but for future updates)
-Assumption is made that 50 characters will be enough for all these fields.
-When updating periodically, the fields required will be the same. Otherwise the code needs to be updated.
-For Table 2, I believe there can only be one unique owner per story so I chose the composite Primary key of story_id and owner_id. TI made the assumption that there could be multiple requestors.
*/