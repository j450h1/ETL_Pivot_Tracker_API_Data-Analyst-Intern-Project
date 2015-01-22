USE master --Use Master database

--Check for existence of existing objects
if exists (SELECT * FROM sysdatabases WHERE name ='Pivotal_Tracker')
 begin
 raiserror('Dropping existing Pivotal_Tracker database...',0,1)
 DROP database Pivotal_Tracker --This ensures that this script can be run periodically when the tables are updated in the csv file as long as no new field names added. 

CREATE DATABASE Pivotal_Tracker

USE Pivotal_Tracker

CREATE TABLE Table1
(
story_id int NOT NULL,
story_name varchar(50) NOT NULL,
story_type varchar(50),
estimate int
):

CREATE TABLE Table2
(
story_id int NOT NULL,
requested_by_id int ,
owner_id int,
estimate int
):

CREATE TABLE Table3
(
user_id int NOT NULL,
user_name varchar(50),
):








