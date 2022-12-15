CREATE TABLE [dbo].[DOCS_EDIT_WORKPLACE](
	[DocsEditId] int identity NOT NULL,
	[WorkPlaceId] int NOT NULL,
	[DocId] int NOT NULL,
	[IsStatus] bit NOT NULL  CONSTRAINT [DF_DOCS_EDIT_WORKPLACE_IsStatus]  DEFAULT 1,
    CONSTRAINT [PK_DOCS_EDIT_WORKPLACE] PRIMARY KEY ([DocsEditId])
)
