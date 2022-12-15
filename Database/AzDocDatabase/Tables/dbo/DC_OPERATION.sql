CREATE TABLE [dbo].[DC_OPERATION](
	[OperationId] int identity NOT NULL,
	[OperationName] nvarchar(250) NOT NULL,
	[OperationTypeId] int NOT NULL,
	[OperationApplicationId] int NOT NULL,
	[OperationParameter] nvarchar(200) NULL,
	[OperationSchemaId] int NULL,
	[OperationStatus] bit NOT NULL CONSTRAINT [DF_DC_OPERATION_OperationStatus]  DEFAULT 1,
	CONSTRAINT [PK_DC_OPERATION] PRIMARY KEY ([OperationId]),
	CONSTRAINT [FK_DC_OPERATION_DC_APPLICATION] FOREIGN KEY([OperationApplicationId]) REFERENCES [dbo].[DC_APPLICATION] ([ApplicationId]),
	CONSTRAINT [FK_DC_OPERATION_DC_OPERATIONTYPE] FOREIGN KEY([OperationTypeId]) REFERENCES [dbo].[DC_OPERATIONTYPE] ([OperationtypeId]),
	CONSTRAINT [FK_DC_OPERATION_DM_SCHEMA] FOREIGN KEY([OperationSchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId])
 )
