/*****************************************************************************************/
/** Workload_Snapshot                                                                   **/
/**     What:   Captures workload‑group metrics: total, running, pending requests and   **/
/**             resource milliseconds.                                                  **/
/**                                                                                     **/
/**     Why:    Reveals queueing or throttling in resource‑governed pools. Tracks pool  **/
/**             health and contention over time.                                        **/
/*****************************************************************************************/

-------------------------------------------------------------------------------------------
--  Table Design: Telemetry.Workload_Snapshot 
-------------------------------------------------------------------------------------------

CREATE TABLE [Telemetry].[Workload_Snapshot]
( 
	[PipelineName] [varchar](75)  NULL,
	[PipelineRunId] [uniqueidentifier]  NOT NULL,
	[CaptureTime] [datetime2](7)  NOT NULL,
	[PoolName] [sysname](nvarchar(128))  NOT NULL,
	[WorkloadGroupName] [sysname](nvarchar(128))  NOT NULL,
	[TotalRequests] [bigint]  NULL,
	[RunningRequests] [bigint]  NULL,
	[PendingRequests] [bigint]  NULL,
	[ResourceMilliSeconds] [bigint]  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [PoolName] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO