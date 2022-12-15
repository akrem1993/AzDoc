CREATE TABLE [dbo].[DOC_VIEWSTATUS](
	[ViewStatusId] int identity NOT NULL,
	[ViewStatusName] nvarchar(max) NOT NULL,
	[ViewStatusStatus] bit NOT NULL,
 CONSTRAINT [PK_DOC_VIEWSTATUS] PRIMARY KEY ([ViewStatusId])
)
