CREATE TABLE [dbo].[DOC_SENDSTATUS](
	[SendStatusId] int NOT NULL,
	[SendStatusName] nvarchar(50) NOT NULL,
	[SendStatusStatus] bit NOT NULL,
 CONSTRAINT [PK_DOC_SENDSTATUS] PRIMARY KEY ([SendStatusId])
)
