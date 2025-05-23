

/*******************************************************************************
 * Step 1. SLA Violation Guardrail: Average Request Latency
 * *****************************************************************************
 *	Why:
 *	A rising average latency often precedes failures in downstream loads.
 *	
 *	Interpretation:
 *	Non-empty result means SLA breach risk.
 *
 *	Action:
 *	Configure an Azure Monitor log alert (e.g., every 15 min) or ADF pipeline 
 *	that emails/Teams notification when this query returns rows.
********************************************************************************/
-- Find any <PipelineName> runs in last hour exceeding SLA of 300 ms
SELECT TOP 1
  CaptureTime,
  AvgElapsedMs
FROM Telemetry.vw_RequestStats
WHERE PipelineName = '<PipelineName>'
  AND CaptureTime >= DATEADD(HOUR, -1, SYSUTCDATETIME())
  AND AvgElapsedMs > 300  -- your SLA (ms)
ORDER BY CaptureTime DESC;


/*******************************************************************************
 * Step 2. Emerging Hotspots: New Slowest Query Detection
 * *****************************************************************************
 *	Why: 
 *	Catches sudden regressions in query performance.
 *	
 *	Interpretation:
 *	Any row indicates a query running dramatically slower than its 7-day history.
 *
 *	Action: 
 *	Power BI data-driven alert or weekly review; drill into vw_QS_StatsTextPlan 
 *	and vw_PlanDetailsEnriched for that QueryId.
********************************************************************************/
-- Detect any QueryId in last hour whose max duration exceeds 5× its historical baseline
WITH Baseline AS (
  SELECT QueryId,
    AVG(MaxDuration) AS AvgMax
  FROM Telemetry.QS_Snapshot
  WHERE CaptureTime BETWEEN DATEADD(DAY, -7, SYSUTCDATETIME())
                        AND DATEADD(HOUR, -1, SYSUTCDATETIME())
  GROUP BY QueryId
), Recent AS (
  SELECT QueryId,
    MAX(MaxDuration) AS RecentMax
  FROM Telemetry.QS_Snapshot
  WHERE CaptureTime >= DATEADD(HOUR, -1, SYSUTCDATETIME())
  GROUP BY QueryId
)
SELECT r.QueryId, r.RecentMax, b.AvgMax
FROM Recent r
JOIN Baseline b
  ON r.QueryId = b.QueryId
WHERE r.RecentMax > b.AvgMax * 5;


/*******************************************************************************
 * Step 3. Data Skew Sentinel: Distribution Imbalance
 * *****************************************************************************
 *	Why: 
 *	Skew > 2 indicates one node holds >2× average data, throttling 
 *	parallel operations.
 *	
 *	Interpretation:
 *	SkewRatio > 2 calls for redistribution or new hash key.
 *
 *	Action: 
 *	Schedule daily check; alert if SkewRatio > 2; investigate table distribution 
 *	and consider CTAS on a different key.
********************************************************************************/
-- Calculate skew ratio of page distribution across nodes in last snapshot
WITH NodePages AS (
  SELECT NodeID,
    SUM(TotalPageCount) AS Pages
  FROM Telemetry.vw_DMVFileUsage
  WHERE CaptureTime >= DATEADD(HOUR, -1, SYSUTCDATETIME())
  GROUP BY NodeID
)
SELECT
  MAX(Pages)*1.0/AVG(Pages) AS SkewRatio
FROM NodePages;


/*******************************************************************************
 * Step 4. Plan Drift Monitor: Query Store Plan Changes
 * *****************************************************************************
 *	Why: 
 *	Flags new execution plans for high-frequency queries (possible regressions).
 *	
 *	Interpretation:
 *	Rows mean a query’s plan has changed in the last day and is now seen in 
 *	telemetry—investigate plan XML for regressions.
 *
 *	Action: 
 *	Include in weekly review; target frequent queries for monitoring or adding 
 *	plan-forcing hints.
********************************************************************************/
-- Identify new plans for frequent queries in the last day
WITH Frequent AS (
  SELECT QueryId
  FROM Telemetry.QS_Snapshot
  WHERE CaptureTime >= DATEADD(DAY, -1, SYSUTCDATETIME())
  GROUP BY QueryId
  HAVING COUNT_BIG(*) > 50
), LatestPlan AS (
  SELECT qs.QueryId, qs.PlanId,
    ROW_NUMBER() OVER(PARTITION BY qs.QueryId ORDER BY qs.CaptureTime DESC) rn
  FROM Telemetry.QS_Snapshot qs
  JOIN Frequent f ON qs.QueryId = f.QueryId
)
SELECT p.QueryId, p.PlanId, qsp.query_plan
FROM LatestPlan p
JOIN sys.query_store_plan qsp
  ON p.PlanId = qsp.plan_id
WHERE p.rn = 1
  AND NOT EXISTS (
    -- exclude if this plan existed in the week before
    SELECT 1 FROM Telemetry.QS_Snapshot qs2
    WHERE qs2.PlanId = p.PlanId
      AND qs2.CaptureTime < DATEADD(DAY, -1, SYSUTCDATETIME())
      AND qs2.CaptureTime >= DATEADD(DAY, -8, SYSUTCDATETIME())
);

/*******************************************************************************
 * Step 5. Anomalous File Processing: File‑List Health Check
 * *****************************************************************************
 *	Why: 
 *	Stuck or slow file ingestion often cascades into downstream delays.
 *	
 *	Interpretation:
 *	Any row indicates an ingestion file awaiting processing for too long.
 *
 *	Action: 
 *	Set up an ADF alert pipeline or Logic App to pick up these rows, retry or 
 *	notify operations.
********************************************************************************/
-- Detect files that are still Pending > 30 min in the FileList control table
SELECT FileName, FileDate, EnqueueTime
FROM Control.FileList
WHERE Status = 'Pending'
  AND EnqueueTime < DATEADD(MINUTE, -30, SYSUTCDATETIME());


/*******************************************************************************
 * Next Steps Considerations
 * *****************************************************************************
 *	1. Scheduling: Use an hourly ADF pipeline or Azure Logic App to run 
 *		these queries.
 *
 *	2. Alerting: Integrate with Azure Monitor (Log Analytics), email, Teams, 
 *		or ServiceNow.
 *
 *	3. Dashboards: Surface via Power BI or built‑in Synapse SQL on-demand 
 *		dashboards.
 *
 *	4. Remediation: Consider automated pipeline triggers to repartition tables 
 *		or scale DWU when thresholds are exceeded.
********************************************************************************/
