CREATE PROC [Gold].[usp_LoadFactVisitorLog] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Gold.factVisitorLog);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

  TRUNCATE TABLE Gold.factVisitorLog;

  INSERT INTO Gold.factVisitorLog
    (DateKey, ParkKey, VisitorTypeKey, DurationMin)
  SELECT
    CONVERT(INT, FORMAT(VisitTimestamp, 'yyyyMMdd')) AS DateKey,
    dp.ParkKey,
    vt.VisitorTypeKey,
    DurationMin
  FROM Silver.VisitorLog sl
  JOIN Gold.dimPark dp
    ON sl.ParkID = dp.ParkID
  JOIN Gold.dimVisitorType vt
    ON sl.VisitorType = vt.VisitorType;


  -- 4 a) How many we just loaded
  DECLARE @RowsInserted INT = (SELECT COUNT(*) FROM Gold.factVisitorLog);

  -- 4 b) compute duration in seconds
  DECLARE @EndTime      DATETIME2 = GETDATE();
  DECLARE @DurationSec  INT       = DATEDIFF(SECOND, @StartTime, @EndTime);

  -- 5) return both in a single row
  SELECT 
    @RowsDeleted  AS RowsDeleted,
    @RowsInserted AS RowsInserted,
    @DurationSec  AS DurationSeconds;
END;