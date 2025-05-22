SELECT 'Bronze' AS StageName, 'ParkData' AS TableName, (SELECT COUNT(*) FROM Bronze.ParkData) AS NumRows
UNION ALL
SELECT 'Bronze' AS StageName, 'SquirrelData' AS TableName, (SELECT COUNT(*) FROM Bronze.SquirrelData) AS NumRows
UNION ALL
SELECT 'Bronze' AS StageName, 'VisitorLog' AS TableName, (SELECT COUNT(*) FROM Bronze.VisitorLog) AS NumRows
UNION ALL
SELECT 'Silver' AS StageName, 'ParkObservations' AS TableName, (SELECT COUNT(*) FROM Silver.ParkObservations) AS NumRows
UNION ALL
SELECT 'Silver' AS StageName, 'SquirrelObservations' AS TableName, (SELECT COUNT(*) FROM Silver.SquirrelObservations) AS NumRows
UNION ALL
SELECT 'Silver' AS StageName, 'VisitorLog' AS TableName, (SELECT COUNT(*) FROM Silver.VisitorLog) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'dimDate' AS TableName, (SELECT COUNT(*) FROM Gold.dimDate) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'dimPark' AS TableName, (SELECT COUNT(*) FROM Gold.dimPark) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'dimSquirrel' AS TableName, (SELECT COUNT(*) FROM Gold.dimSquirrel) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'dimVisitorType' AS TableName, (SELECT COUNT(*) FROM Gold.dimVisitorType) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'factSquirrelObservations' AS TableName, (SELECT COUNT(*) FROM Gold.factSquirrelObservations) AS NumRows
UNION ALL
SELECT 'Gold' AS StageName, 'factVisitorLog' AS TableName, (SELECT COUNT(*) FROM Gold.factVisitorLog) AS NumRows


/*
TRUNCATE TABLE Bronze.ParkData;
TRUNCATE TABLE Bronze.SquirrelData;
TRUNCATE TABLE Bronze.VisitorLog;
TRUNCATE TABLE Silver.ParkObservations;
TRUNCATE TABLE Silver.SquirrelObservations;
TRUNCATE TABLE Silver.VisitorLog;
TRUNCATE TABLE Gold.dimPark;
TRUNCATE TABLE Gold.dimSquirrel;
TRUNCATE TABLE Gold.dimVisitorType;
TRUNCATE TABLE Gold.factSquirrelObservations;
TRUNCATE TABLE Gold.factVisitorLog;

*/

/*
ALTER DATABASE [dspendtoenddemo]
SET QUERY_STORE = ON;
*/

--SELECT * FROM Telemetry.PipelineLog WHERE EventType = 'Success' ORDER BY EventTime;


/*
UPDATE Control.FileList
SET Status = 'Pending'
WHERE FileName LIKE '%20250510%'

SELECT * FROM Control.FileList
WHERE FileName LIKE '%20250510%'
*/