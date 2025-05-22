/****************************************************************************************
 * Script : vw_PlanDetailsEnriched.sql
 * Schema : Telemetry
 * Purpose: Correlates captured plan XML with runtime stats for deeper analysis.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: Joins plan XML from PlanDetails with runtime stats from QS_Snapshot, giving 
 *              you the full execution plan alongside execution metrics.
 *
 * Why: Seeing a plan in isolation or stats in isolation isn’t enough—you need both side by 
 *      side to understand why a plan behaves poorly.
 *
 * Usage: Open the PlanXml in a plan viewer, compare its operators and warnings against 
 *        the captured durations and I/O.
 *
 * Benefits: Holistic view of plan shape and performance metrics,
 *           Speeds up root-cause analysis when tuning slow queries,
 *           Enables regression checks (detect plan changes that increased durations)
 *
 * Dependencies:
 *   - Telemetry.PlanDetails
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
CREATE VIEW [Telemetry].[vw_PlanDetailsEnriched]
AS SELECT
  PD.PipelineName,
  PD.PipelineRunId,
  PD.CaptureTime,
  PD.QueryId,
  PD.PlanId,
  PD.PlanXml,
  QS.CountExecutions,
  QS.AvgDuration,
  QS.MaxDuration
FROM Telemetry.PlanDetails AS PD
JOIN Telemetry.QS_Snapshot AS QS
  ON PD.CaptureTime = QS.CaptureTime
 AND PD.QueryId    = QS.QueryId
 AND PD.PlanId     = QS.PlanId;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO