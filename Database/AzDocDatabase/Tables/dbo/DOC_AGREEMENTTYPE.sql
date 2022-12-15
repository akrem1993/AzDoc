CREATE TABLE [dbo].[DOC_AGREEMENTTYPE](
	[AgreementTypeId] int identity NOT NULL,
	[AgreementTypeName] nvarchar(max) NULL,
	[AgreementTypeStatus] bit NULL CONSTRAINT [DF_DOCS_AGREEMENTTYPE_AgreementTypeStatus]  DEFAULT 1,
 CONSTRAINT [PK_DOCS_AGREEMENTTYPE] PRIMARY KEY ([AgreementTypeId])
 )