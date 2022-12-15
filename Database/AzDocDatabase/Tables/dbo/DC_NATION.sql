CREATE TABLE [dbo].[DC_NATION](
	[NationId] int identity NOT NULL,
	[NationName] nvarchar(100) NULL,
	[NationStatus] bit NOT NULL CONSTRAINT [DF__DC_NATION__Natio__542C7691]  DEFAULT 1,
 CONSTRAINT [PK_DC_NATION] PRIMARY KEY ([NationId])
)
