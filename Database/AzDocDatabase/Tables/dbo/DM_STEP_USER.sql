CREATE TABLE [dbo].[DM_STEP_USER](
	[StepUserId] int identity NOT NULL,
	[WorkplaceId] int NOT NULL,
	[DocTypeId] int NOT NULL,
	[DirectionTypeId] int NOT NULL,
	[Sql] nvarchar(4000) NOT NULL,
 CONSTRAINT [PK_DM_STEP_USER] PRIMARY KEY ([StepUserId]),
 CONSTRAINT [FK_DM_STEP_USER_DC_WORKPLACE] FOREIGN KEY([WorkplaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId])
)
