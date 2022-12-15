CREATE TABLE [WaitingDocs].[DOCS_RELATED](
	[RelatedId] int NOT NULL,
	[RelatedDocId] int NOT NULL,
	[RelatedDocumentId] int NOT NULL,
	[RelatedTypeId] [int] NULL,
	[DocId] [int] NOT NULL,
	[WorkPlaceId] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[RecoveryDate] [datetime] NULL,
	[TransactionId] [varchar](32) NULL
)
