
CREATE PROC [Silver].[usp_LoadSquirrelObservations] AS
BEGIN
  SET NOCOUNT ON;

  -- 1 a) capture how many rows we're about to truncate
  DECLARE @RowsDeleted INT = (SELECT COUNT(*) FROM Silver.SquirrelObservations);

  -- 1 b) capture start time
  DECLARE @StartTime    DATETIME2 = GETDATE();

  -- 2) Clear out old rows
  TRUNCATE TABLE Silver.SquirrelObservations;

  -- 3) Insert typed data from Bronze
  INSERT INTO Silver.SquirrelObservations
    (   AreaName, AreaID, ParkName, ParkID, SquirrelID, PrimaryFurColor, HighlightsInFurColor, ColorNotes, 
        Location, AboveGroundHeight, SpecificLocation, Activities, HumanInteractions, OtherNotesObservations,
        SquirrelLatitude, SquirrelLongitude, ObservationDate
    )
SELECT
  COALESCE(TRY_CONVERT(VARCHAR(100),       AreaName),                'Unknown Area')    AS AreaName,
  COALESCE(TRY_CONVERT(CHAR(2),            AreaID),                   '-1')               AS AreaID,  
  COALESCE(TRY_CONVERT(VARCHAR(100),       ParkName),                'Unknown Park')    AS ParkName,
  COALESCE(TRY_CONVERT(DECIMAL,                ParkID),                  -1)                 AS ParkID,
  COALESCE(TRY_CONVERT(CHAR(25),           SquirrelID),              '-1')               AS SquirrelID,
  COALESCE(TRY_CONVERT(VARCHAR(50),        PrimaryFurColor),         'Unknown')         AS PrimaryFurColor,
  COALESCE(TRY_CONVERT(VARCHAR(50),        HighlightsInFurColor),    'Unknown')         AS HighlightsInFurColor,
  COALESCE(TRY_CONVERT(VARCHAR(150),       ColorNotes),              'Unknown')         AS ColorNotes,
  COALESCE(TRY_CONVERT(VARCHAR(50),        Location),                'Unknown')         AS Location,
  COALESCE(TRY_CONVERT(INT,                AboveGroundHeight),       -1)                 AS AboveGroundHeight,
  COALESCE(TRY_CONVERT(VARCHAR(50),        SpecificLocation),        'Unknown')         AS SpecificLocation,
  COALESCE(TRY_CONVERT(VARCHAR(50),        Activities),              'Unknown')         AS Activities,
  COALESCE(TRY_CONVERT(VARCHAR(50),        HumanInteractions),       'Unknown')         AS HumanInteractions,
  COALESCE(TRY_CONVERT(VARCHAR(255),       OtherNotesObservations),  'Unknown')         AS OtherNotesObservations,
  COALESCE(TRY_CONVERT(DECIMAL(9,6),       SquirrelLatitude),         0.00)              AS SquirrelLatitude,
  COALESCE(TRY_CONVERT(DECIMAL(9,6),       SquirrelLongitude),        0.00)              AS SquirrelLongitude,
  COALESCE(
  TRY_CONVERT(DATE, [Date], 23),   -- try yyyy-mm-dd first
  TRY_CONVERT(DATE, [Date], 101),  -- then MM/dd/yyyy
  '1900-01-01'                     -- fallback
)       AS ObservationDate
FROM Bronze.SquirrelData;

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