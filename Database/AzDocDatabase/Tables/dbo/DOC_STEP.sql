CREATE TABLE [dbo].[DOC_STEP](
	[DocStepId] int identity NOT NULL,
	[SchemaId] int NOT NULL,
	[PositionGroupId] int NULL,
	[WorkplaceId] int NULL,
	[DocumentStatusId] int NOT NULL,
	[OperationId] int NOT NULL,
	[NextPositionGroupId] int NULL,
    CONSTRAINT [PK_DOC_STEP] PRIMARY KEY ([DocStepId]),
    CONSTRAINT [FK_DOC_STEP_DC_POSITION_GROUP] FOREIGN KEY([PositionGroupId]) REFERENCES [dbo].[DC_POSITION_GROUP] ([PositionGroupId]),
    CONSTRAINT [FK_DOC_STEP_DC_POSITION_GROUP1] FOREIGN KEY([NextPositionGroupId]) REFERENCES [dbo].[DC_POSITION_GROUP] ([PositionGroupId]),
    CONSTRAINT [FK_DOC_STEP_DC_WORKPLACE] FOREIGN KEY([WorkplaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId]),
    CONSTRAINT [FK_DOC_STEP_DM_SCHEMA] FOREIGN KEY([SchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId]),
    CONSTRAINT [FK_DOC_STEP_DOC_DOCUMENTSTATUS] FOREIGN KEY([DocumentStatusId]) REFERENCES [dbo].[DOC_DOCUMENTSTATUS] ([DocumentstatusId]),
    CONSTRAINT [FK_DOC_STEP_DOC_OPERATION] FOREIGN KEY([OperationId]) REFERENCES [dbo].[DOC_OPERATION] ([DocOperationId])
 )
