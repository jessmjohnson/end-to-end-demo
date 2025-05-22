CREATE TABLE [Bronze].[ParkData]
( 
	[AreaName] [nvarchar](4000)  NULL,
	[AreaID] [nvarchar](4000)  NULL,
	[ParkName] [nvarchar](4000)  NULL,
	[ParkID] [nvarchar](4000)  NULL,
	[Date] [nvarchar](4000)  NULL,
	[StartTime] [nvarchar](4000)  NULL,
	[EndTime] [nvarchar](4000)  NULL,
	[TotalTime] [nvarchar](4000)  NULL,
	[ParkConditions] [nvarchar](4000)  NULL,
	[OtherAnimalSightings] [nvarchar](4000)  NULL,
	[Litter] [nvarchar](4000)  NULL,
	[TemperatureWeather] [nvarchar](4000)  NULL,
	[NumberSquirrels] [nvarchar](4000)  NULL,
	[SquirrelSighters] [nvarchar](4000)  NULL,
	[NumberSighters] [nvarchar](4000)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)