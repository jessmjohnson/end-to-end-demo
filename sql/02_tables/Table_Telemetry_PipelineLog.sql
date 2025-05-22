/*****************************************************************************************/
/** PipelineLog                                                                         **/
/**     What:   Records ADF pipeline and activity events (start/end), with              **/
/**             optional stage names, durations, row counts, status and messages        **/
/**                                                                                     **/
/**     Why:    Provides an execution timeline to pinpoint slow or failed activities    **/
/**             and centralizes activity telemetry data for easy querying.              **/
/*****************************************************************************************/

CREATE TABLE [Telemetry].[PipelineLog]
( 
	[PipelineRunId] [uniqueidentifier]  NOT NULL,
	[PipelineName] [varchar](128)  NOT NULL,
	[StageName] [varchar](128)  NULL,
	[ActivityName] [varchar](128)  NOT NULL,
	[EventType] [varchar](50)  NOT NULL,
	[EventTime] [datetime2](7)  NOT NULL,
	[DurationSec] [float]  NULL,
	[RowsAffected] [bigint]  NULL,
	[Status] [varchar](50)  NULL,
	[Message] [varchar](4000)  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [PipelineRunId] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO