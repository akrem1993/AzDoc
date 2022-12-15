CREATE TABLE [dbo].[DM_SCHEMA](
	[SchemaId] int NOT NULL,
	[SchemaName] nvarchar(250) NOT NULL,
	[SchemaDescription] nvarchar(250) NULL,
 CONSTRAINT [PK_DM_SCHEMA] PRIMARY KEY ([SchemaId])
)
