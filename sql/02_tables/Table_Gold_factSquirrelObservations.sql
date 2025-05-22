CREATE TABLE [Gold].[factSquirrelObservations]
( 
	[ObservationKey] [bigint]  NOT NULL,
	[DateKey] [int]  NOT NULL,
	[ParkKey] [int]  NOT NULL,
	[SquirrelKey] [int]  NOT NULL,
	[VisitLogKey] [bigint]  NULL,
	[AboveGroundHeight] [int]  NULL,
	[SquirrelLatitude] [decimal](9,6)  NULL,
	[SquirrelLongitude] [decimal](9,6)  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [DateKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO