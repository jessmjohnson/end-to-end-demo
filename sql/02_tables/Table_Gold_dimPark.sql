CREATE TABLE [Gold].[dimPark]
( 
	[ParkKey] [int]  NOT NULL,
	[ParkID] [int]  NOT NULL,
	[ParkName] [varchar](100)  NOT NULL,
	[AreaID] [varchar](10)  NULL,
	[AreaName] [varchar](100)  NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO