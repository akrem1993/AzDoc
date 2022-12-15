CREATE TABLE [dbo].[DOC_PERIOD](
	[PeriodId] int identity NOT NULL,
	[PeriodDate1] [date] NOT NULL,
	[PeriodDate2] [date] NOT NULL,
	[PeriodDescription] nvarchar(200) NOT NULL,
	[PeriodStatus] bit NOT NULL CONSTRAINT [DF_DOC_PERIOD_PeriodStatus]  DEFAULT 1,
 CONSTRAINT [PK_DOC_PERIOD] PRIMARY KEY ([PeriodId])
)