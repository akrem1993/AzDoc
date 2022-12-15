CREATE TABLE [dbo].[DOC_DOCUMENT_TYPE](
	[DocumentTypeId] int identity NOT NULL,
	[DocumentTypeName] nvarchar(max) NULL,
	[DocumentTypeStatus] bit NULL,
 CONSTRAINT [PK_DOC_DOCUMENT_TYPE] PRIMARY KEY ([DocumentTypeId])
)