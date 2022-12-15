CREATE TABLE [dbo].[DOC_ADRTYPE](
	[AdrTypeId] int identity NOT NULL,
	[AdrTypeName] nvarchar(250) NULL,
 CONSTRAINT [PK_DOCS_ADRTYPE] PRIMARY KEY ([AdrTypeId])
)