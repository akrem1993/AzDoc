CREATE TABLE [dbo].[DOC_DOCUMENTSTATUS_DOCTYPE](
	[DocumentStatusDocTypeId] int identity NOT NULL,
	[DocTypeId] int NOT NULL,
	[DocumentStatusId] int NOT NULL,
	[SchemaId] int NOT NULL,
	[DocumentStatusDocTypeOrderIndex] int NOT NULL,
	[DocumentStatusDocTypeStatus] bit NULL,
	[DocumentstatusIsClosed] bit NULL,
	[DocumentStatusIsReadonly] int NULL,
 CONSTRAINT [PK_DOC_DocumentStatus_DocType] PRIMARY KEY ([DocumentStatusDocTypeId]),
 CONSTRAINT [FK_DOC_DOCUMENTSTATUS_DOCTYPE_DM_SCHEMA] FOREIGN KEY([SchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId])
)