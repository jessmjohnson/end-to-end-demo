
/*******************************************************************************
 * Step 1. Identify the Slowest Pipeline Run
 * *****************************************************************************
 *	What to look for: 
 *	The run with the highest MaxElapsedMs.
 *	
 *	Why it matters: 
 *	This pinpoints the exact run where some query took unusually long, 
 *	giving you a PipelineRunId and approximate time window (CaptureTime) 
 *	for further investigation.
********************************************************************************/
SELECT TOP 1
  PipelineRunId,    -- GUID of the pipeline run
  CaptureTime,      -- timestamp of the telemetry capture
  AvgElapsedMs,     -- average request latency in ms
  MaxElapsedMs      -- maximum request latency in ms
FROM Telemetry.Requests_Snapshot
WHERE PipelineName = '<Your Pipeline Name>'
ORDER BY MaxElapsedMs DESC;


/*******************************************************************************
 * Step 2. Find the Top Slowest Queries
 * *****************************************************************************
 *	What to look for: 
 *	The few QueryId values whose MaxDuration far exceed the rest.
 *	
 *	Why it matters: 
 *	these queries account for the bulk of the elapsed time; focusing on them 
 *	gives the biggest performance gains.
********************************************************************************/
SELECT TOP 5
  CaptureTime,
  QueryId,          -- Query identifier in the Query Store
  PlanId,           -- Plan snapshot identifier
  CountExecutions,  -- how many times this QueryId ran during the window
  AvgDuration,      -- average duration (µs or ms)
  MaxDuration       -- worst-case duration
FROM Telemetry.QS_Snapshot
WHERE PipelineRunId = '<BadRunId>'
  AND CaptureTime   LIKE '2025-05-19 14:13%'  -- narrow to the same window
ORDER BY MaxDuration DESC;


/*******************************************************************************
 * Step 3. Retrieve SQL Text & Execution Plan
 * *****************************************************************************
 *	What to look for: 
 *	The full SQL text and its XML execution plan.
 *	
 *	Why it matters: 
 *	Plan‑level detail is required to understand why a query is slow 
 *	(e.g. scans, spills, skew).
********************************************************************************/
SELECT
  qt.query_sql_text AS SqlText,
  p.query_plan      AS PlanXml
FROM Telemetry.QS_Snapshot qs
JOIN sys.query_store_plan        p  ON qs.PlanId    = p.plan_id
JOIN sys.query_store_query       q  ON p.query_id   = q.query_id
JOIN sys.query_store_query_text  qt ON q.query_text_id = qt.query_text_id
WHERE
  qs.PipelineRunId = '<BadRunId>'
  AND qs.QueryId   = <TopQueryId>;


/*******************************************************************************
 * Step 4. Analyze the Execution Plan
 * *****************************************************************************
 *	Instructions: 
 *	Open PlanXML in plan viewer/explorer (SSMS or SQL Sentry Plan Explorer)
 *	• Check for Scans when an Idex Seek was expects.
 *	• Identify Spills (Hash or Store operators writing to temp)
 *	• Spot Skew Warnings marking one distribution value.
 *	• Highlight Costly Operators by ActualRows x EstimatedCost
 *
 *	Why it matters: 
 *	Pinpoints the exact operator or data pattern causing high CPU or I/O.
********************************************************************************/


/*******************************************************************************
 * Step 5. Detect Data Skew
 * *****************************************************************************
 *	What to look for: 
 *	One NodeID/FileID with significantly more pages than others.
 *	
 *	Why it matters: 
 *	Skewed distribution overloads a single node, throttling parallelism—correcting 
 *	the distribution key can yield dramatic speedups.
********************************************************************************/
SELECT
  NodeID,
  FileID,
  TotalPageCount,
  CaptureTime
FROM Telemetry.DMV_Snapshot
WHERE PipelineRunId = '<BadRunId>';


/*******************************************************************************
 * Next Steps Considerations
 * *****************************************************************************
 *	1. Tune the slow queries identified in Step 2 (e.g. add indexes, 
 *		update stats, rewrite SQL).
 *
 *	2. Resolve skew by choosing an appropriate hash distribution key or 
 *		switching to REPLICATE for small lookup tables.
 *
 *	3. Re-run the Bronze_Load pipeline and verify improvements via the same 
 *		telemetry steps.
********************************************************************************/
