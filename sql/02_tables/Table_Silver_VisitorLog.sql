CREATE TABLE [Silver].[VisitorLog]
( 
	[VisitID] [int]  NOT NULL,
	[ParkID] [int]  NOT NULL,
	[VisitTimestamp] [datetime2](0)  NOT NULL,
	[VisitorType] [varchar](25)  NOT NULL,
	[DurationMin] [int]  NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO