
-- 1. Alert on Rising Request Latency
-- finds any recent Bronze_Load run with avg request latency > 500 ms
SELECT TOP 1
  CaptureTime,
  AvgElapsedMs
FROM Telemetry.vw_RequestStats
WHERE PipelineName = 'Bronze_Load'
  AND CaptureTime > DATEADD(HOUR, -1, SYSUTCDATETIME())
  --AND AvgElapsedMs > 10 -- SLA
ORDER BY CaptureTime DESC;


-- 2.Alert for New Slowest Queries
-- looks for any query whose MaxDuration in the last hour exceeded 5 sec
-- help catch regressions before they could impact SLAs, investigate w/ QueryId
SELECT
  qs.QueryId,
  qs.MaxDuration
FROM Telemetry.vw_QS_TopSlowQueries AS qs
WHERE 
	CaptureTime > DATEADD(HOUR, -1, SYSUTCDATETIME())
	AND MaxDuration > 5000  -- 5,000 ms depending on units
	AND RankByMaxDuration = 1;


-- 3. Detect Distribution Skew
-- help catch skew early to repartition or define dist key
-- A SkewRatio > 2 indicates one node has more than twice the average pages.
WITH UsagePerNode AS (
  SELECT
    NodeID,
    SUM(TotalPageCount) AS Pages
  FROM Telemetry.vw_DMVFileUsage
  WHERE CaptureTime > DATEADD(HOUR, -1, SYSUTCDATETIME())
  GROUP BY NodeID
)
SELECT
  MAX(Pages) * 1.0 / AVG(Pages) AS SkewRatio
FROM UsagePerNode;
