CREATE TABLE [dbo].[DOC_TAKENMEASURE](
	[TakenMeasureId] int identity NOT NULL,
	[TakenMeasureName] nvarchar(max) NOT NULL,
	[TakenMeasureStatus] bit NOT NULL,
 CONSTRAINT [PK_DOC_TAKENMEASURE] PRIMARY KEY ([TakenMeasureId])
)