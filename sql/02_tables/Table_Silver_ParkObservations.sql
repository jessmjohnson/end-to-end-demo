
CREATE TABLE [Silver].[ParkObservations]
( 
	[AreaName] [varchar](50)  NOT NULL,
	[AreaID] [char](1)  NOT NULL,
	[ParkName] [varchar](50)  NOT NULL,
	[ParkID] [int]  NOT NULL,
	[ObservationDate] [date]  NOT NULL,
	[ObservationStartTime] [time](0)  NOT NULL,
	[ObservationEndTime] [time](0)  NOT NULL,
	[TotalTime] [int]  NOT NULL,
	[ParkConditions] [varchar](100)  NULL,
	[OtherAnimalSightings] [varchar](100)  NULL,
	[Litter] [varchar](100)  NULL,
	[TemperatureWeather] [varchar](50)  NULL,
	[NumberSquirrels] [int]  NOT NULL,
	[SquirrelSighters] [varchar](100)  NOT NULL,
	[NumberSighters] [int]  NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ParkID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO