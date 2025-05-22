/*****************************************************************************************/
/** QS_Snapshot                                                                         **/
/**     What:   Stores runtime statistics from Query Store: execution counts, elapsed   **/
/**             time, logical reads/writes.                                             **/
/**                                                                                     **/
/**     Why:    Enables historical performance analysis and regression detection.       **/
/**             Allows for the automating of building time series of query performance  **/
/**             metrics.                                                                **/
/*****************************************************************************************/

CREATE TABLE [Telemetry].[QS_Snapshot]
( 
	[PipelineName] [varchar](100)  NULL,
	[PipelineRunId] [uniqueidentifier]  NOT NULL,
	[CaptureTime] [datetime2](7)  NOT NULL,
	[QueryId] [bigint]  NOT NULL,
	[PlanId] [bigint]  NOT NULL,
	[CountExecutions] [bigint]  NULL,
	[AvgDuration] [bigint]  NULL,
	[LastDuration] [bigint]  NULL,
	[MinDuration] [bigint]  NULL,
	[MaxDuration] [bigint]  NULL,
	[AvgLogicalIoReads] [bigint]  NULL,
	[LastLogicalIoReads] [bigint]  NULL,
	[AvgLogicalIoWrites] [bigint]  NULL,
	[LastLogicalIoWrites] [bigint]  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [QueryId] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO