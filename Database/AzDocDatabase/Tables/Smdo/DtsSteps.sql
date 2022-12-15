CREATE TABLE [smdo].[DtsSteps](
	[Id] int identity NOT NULL,
	[DocId] int NULL,
	[StepId] int NULL,
	[StepStatus] bit NULL,
	[StepDescription] nvarchar(max) NULL
)