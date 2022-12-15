CREATE TABLE [dbo].[DOC_RECEIVED_FORM](
	[ReceivedFormId] int identity NOT NULL,
	[ReceivedFormName] nvarchar(50) NOT NULL,
	[ReceivedFormStatus] bit NOT NULL CONSTRAINT [DF_DOC_RECEIVED_FORM_ReceivedFormStatus]  DEFAULT 1,
	[ParentId] int NULL,
	[OrganizationId] int NULL,
 CONSTRAINT [PK_DOC_RECEIVED_FORM] PRIMARY KEY ([ReceivedFormId])
)