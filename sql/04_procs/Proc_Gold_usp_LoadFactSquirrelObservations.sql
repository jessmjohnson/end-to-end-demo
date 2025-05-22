CREATE PROC [Gold].[usp_LoadFactSquirrelObservations] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Gold.factSquirrelObservations);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

    TRUNCATE TABLE Gold.factSquirrelObservations;

  INSERT INTO Gold.factSquirrelObservations
    (DateKey, ParkKey, SquirrelKey, AboveGroundHeight, SquirrelLatitude, SquirrelLongitude)
  SELECT
    CONVERT(INT, FORMAT(ObservationDate, 'yyyyMMdd')) AS DateKey,
    dp.ParkKey,
    ds.SquirrelKey,
    TRY_CONVERT(INT, AboveGroundHeight)     AS AboveGroundHeight,
    SquirrelLatitude,
    SquirrelLongitude
  FROM Silver.SquirrelObservations so
  JOIN Gold.dimPark dp
    ON so.ParkID = dp.ParkID
  JOIN Gold.dimSquirrel ds
    ON so.SquirrelID = ds.SquirrelID;


  -- 4 a) How many we just loaded
  DECLARE @RowsInserted INT = (SELECT COUNT(*) FROM Gold.factSquirrelObservations);

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