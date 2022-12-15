CREATE TABLE [dbo].[DOC_TYPE_EXCHANGE](
	[DocTypeExchangeId] int identity NOT NULL,
	[SchemaId] int NOT NULL,
	[DocTypeId] int NOT NULL,
	[FromDocTypeId] int NOT NULL,
	[ToDocTypeId] int NOT NULL,
	[AnswerType] [tinyint] NULL,
	[RelatedTypeId] int NULL,
 CONSTRAINT [PK_DOC_TYPE_EXCHANGE] PRIMARY KEY ([DocTypeExchangeId]),
 CONSTRAINT [FK_DOC_TYPE_EXCHANGE_DM_SCHEMA] FOREIGN KEY([SchemaId]) REFERENCES [dbo].[DM_SCHEMA] ([SchemaId]),
 CONSTRAINT [FK_DOC_TYPE_EXCHANGE_DOC_TYPE] FOREIGN KEY([DocTypeId]) REFERENCES [dbo].[DOC_TYPE] ([DocTypeId])
)