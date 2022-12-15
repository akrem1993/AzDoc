CREATE TABLE [dbo].[DOC_TASK_CYCLE](
	[TaskCycleId] int identity NOT NULL,
	[TaskCycleName] nvarchar(50) NOT NULL,
	[TaskCycleStatus] bit NOT NULL,
	[DocTypeId] int NOT NULL,
 CONSTRAINT [PK_DOC_TASK_CYCLE] PRIMARY KEY ([TaskCycleId])
)