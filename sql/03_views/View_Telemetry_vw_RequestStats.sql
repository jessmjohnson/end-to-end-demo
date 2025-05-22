/****************************************************************************************
 * Script : vw_RequestStats.sql
 * Schema : Telemetry
 * Purpose: Summarizes request counts and latencies from Telemetry.Requests_Snapshot.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 *
 * Description: Summarizes counts and latencies of PDW requests at each capture: total number 
 *              of active or recent requests, their average and maximum execution time.
 *
 * Why: High concurrency or long-running queries can signal contention or inefficient plans. 
 *      Having a concise request profile per snapshot helps isolate problematic windows.
 *
 * Usage: Plot TotalRequests vs. MaxElapsedMs to see if request volume spikes coincide with slow queries.
 *
 * Benefits: Quick trend analysis of workload intensity.
 *           Spotting outliers when a single request takes much longer
 *           Guidance for tuning concurrency or queue limits
 *
 * Dependencies:
 *   - Telemetry.Requests_Snapshot
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
CREATE VIEW [Telemetry].[vw_RequestStats]
AS SELECT
  PipelineName,
  PipelineRunId,
  CaptureTime,
  TotalRequests,
  AvgElapsedMs,
  MaxElapsedMs
FROM Telemetry.Requests_Snapshot;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO