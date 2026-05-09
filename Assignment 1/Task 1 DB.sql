use DWH_Assignment

CREATE TABLE air_quality_Q1 (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    sensor_id   NVARCHAR(100),
    city        NVARCHAR(100),
    timestamp   DATETIME,
    pm25        FLOAT,
    pm10        FLOAT,
    source      NVARCHAR(50)
);

select * from air_quality_Q1

truncate table air_quality_Q1