/*****************************************************************************************/
/** FileList                                                                            **/
/**     What:   A table listing each source file with its date, target pipeline,        **/
/**             status, and processing details.                                         **/
/**                                                                                     **/
/**     Why:    Enables metadata‑driven ingestion by letting pipelines discover,        **/
/**             track, and audit file processing.                                       **/
/*****************************************************************************************/

CREATE TABLE [Control].[FileList]
( 
	[FileListId] [int]  NOT NULL,
	[FileName] [varchar](260)  NOT NULL,
	[FileDateString] [char](8)  NOT NULL,
	[PipelineName] [varchar](50)  NOT NULL,
	[Status] [varchar](20)  NOT NULL,
	[EnqueueTime] [datetime2](7)  NOT NULL,
	[StartTime] [datetime2](7)  NULL,
	[EndTime] [datetime2](7)  NULL,
	[RowsProcessed] [bigint]  NULL,
	[ErrorMessage] [varchar](2000)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
ALTER TABLE [Control].[FileList] ADD  DEFAULT ('Pending') FOR [Status]
GO