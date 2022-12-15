CREATE TABLE [dbo].[DM_STEP](
	[StepId] int identity NOT NULL,
	[DocTypeId] int NOT NULL,
	[PositionGroupId] int NOT NULL,
	[NextPositionGroupId] int NOT NULL,
	[DirectionTypeId] int NOT NULL,
	[ActionId] int NULL,
	[StepOrderIndex] int NULL,
    CONSTRAINT [PK_DM_STEP] PRIMARY KEY ([StepId]),
    CONSTRAINT [FK_DM_STEP_DC_POSITION_GROUP] FOREIGN KEY([PositionGroupId]) REFERENCES [dbo].[DC_POSITION_GROUP] ([PositionGroupId]),
    CONSTRAINT [FK_DM_STEP_DC_POSITION_GROUP1] FOREIGN KEY([NextPositionGroupId]) REFERENCES [dbo].[DC_POSITION_GROUP] ([PositionGroupId]),
    CONSTRAINT [FK_DM_STEP_DM_ACTION] FOREIGN KEY([ActionId]) REFERENCES [dbo].[DM_ACTION] ([ActionId]),
    CONSTRAINT [FK_DM_STEP_DOC_TYPE] FOREIGN KEY([DocTypeId]) REFERENCES [dbo].[DOC_TYPE] ([DocTypeId])
 )
