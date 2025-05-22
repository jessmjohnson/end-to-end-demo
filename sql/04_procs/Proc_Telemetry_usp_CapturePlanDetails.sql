CREATE PROC [Telemetry].[usp_CapturePlanDetails] @PipelineRunId [UNIQUEIDENTIFIER],@PipelineName [VARCHAR](100),@CaptureTime [DATETIME2](7) AS
BEGIN
  SET NOCOUNT ON;

  -- no CaptureSettings table, so capture all plans
  DECLARE @minElapsedMs BIGINT = 0;

  INSERT INTO Telemetry.PlanDetails
    (PipelineName, PipelineRunId, CaptureTime, QueryId, PlanId, PlanXml)
  SELECT
    @PipelineName,
    @PipelineRunId,
    @CaptureTime,
    q.query_id,
    p.plan_id,
    p.query_plan
  FROM sys.query_store_runtime_stats AS rs
  JOIN sys.query_store_plan           AS p
    ON rs.plan_id  = p.plan_id
  JOIN sys.query_store_query          AS q
    ON p.query_id = q.query_id
  WHERE rs.max_duration > @minElapsedMs;
END;
GO