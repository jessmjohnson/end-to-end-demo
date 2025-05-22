CREATE PROC [Telemetry].[usp_CaptureRequestsSnapshot] @PipelineRunId [UNIQUEIDENTIFIER],@PipelineName [VARCHAR](75),@CaptureTime [DATETIME2] AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO Telemetry.Requests_Snapshot
    (CaptureTime, PipelineRunId, PipelineName, TotalRequests, AvgElapsedMs, MaxElapsedMs)
  SELECT
    @CaptureTime,
    @PipelineRunId,
    @PipelineName,
  COUNT_BIG(*) AS TotalRequests,
    AVG(CAST(total_elapsed_time AS FLOAT) / 1000.0) AS AvgElapsedMs,
    MAX(CAST(total_elapsed_time AS FLOAT) / 1000.0) AS MaxElapsedMs
  FROM sys.dm_pdw_exec_requests    -- correct DMV for Dedicated SQL Pools :contentReference[oaicite:0]{index=0}
  WHERE 
    status IN ('Running','Suspended','Pending')
    OR (status = 'Completed' 
        AND start_time >= DATEADD(MINUTE, -1, @CaptureTime));
END;
GO