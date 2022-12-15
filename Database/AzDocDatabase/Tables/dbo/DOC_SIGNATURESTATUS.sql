CREATE TABLE [dbo].[DOC_SIGNATURESTATUS](
	[SignatureId] [tinyint] NOT NULL,
	[SignatureStatusName] nvarchar(50) NOT NULL,
 CONSTRAINT [PK_DOC_SIGNATURESTATUS] PRIMARY KEY ([SignatureId])
)