CREATE VIEW [Analytics].[vw_MonAvgVisitDurByVisitorType]
AS SELECT
  CONCAT(d.Year, '-', RIGHT('0' + CAST(d.MonthOfYear AS VARCHAR(2)),2)) AS [YearMonth],
  vt.VisitorType          AS [Visitor Type],
  ROUND(AVG(f.DurationMin), 1) AS [AvgDurationMin]
FROM Gold.factVisitorLog AS f
JOIN Gold.dimDate AS d
  ON f.DateKey = d.DateKey
JOIN Gold.dimVisitorType AS vt
  ON f.VisitorTypeKey = vt.VisitorTypeKey
GROUP BY
  d.Year,
  d.MonthOfYear,
  vt.VisitorType;
GO