/*****************************************************************************************/
/** Requests_Snapshot                                                                   **/
/**     What:   Captures summary metrics of in-flight requests (total count, average    **/
/**             and max execution time).                                                **/
/**                                                                                     **/
/**     Why:    Tracks concurrency and request-duration trends over time, helping       **/
/**             identify spikes in workload or runaway queries.                         **/
/*****************************************************************************************/


CREATE TABLE [Telemetry].[Requests_Snapshot]
( 
	[CaptureTime] [datetime2](7)  NOT NULL,
	[PipelineRunId] [uniqueidentifier]  NOT NULL,
	[PipelineName] [varchar](75)  NOT NULL,
	[TotalRequests] [bigint]  NULL,
	[AvgElapsedMs] [float]  NULL,
	[MaxElapsedMs] [float]  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO