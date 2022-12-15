CREATE TABLE [dbo].[DOC_TASK](
	[TaskId] int identity NOT NULL,
	[TaskDocNo] nvarchar(20) NULL,
	[TaskDocId] int NOT NULL,
	[TypeOfAssignmentId] int NOT NULL,
	[TaskNo] [decimal](18, 1) NULL,
	[TaskDecription] nvarchar(max) NULL,
	[TaskCycleId] int NULL,
	[ExecutionPeriod] int NULL,
	[PeriodOfPerformance] int NULL,
	[OriginalExecutionDate] [date] NULL,
	[WhomAddressId] int NOT NULL,
	[OrganizationId] int NOT NULL,
	[TaskStatus] int NOT NULL,
	[TaskCreateWorkPlaceId] int NOT NULL,
	[TaskCreateDate] [datetime] NOT NULL
)