/****************************************************************************************
 * Script : vw_WorkloadOverview.sql
 * Schema : Telemetry
 * Purpose: Provides per-run resource-governor metrics overview from Telemetry.Workload_Snapshot.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: Shows per-pipeline-run snapshots of resource-governor metrics (requests and CPU usage) 
 *              for each workload group.
 *
 * Why: Resource-governor settings and workload groups determine how queries share compute resources. 
 *      Capturing those metrics lets you see bottlenecks or skew in group utilization.
 *
 * Usage: Use it to track how many requests each group ran, how many were queued, and how many CPU 
 *        milliseconds they consumed over time.
 *
 * Benefits: Visibility into resource allocation across groups, 
 *           Early detection of queue build-up (pending requests),
 *           Correlation between high CPU use and slowdowns
 *
 * Dependencies:
 *   - Telemetry.Workload_Snapshot
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
CREATE VIEW Telemetry.vw_WorkloadOverview AS
SELECT
  PipelineName,
  PipelineRunId,
  CaptureTime,
  PoolName,
  WorkloadGroupName,
  TotalRequests,
  RunningRequests,
  PendingRequests,
  ResourceMilliSeconds
FROM Telemetry.Workload_Snapshot;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO