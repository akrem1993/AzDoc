CREATE TABLE [dbo].[DOC_TYPE](
	[DocTypeId] int identity NOT NULL,
	[DocTypeName] nvarchar(250) NOT NULL,
	[DocPeriodId] int NULL,
	[DocTypeOrderIndex] [tinyint] NULL,
	[DocPeriodStatus] bit NOT NULL CONSTRAINT [DF_DOC_TYPE_DocPeriodStatus]  DEFAULT  1,
 CONSTRAINT [PK_DOC_TYPE] PRIMARY KEY ([DocTypeId])
)
