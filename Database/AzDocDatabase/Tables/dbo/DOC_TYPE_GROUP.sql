CREATE TABLE [dbo].[DOC_TYPE_GROUP](
	[DocTypeGroupId] int identity NOT NULL,
	[SchemaId] int NOT NULL,
	[DocTypeGroupName] nvarchar(250) NOT NULL,
	[DocTypeGroupOrderIndex] [tinyint] NULL,
	[DocTypeGroupStatus] bit NOT NULL CONSTRAINT [DF_DOC_TYPE_GROUP_DocTypeGroupStatus]  DEFAULT 1,
    CONSTRAINT [PK_DOC_TYPE_GROUP] PRIMARY KEY ([DocTypeGroupId]),
    CONSTRAINT [FK_DOC_TYPE_GROUP_DM_SCHEMA] FOREIGN KEY([SchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId])
)
