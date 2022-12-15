CREATE TABLE [dbo].[DOC_NUMBERS](
	[DocNumberId] int identity NOT NULL,
	[DocNumberPeriodId] int NULL,
	[DocNumberOrganizationId] int NULL,
	[DocNumberTypeId] int NULL,
	[DocNumberIndex] nvarchar(50) NULL,
	[DocNumberPoolId] int NULL,
	[DocNumberCurrentNumber] int NULL,
	[DocNumberLostIndex] bit NULL CONSTRAINT [DF_DOC_NUMBERS_DocNumberLostIndex]  DEFAULT 0,
 CONSTRAINT [PK_DOC_NUMBERS] PRIMARY KEY ([DocNumberId]),
 CONSTRAINT [FK_DOC_NUMBERS_ORGANIZATION] FOREIGN KEY([DocNumberOrganizationId]) REFERENCES [dbo].[DC_ORGANIZATION] ([OrganizationId]),
 CONSTRAINT [FK_DOC_NUMBERS_PERIOD] FOREIGN KEY([DocNumberPeriodId]) REFERENCES [dbo].[DOC_PERIOD] ([PeriodId]),
 CONSTRAINT [FK_DOC_NUMBERS_POOLID] FOREIGN KEY([DocNumberPoolId]) REFERENCES [dbo].[DOC_POOL] ([PoolId])
 )