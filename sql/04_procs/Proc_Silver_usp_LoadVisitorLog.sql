CREATE PROC [Silver].[usp_LoadVisitorLog] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Silver.SquirrelObservations);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

  -- 2) Clear out old rows
  TRUNCATE TABLE Silver.VisitorLog;

  -- 3) Insert typed data from Bronze
  INSERT INTO Silver.VisitorLog (   VisitID, ParkID, VisitTimestamp, VisitorType, DurationMin)
    SELECT
        COALESCE(TRY_CONVERT(INT,                   VisitID),                  -1)         AS VisitID,
        COALESCE(TRY_CONVERT(INT,                   ParkID),                  -1)          AS ParkID,
        COALESCE(
          TRY_CONVERT(DATETIME2(0), VisitTimestamp, 120),
          CAST('1900-01-01' AS DATETIME2(0))
        ) AS VisitTimestamp,
        COALESCE(TRY_CONVERT(VARCHAR(50),        VisitorType),            'Unknown')       AS VisitorType,
        COALESCE(TRY_CONVERT(INT,                DurationMin),             -1)             AS DurationMin
    FROM Bronze.VisitorLog;

  -- 4 a) How many we just loaded
  DECLARE @RowsInserted INT = (SELECT COUNT(*) FROM Silver.SquirrelObservations);

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