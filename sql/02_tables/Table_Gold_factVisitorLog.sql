CREATE TABLE [Gold].[factVisitorLog]
( 
	[VisitLogKey] [bigint]  NOT NULL,
	[DateKey] [int]  NOT NULL,
	[ParkKey] [int]  NOT NULL,
	[VisitorTypeKey] [int]  NOT NULL,
	[DurationMin] [int]  NULL,
	[RowsProcessed] [bigint]  NULL
)
WITH
(
	DISTRIBUTION = HASH ( [DateKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO