CREATE TABLE [dbo].[DOC_DOCUMENTSTATUS](
	[DocumentstatusId] int NOT NULL,
	[DocumentstatusName] nvarchar(200) NOT NULL,
	[DocumentstatusStatus] bit NOT NULL CONSTRAINT [DF__DOC_DOCUM__Docum__02284B6B]  DEFAULT 1,
	[DocumentstatusIsClosed] bit NULL,
 CONSTRAINT [PK_DOC_DOCUMENTSTATUS] PRIMARY KEY ([DocumentstatusId])
 )
