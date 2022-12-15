CREATE TABLE [dbo].[DC_RANK](
	[RankId] int identity NOT NULL,
	[RankName] nvarchar(250) NULL,
	[RankStatus] bit NOT NULL  CONSTRAINT [DF_DC_RANK_RankStatus]  DEFAULT 1,
 CONSTRAINT [PK_DC_RANK] PRIMARY KEY ([RankId])
)
