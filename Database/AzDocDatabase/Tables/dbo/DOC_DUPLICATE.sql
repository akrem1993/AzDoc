CREATE TABLE [dbo].[DOC_DUPLICATE](
	[DuplicateId] int identity NOT NULL,
	[DuplicateName] nvarchar(200) NOT NULL,
	[DuplicateStatus] bit NOT NULL CONSTRAINT [DF__DOC_DUPLI__Dupli__7C6F7215]  DEFAULT 1,
 CONSTRAINT [PK_DOC_DUPLICATE] PRIMARY KEY ([DuplicateId])
)