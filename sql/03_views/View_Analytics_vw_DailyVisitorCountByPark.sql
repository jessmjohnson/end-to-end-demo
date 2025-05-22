CREATE VIEW [Analytics].[vw_DailyVisitorCountByPark]
AS SELECT
  d.FullDate            AS [Date],
  p.ParkName            AS [Park],
  COUNT(*)              AS [NumVisits]
FROM Gold.factVisitorLog AS f
JOIN Gold.dimDate AS d
  ON f.DateKey = d.DateKey
JOIN Gold.dimPark AS p
  ON f.ParkKey = p.ParkKey
GROUP BY
  d.FullDate,
  p.ParkName;
GO

-- Use in Power BI:
--  * Plot a clustered column chart of NumVisits (Y) by Date (X), with Park as the legend.
--  * Filter by park or date slicers to analyze foot traffic trends.