CREATE PROC [Telemetry].[usp_CaptureWorkload] @PipelineName [VARCHAR](75),@PipelineRunId [VARCHAR](50),@CaptureTime [DATETIME2] AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO Telemetry.Workload_Snapshot
    (PipelineName,
     PipelineRunId,
     CaptureTime,
     PoolName,
     WorkloadGroupName,
     TotalRequests,
     RunningRequests,
     PendingRequests,
     ResourceMilliSeconds)
  SELECT
    @PipelineName,
    @PipelineRunId,
    @CaptureTime,
    rp.name                                 AS PoolName,  
    wg.name                                 AS WorkloadGroupName,
    wg.total_request_count                  AS TotalRequests,           -- cumulative completed requests 
    wg.active_request_count                 AS RunningRequests,         -- current active requests 
    wg.total_queued_request_count           AS PendingRequests,         -- requests queued by GROUP_MAX_REQUESTS 
    rp.total_cpu_usage_ms                   AS ResourceMilliSeconds     -- CPU ms used by this pool
  FROM sys.dm_pdw_nodes_resource_governor_workload_groups AS wg  -- workload group stats :contentReference[oaicite:0]{index=0}
  JOIN sys.dm_pdw_nodes_resource_governor_resource_pools   AS rp  -- resource pool stats :contentReference[oaicite:1]{index=1}
    ON wg.pool_id = rp.pool_id;
END;
GO