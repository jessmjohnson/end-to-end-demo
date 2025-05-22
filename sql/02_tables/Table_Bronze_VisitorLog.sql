CREATE TABLE [Bronze].[VisitorLog]
( 
	[VisitID] [nvarchar](4000)  NULL,
	[ParkID] [nvarchar](4000)  NULL,
	[VisitTimestamp] [nvarchar](4000)  NULL,
	[VisitorType] [nvarchar](4000)  NULL,
	[DurationMin] [nvarchar](4000)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO