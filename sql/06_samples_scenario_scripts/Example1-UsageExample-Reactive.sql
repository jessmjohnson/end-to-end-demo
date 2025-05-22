/*
* Use the telemetry tables and views to 
* drill into a slow pipeline run and pinpointing the pieces of work 
* that could have drove up latency
*/

-- 1. Identity the run with the highest MaxElapsedMs
SELECT TOP 1
  PipelineRunId, -- identify the pipeline where some query took unusually long
  CaptureTime,	 -- identify the approximate runtime window
  AvgElapsedMs,
  MaxElapsedMs
FROM Telemetry.Requests_Snapshot
WHERE PipelineName = 'Bronze_Load'
ORDER BY MaxElapsedMs DESC;

-- 2. Identify the Top Slowest Queries of that Run and Window of execution
--	  these queries are responsible for most of the elapsed time in that run.
SELECT TOP 5
  CaptureTime,
  QueryId,		-- identify a few (2 or 3) QueryIds whose MaxDuration dwarfs the others
  PlanId,
  CountExecutions,
  AvgDuration,
  MaxDuration
FROM Telemetry.QS_Snapshot
WHERE PipelineRunId = '97375A0C-2013-4575-8890-0BC3DF3136CF' --@BadRunId
AND CaptureTime LIKE '2025-05-19 14:13%'	--@BadCaptureTime
ORDER BY MaxDuration DESC;

-- 3. Get SQL Text & Execution Plan for the query.
--	  plan-level insight is the only way to know why a QueryId consumed so much time.
SELECT
  qt.query_sql_text AS SqlText,
  p.query_plan      AS PlanXml
FROM Telemetry.QS_Snapshot AS qs
INNER JOIN sys.query_store_plan  AS p
  ON qs.PlanId = p.plan_id
INNER JOIN sys.query_store_query AS q
  ON p.query_id = q.query_id
INNER JOIN sys.query_store_query_text AS qt
  ON q.query_text_id = qt.query_text_id
WHERE qs.PipelineRunId = '97375A0C-2013-4575-8890-0BC3DF3136CF' --@BadRunId
  AND qs.QueryId       =  79 --@TopQueryId; 159, 10, 19

-- 4. Investigate Plan for hot operators (use plan explorer)
	-- Table/Index Scans when a seek should occur.
	-- Hash Spills or Sort Spills (warning icons).
	-- Skew Warnings listing a single distribution value.
	-- Operators with the highest ActualRows × EstimatedCost.
	-- the node or operator in the plan consuming the most I/O or CPU.

-- 5. Look for Data-Skew, one NodeID/FileID with a disproportionate page count
--	  the table’s distribution key may be funneling too much data to a single node, 
--	  slowing that node’s queries
SELECT
  NodeID,
  FileID,
  TotalPageCount,
  CaptureTime
FROM Telemetry.DMV_Snapshot
WHERE 
	PipelineRunId = '97375A0C-2013-4575-8890-0BC3DF3136CF' --@BadRunId
	--AND CaptureTime LIKE '2025-05-19 14:%' --@BadCaptureTime;
  

