CREATE TABLE [Bronze].[SquirrelData]
( 
	[AreaName] [nvarchar](4000)  NULL,
	[AreaID] [nvarchar](4000)  NULL,
	[ParkName] [nvarchar](4000)  NULL,
	[ParkID] [nvarchar](4000)  NULL,
	[SquirrelID] [nvarchar](4000)  NULL,
	[PrimaryFurColor] [nvarchar](4000)  NULL,
	[HighlightsinFurColor] [nvarchar](4000)  NULL,
	[ColorNotes] [nvarchar](4000)  NULL,
	[Location] [nvarchar](4000)  NULL,
	[AboveGroundHeight] [nvarchar](4000)  NULL,
	[SpecificLocation] [nvarchar](4000)  NULL,
	[Activities] [nvarchar](4000)  NULL,
	[HumanInteractions] [nvarchar](4000)  NULL,
	[OtherNotesObservations] [nvarchar](4000)  NULL,
	[SquirrelLatitude] [nvarchar](4000)  NULL,
	[SquirrelLongitude] [nvarchar](4000)  NULL,
	[Date] [nvarchar](4000)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)