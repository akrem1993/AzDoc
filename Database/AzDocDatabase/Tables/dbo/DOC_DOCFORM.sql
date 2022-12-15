CREATE TABLE [dbo].[DOC_DOCFORM](
	[DocformId] int identity NOT NULL,
	[DocformName] nvarchar(50) NOT NULL,
	[DocformStatus] bit NOT NULL CONSTRAINT [DF__DOC_DOCFO__Docfo__74CE504D]  DEFAULT 1,
 CONSTRAINT [PK_DOC_DOCFORM] PRIMARY KEY ([DocformId])
)
