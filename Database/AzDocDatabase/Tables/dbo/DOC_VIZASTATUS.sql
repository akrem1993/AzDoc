CREATE TABLE [dbo].[DOC_VIZASTATUS](
	[VizaStatusId] [tinyint] NOT NULL,
	[VizaStatusName] nvarchar(200) NOT NULL,
	[VizaStatusStatus] bit NOT NULL CONSTRAINT DfDOC_VIZASTATUSVizaStatusStatus DEFAULT 1,
    CONSTRAINT PkDOC_VIZASTATUSVizaStatusId PRIMARY KEY ([VizaStatusId])
)
