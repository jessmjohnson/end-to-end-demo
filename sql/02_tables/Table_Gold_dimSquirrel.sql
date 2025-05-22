CREATE TABLE [Gold].[dimSquirrel]
( 
	[SquirrelKey] [int]  NOT NULL,
	[SquirrelID] [varchar](25)  NOT NULL,
	[PrimaryFurColor] [varchar](50)  NULL,
	[HighlightsInFur] [varchar](50)  NULL,
	[OtherNotes] [varchar](255)  NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO