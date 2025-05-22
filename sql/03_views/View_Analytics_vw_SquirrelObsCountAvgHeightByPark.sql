CREATE VIEW [Analytics].[vw_SquirrelObsCountAvgHeightByPark]
AS SELECT
  d.FullDate            AS [Date],
  p.ParkName            AS [Park],
  COUNT(*)              AS [Observations],
  ROUND(AVG(f.AboveGroundHeight), 2) AS [AvgHeightFt]
FROM Gold.factSquirrelObservations AS f
JOIN Gold.dimDate AS d
  ON f.DateKey = d.DateKey
JOIN Gold.dimPark AS p
  ON f.ParkKey = p.ParkKey
GROUP BY
  d.FullDate,
  p.ParkName;
GO