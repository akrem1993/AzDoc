CREATE TABLE [dbo].[DOC_ACTION_POSITION](
	[DocumentActionId] int identity NOT NULL,
	[PositionGroupId] int NOT NULL,
	[ExecutorReadStatus] bit NOT NULL,
	[SendStatus] int NULL,
	[NotActionTypeId] int NOT NULL,
	[IsStatus] bit NOT NULL CONSTRAINT [DF_DOC_ACTION_POSITION_IsStatus]  DEFAULT 1,
 CONSTRAINT [PK_DOC_ACTION_POSITION] PRIMARY KEY ([DocumentActionId])
)
