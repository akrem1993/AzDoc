CREATE TABLE [dbo].[DOCS_RELATED_VIZA](
	[RelatedVizaId] int identity NOT NULL,
	[RelatedId] int NOT NULL,
	[WorkplaceId] int NOT NULL,
    CONSTRAINT [PK_DOCS_RELATED_VIZA] PRIMARY KEY ([RelatedVizaId])
)