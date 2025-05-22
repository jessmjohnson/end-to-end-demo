CREATE TABLE [Telemetry].[DMV_Snapshot]
( 
	[CaptureTime] [datetime2](7)  NOT NULL,
	[PipelineRunId] [uniqueidentifier]  NOT NULL,
	[PipelineName] [varchar](100)  NOT NULL,
	[NodeID] [int]  NOT NULL,
	[FileID] [smallint]  NOT NULL,
	[TotalPageCount] [bigint]  NULL,
	[AllocatedExtentPageCount] [bigint]  NULL,
	[UnallocatedExtentPageCount] [bigint]  NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)