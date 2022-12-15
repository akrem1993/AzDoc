CREATE TABLE [dbo].[DC_TREE](
	[TreeId] int identity NOT NULL,
	[TreeSchemaId] int NOT NULL,
	[TreeDocTypeId] int NOT NULL,
	[TreeDocTypeGroupId] int NOT NULL,
	[TreeTreeName] nvarchar(100) NOT NULL,
	[TreeOrderIndex] int NULL,
 CONSTRAINT [PK_DC_TREE] PRIMARY KEY ([TreeId]),
 CONSTRAINT [FK_DC_TREE_DM_SCHEMA] FOREIGN KEY([TreeSchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId]),
 CONSTRAINT [FK_DC_TREE_DOC_TYPE] FOREIGN KEY([TreeDocTypeId]) REFERENCES [dbo].[DOC_TYPE] ([DocTypeId]),
 CONSTRAINT [FK_DC_TREE_DOC_TYPE_GROUP] FOREIGN KEY([TreeDocTypeGroupId]) REFERENCES [dbo].[DOC_TYPE_GROUP] ([DocTypeGroupId]),
 CONSTRAINT [FK_DC_TREE_TREEDOCTYPEGROUPID] FOREIGN KEY([TreeDocTypeGroupId]) REFERENCES [dbo].[DOC_TYPE_GROUP] ([DocTypeGroupId])
 )
