
CREATE PROC [Silver].[usp_LoadParkObservations] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Silver.ParkObservations);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

  -- 2) Clear out old rows
  TRUNCATE TABLE Silver.ParkObservations;

  -- 3) Insert typed data from Bronze
  INSERT INTO Silver.ParkObservations
      (AreaName, AreaID, ParkName, ParkID, ObservationDate, ObservationStartTime, ObservationEndTime,
       TotalTime, ParkConditions, OtherAnimalSightings, Litter, TemperatureWeather,
       NumberSquirrels, SquirrelSighters, NumberSighters)
  SELECT
    COALESCE(TRY_CONVERT(VARCHAR(50), AreaName), 'Unknown') AS AreaName,
    COALESCE(TRY_CONVERT(CHAR(1), AreaID), '-1') AS AreaID,
    COALESCE(TRY_CONVERT(VARCHAR(50), ParkName), 'Unknown') AS ParkName,
    COALESCE(TRY_CONVERT(DECIMAL, ParkID), -1) AS ParkID,
    COALESCE(
      TRY_CONVERT(DATE, [Date], 23),   -- try yyyy-mm-dd first
      TRY_CONVERT(DATE, [Date], 101),  -- then MM/dd/yyyy
      '1900-01-01'                     -- fallback
    ) AS ObservationDate,
    COALESCE(TRY_CONVERT(TIME(0), StartTime, 108), CAST('00:00:00' AS TIME(0))) AS ObservationStartTime,
    COALESCE(TRY_CONVERT(TIME(0), EndTime, 108), CAST('00:00:00' AS TIME(0))) AS ObservationEndTime,
    COALESCE(TRY_CONVERT(INT, TotalTime), -1) AS TotalTime,
    COALESCE(TRY_CONVERT(VARCHAR(100), ParkConditions), 'Unknown') AS ParkConditions,
    COALESCE(TRY_CONVERT(VARCHAR(100), OtherAnimalSightings), 'Unknown') AS OtherAnimalSightings,
    COALESCE(TRY_CONVERT(VARCHAR(100), Litter), 'Unknown') AS Litter,
    COALESCE(TRY_CONVERT(VARCHAR(50), TemperatureWeather), 'Unknown') AS TemperatureWeather,
    COALESCE(TRY_CONVERT(INT, NumberSquirrels), -1) AS NumberSquirrels,
    COALESCE(TRY_CONVERT(VARCHAR(100), SquirrelSighters), 'Unknown') AS SquirrelSighters,
    COALESCE(TRY_CONVERT(INT, NumberSighters), -1) AS   NumberSighters
FROM Bronze.ParkData;

  -- 4 a) How many we just loaded
  DECLARE @RowsInserted INT = (SELECT COUNT(*) FROM Silver.ParkObservations);

  -- 4 b) compute duration in seconds
  DECLARE @EndTime      DATETIME2 = GETDATE();
  DECLARE @DurationSec  INT       = DATEDIFF(SECOND, @StartTime, @EndTime);

  -- 5) return both in a single row
  SELECT 
    @RowsDeleted  AS RowsDeleted,
    @RowsInserted AS RowsInserted,
    @DurationSec  AS DurationSeconds;

END;
GO