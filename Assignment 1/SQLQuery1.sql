-- Create a database for your assignment
CREATE DATABASE DWH_Assignment;
GO

USE DWH_Assignment;
GO

-- ==========================================
-- TASK 1: Target Table Preparation
-- ==========================================
CREATE TABLE air_quality_Q1 (
    sensor_id VARCHAR(50),
    city VARCHAR(100),
    reading_timestamp DATETIME,
    pm25 FLOAT,
    pm10 FLOAT,
    source_system VARCHAR(50)
);
GO


-- Task 2
CREATE TABLE Campaign_Q2_source (
    ID          INT            NOT NULL PRIMARY KEY,
    Name        NVARCHAR(100)  NOT NULL,
    Budget      DECIMAL(18,2)  NOT NULL,
    Update_Date DATE           NOT NULL
);


INSERT INTO Campaign_Q2_source (ID, Name, Budget, Update_Date) VALUES
(1001, 'Summer Ads', 10000, '2026-01-01'),
(1002, 'Winter Ads', 15000, '2026-01-01'),
(1003, 'Spring Ads', 20000, '2026-01-01');



CREATE TABLE Campaign_Q2_target (
    SurrogateKey      INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    ID                INT                NOT NULL,
    Name              NVARCHAR(100)      NOT NULL,
    Budget            DECIMAL(18,2)      NOT NULL,
    Previous_Name     NVARCHAR(100)      NULL,
    Previous_Budget   DECIMAL(18,2)      NULL,
    Current_Name      NVARCHAR(100)      NOT NULL,
    Current_Budget    DECIMAL(18,2)      NOT NULL,
    Start_Date        DATE               NOT NULL,
    End_Date          DATE               NULL,
    Is_Current        BIT                NOT NULL DEFAULT 1,
    Update_Date       DATE               NOT NULL
);


CREATE TABLE ETL_Watermark (
    TableName       NVARCHAR(100)  NOT NULL PRIMARY KEY,
    Last_Load_Date  DATE           NOT NULL
);


INSERT INTO ETL_Watermark (TableName, Last_Load_Date)
VALUES ('Campaign_Q2', '2025-12-31');


-- Check source has 3 rows
SELECT * FROM Campaign_Q2_source;

-- Check target is empty with correct columns
SELECT * FROM Campaign_Q2_target;

-- Check watermark is set correctly
SELECT * FROM ETL_Watermark;