CREATE TYPE [dms_insdoc].[UdttTask] AS TABLE(
	[TypeOfAssignment] int NOT NULL,
	[TaskNo] [decimal](18, 9) NOT NULL,
	[Task] nvarchar(max) NOT NULL,
	[TaskCycle] int NULL,
	[ExecutionPeriod] int NULL,
	[PeriodOfPerformance] int NULL,
	[OriginalExecutionDate] [datetime] NULL,
	[WhomAddressId] int NOT NULL
)