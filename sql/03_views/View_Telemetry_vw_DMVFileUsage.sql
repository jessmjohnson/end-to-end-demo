/****************************************************************************************
 * Script : vw_DMVFileUsage.sql
 * Schema : Telemetry
 * Purpose: Surfaces per-node, per-file page-counts from Telemetry.DMV_Snapshot.
 * Author : Jess Johnson
 * Created: 2025-05-22
 * Version: 1.0
 *
 * Description: Provides storage-usage metrics (total, allocated, unallocated pages)
 *              so you can detect data-distribution skew across MPP nodes.
 *
 * Why: Data skew is the most common cause of single-node bottlenecks. Spotting a node
 *      owning a disproportionate share of pages tells you when to repartition.
 *
 * Usage: 
 *   SELECT * 
 *     FROM Telemetry.vw_DMVFileUsage
 *    WHERE CaptureTime > DATEADD(HOUR, -1, SYSUTCDATETIME());
 *
 * Benefits:
 *   • Quickly identifies skew without hand-crafting DMV queries
 *   • Simplifies ad-hoc investigations and dashboards
 *   • Provides consistent column ordering and naming
 *
 * Dependencies:
 *   - Telemetry.DMV_Snapshot
 *
 * Change History:
 * 2025-05-22 JJ-1.0 Initial creation
 ****************************************************************************************/

-- ======================================================================================
-- SECTION 1: Declarations
-- ======================================================================================
-- No parameters required.

-- ======================================================================================
-- SECTION 2: Main logic
-- ======================================================================================
CREATE OR ALTER VIEW Telemetry.vw_DMVFileUsage AS
SELECT
  PipelineRunId,
  CaptureTime,
  NodeID,
  FileID,
  TotalPageCount,
  AllocatedExtentPageCount,
  UnallocatedExtentPageCount
FROM Telemetry.DMV_Snapshot;
GO