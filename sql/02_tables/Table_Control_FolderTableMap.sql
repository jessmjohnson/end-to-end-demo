
CREATE TABLE [Control].[FolderTableMap]
( 
	[FolderName] [varchar](50)  NOT NULL,
	[TableName] [varchar](50)  NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [FolderName] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO