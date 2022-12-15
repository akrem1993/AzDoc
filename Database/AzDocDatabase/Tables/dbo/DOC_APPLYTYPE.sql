CREATE TABLE [dbo].[DOC_APPLYTYPE](
	[ApplytypeId] int identity NOT NULL,
	[ApplytypeName] nvarchar(200) NOT NULL,
	[ApplytypeStatus] bit NOT NULL CONSTRAINT [DF__DOC_APPLY__Apply__7F4BDEC0]  DEFAULT 1,
 CONSTRAINT [PK_DOC_APPLYTYPE] PRIMARY KEY ([ApplytypeId])
)