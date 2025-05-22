CREATE TABLE [Gold].[dimVisitorType]
( 
	[VisitorTypeKey] [int]  NOT NULL,
	[VisitorType] [varchar](25)  NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO