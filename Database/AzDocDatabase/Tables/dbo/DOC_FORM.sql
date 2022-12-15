CREATE TABLE [dbo].[DOC_FORM](
	[FormId] int identity NOT NULL,
	[FormName] nvarchar(250) NULL,
	[FormStatus] bit NOT NULL CONSTRAINT [DF__DOC_FORM__FormSt__77AABCF8]  DEFAULT 1,
	[FormIndex] nvarchar(10) NULL,
 CONSTRAINT [PK_DOC_FORM] PRIMARY KEY ([FormId])
)
