CREATE PROC [Telemetry].[usp_CaptureQS] @PipelineRunId [UNIQUEIDENTIFIER],@PipelineName [VARCHAR](100),@CaptureTime [DATETIME2](7) AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO Telemetry.QS_Snapshot
    (PipelineName, PipelineRunId, CaptureTime,
     QueryId, PlanId,
     CountExecutions,
     AvgDuration, LastDuration, MinDuration, MaxDuration,
     AvgLogicalIoReads, LastLogicalIoReads,
     AvgLogicalIoWrites, LastLogicalIoWrites
    )
  SELECT
    @PipelineName,
    @PipelineRunId,
    @CaptureTime,
    
    q.query_id,
    p.plan_id,

    rs.count_executions,
    rs.avg_duration,
    rs.last_duration,
    rs.min_duration,
    rs.max_duration,

    rs.avg_logical_io_reads,
    rs.last_logical_io_reads,
    rs.avg_logical_io_writes,
    rs.last_logical_io_writes
  FROM sys.query_store_runtime_stats AS rs
  JOIN sys.query_store_plan          AS p
    ON rs.plan_id  = p.plan_id
  JOIN sys.query_store_query         AS q
    ON p.query_id = q.query_id
  WHERE rs.count_executions > 0;
END;
GO