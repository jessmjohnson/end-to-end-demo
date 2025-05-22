CREATE PROC [Telemetry].[usp_CaptureDMV] @PipelineRunId [UNIQUEIDENTIFIER],@PipelineName [VARCHAR](100),@CaptureTime [DATETIME2](7) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Telemetry.DMV_Snapshot
    (CaptureTime, PipelineRunId, PipelineName, NodeID, FileID,
     TotalPageCount, AllocatedExtentPageCount, UnallocatedExtentPageCount)
  SELECT
    @CaptureTime,
    @PipelineRunId,
    @PipelineName,
    pdw_node_id,
    file_id,
    total_page_count,
    allocated_extent_page_count,
    unallocated_extent_page_count
  FROM sys.dm_pdw_nodes_db_file_space_usage;
END;
GO