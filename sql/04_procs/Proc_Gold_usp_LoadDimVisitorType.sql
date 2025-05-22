CREATE PROC [Gold].[usp_LoadDimVisitorType] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Gold.dimVisitorType);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

 TRUNCATE TABLE Gold.dimVisitorType;

  INSERT INTO Gold.dimVisitorType (VisitorType)
  SELECT DISTINCT VisitorType
    FROM Silver.VisitorLog;

  -- 4 a) How many we just loaded
  DECLARE @RowsInserted INT = (SELECT COUNT(*) FROM Gold.dimVisitorType);

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