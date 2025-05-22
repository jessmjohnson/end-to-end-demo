CREATE TABLE [Gold].[dimDate]
( 
	[DateKey] [int]  NOT NULL,
	[FullDate] [date]  NOT NULL,
	[DayOfWeek] [int]  NOT NULL,
	[DayName] [varchar](20)  NOT NULL,
	[DayOfMonth] [int]  NOT NULL,
	[DayOfYear] [int]  NOT NULL,
	[WeekOfYear] [int]  NOT NULL,
	[MonthOfYear] [int]  NOT NULL,
	[MonthName] [varchar](20)  NOT NULL,
	[Quarter] [int]  NOT NULL,
	[QuarterName] [varchar](5)  NOT NULL,
	[Year] [int]  NOT NULL,
	[IsWeekend] [bit]  NOT NULL
)
WITH
(
	DISTRIBUTION =HASH(DateKey),
	HEAP
)
GO