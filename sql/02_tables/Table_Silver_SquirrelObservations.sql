CREATE TABLE [Silver].[SquirrelObservations]
( 
	[AreaName] [varchar](100)  NOT NULL,
	[AreaID] [char](1)  NOT NULL,
	[ParkName] [varchar](100)  NOT NULL,
	[ParkID] [int]  NOT NULL,
	[SquirrelID] [char](25)  NOT NULL,
	[PrimaryFurColor] [varchar](50)  NULL,
	[HighlightsInFurColor] [varchar](50)  NULL,
	[ColorNotes] [varchar](150)  NULL,
	[Location] [varchar](50)  NULL,
	[AboveGroundHeight] [varchar](25)  NULL,
	[SpecificLocation] [varchar](50)  NULL,
	[Activities] [varchar](50)  NULL,
	[HumanInteractions] [varchar](50)  NULL,
	[OtherNotesObservations] [varchar](255)  NULL,
	[SquirrelLatitude] [decimal](9,6)  NOT NULL,
	[SquirrelLongitude] [decimal](9,6)  NOT NULL,
	[ObservationDate] [date]  NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)