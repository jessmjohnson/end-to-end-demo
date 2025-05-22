/*****************************************************************************************/
/** PipelineRegistry                                                                    **/
/**     What:   A table that records each pipeline’s last start/end times, status,      **/
/**             and run count.                                                          **/
/**                                                                                     **/
/**     Why:    Provides a centralized dashboard for monitoring pipeline health,        **/
/**             alerting on failures, and tracking SLA compliance.                      **/
/*****************************************************************************************/

CREATE TABLE [Control].[PipelineRegistry]
( 
	[PipelineName] [varchar](50)  NOT NULL,
	[LastRunStart] [datetime2](7)  NULL,
	[LastRunEnd] [datetime2](7)  NULL,
	[LastStatus] [varchar](20)  NULL,
	[RunCount] [int]  NOT NULL,
	[Notes] [varchar](1000)  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [PipelineName] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
ALTER TABLE [Control].[PipelineRegistry] ADD  DEFAULT ((0)) FOR [RunCount]
GO
