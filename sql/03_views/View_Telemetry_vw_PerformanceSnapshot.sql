/****************************************************************************************
 * Script : vw_PerformanceSnapshot.sql
 * Schema : Telemetry
 * Purpose: Consolidates key performance metrics into a single snapshot view.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: A consolidated “wide” view combining key metrics—resource-governor, 
 *              request counts, slowest query, and CPU ms—into a single row per run-time slice.
 *
 * Why: Executives and engineers alike need a one-screen summary. This view surfaces multiple 
 *      dimensions of performance in one place.
 *
 * Usage: Feed it into Power BI for dashboard tiles: request volume, CPU usage, and top query time.
 *
 * Benefits: Single pane of glass for performance health checks,
 *           Eases SLA reporting by aggregating metrics,
 *           Facilitates trend analysis across pipeline runs
 *
 * Dependencies:
 *   - Telemetry.Workload_Snapshot
 *   - Telemetry.Requests_Snapshot
 *   - Telemetry.QS_Snapshot
 *
 * Change History:
 * 2025-05-19 JJ-1.0 Initial creation
 ****************************************************************************************/

-- ======================================================================================
-- SECTION 1: Declarations
-- ======================================================================================
-- No parameters required.

-- ======================================================================================
-- SECTION 2: Main logic
-- ======================================================================================
CREATE VIEW [Telemetry].[vw_PerformanceSnapshot]
AS SELECT
  W.PipelineName,
  W.PipelineRunId,
  W.CaptureTime,
  W.PoolName,
  W.WorkloadGroupName,
  W.RunningRequests,
  R.TotalRequests,
  R.AvgElapsedMs       AS RequestAvgMs,
  Q.MaxDuration        AS SlowestQueryUs,
  W.ResourceMilliSeconds
FROM Telemetry.vw_WorkloadOverview AS W
LEFT JOIN Telemetry.vw_RequestStats      AS R
  ON W.PipelineRunId = R.PipelineRunId
 AND W.CaptureTime   = R.CaptureTime
LEFT JOIN (
  SELECT PipelineRunId, CaptureTime, MaxDuration
  FROM Telemetry.vw_QS_TopSlowQueries
  WHERE RankByMaxDuration = 1
) AS Q
  ON W.PipelineRunId = Q.PipelineRunId
 AND W.CaptureTime   = Q.CaptureTime;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO