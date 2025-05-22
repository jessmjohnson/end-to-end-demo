
/****************************************************************************************
 * Script : vw_Troubleshoot_PipelineLog.sql
 * Schema : Telemetry
 * Purpose: Correlates file ingestion entries from Control.FileList with pipeline events in Telemetry.PipelineLog.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: Joins control file list data with pipeline telemetry to surface file-level pipeline run details.
 *
 * Why: Provides end-to-end visibility of file ingestion status and corresponding pipeline activities.
 *
 * Usage: Query to troubleshoot failed or long-running file loads by examining their pipeline events.
 *
 * Benefits: Quickly diagnose whether a file's status is due to pipeline failures, delays, or missing events.
 *
 * Dependencies:
 *   - Control.FileList
 *   - Telemetry.PipelineLog
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
CREATE VIEW [Telemetry].[vw_Troubleshoot_PipelineLog]
AS SELECT
  fl.FileListId,
  fl.FileName,
  fl.FileDateString,
  fl.PipelineName AS FilePipeline,
  fl.Status      AS FileStatus,
  fl.EnqueueTime,
  fl.StartTime   AS FileStartTime,
  fl.EndTime     AS FileEndTime,
  pl.PipelineName,
  pl.PipelineRunId,
  pl.EventTime,
  pl.StageName,
  pl.ActivityName,
  pl.EventType,
  pl.DurationSec,
  pl.RowsAffected,
  pl.Status      AS ActivityStatus,
  pl.Message
FROM Control.FileList AS fl
LEFT JOIN Telemetry.PipelineLog AS pl
  ON fl.FileName     = pl.StageName
 AND fl.PipelineName = pl.PipelineName;
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO