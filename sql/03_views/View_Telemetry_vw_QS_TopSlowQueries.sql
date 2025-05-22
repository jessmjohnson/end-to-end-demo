/****************************************************************************************
 * Script : vw_QS_TopSlowQueries.sql
 * Schema : Telemetry
 * Purpose: Ranks top slow queries per pipeline run based on maximum duration from Telemetry.QS_Snapshot.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: Ranks captured Query-Store entries by their maximum duration per snapshot, letting you identify 
 *      the slowest queries.
 *
 * Why: Query Store holds runtime stats for every query and plan. Pinpointing the top-N slowest queries 
 *        directs your optimization efforts where they’ll have the greatest impact.
 *
 * Usage: Inspect QueryIds and PlanIds to drill into execution plans or rewrite SQL.
 *
 * Benefits: Targets the real performance hotspots, not just the most frequent queries,
 *           Prioritizes tuning efforts on queries that cost the most time,
 *           Feeds into alerting (e.g. alert if any query exceeds X ms)
 *
 * Dependencies:
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
CREATE VIEW [Telemetry].[vw_QS_TopSlowQueries]
AS SELECT
  PipelineName,
  PipelineRunId,
  CaptureTime,
  QueryId,
  PlanId,
  CountExecutions,
  AvgDuration,
  MaxDuration,
  ROW_NUMBER() OVER (
    PARTITION BY PipelineRunId, CaptureTime
    ORDER BY MaxDuration DESC
  ) AS RankByMaxDuration
FROM Telemetry.QS_Snapshot;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO