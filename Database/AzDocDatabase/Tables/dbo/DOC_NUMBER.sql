CREATE TABLE [dbo].[DOC_NUMBER](
	[DocNumberId] int identity NOT NULL,
	[DocNumberPeriodId] int NOT NULL,
	[DocNumberOrganizationId] int NOT NULL,
	[DocNumberIndex] nvarchar(50) NOT NULL,
	[DocNumberDocTypeId] int NULL,
	[DocNumberPoolId] int NOT NULL,
    CONSTRAINT [PK_DOC_NUMBER] PRIMARY KEY ([DocNumberId]),
    CONSTRAINT [FK_DOC_NUMBER_DC_ORGANIZATION] FOREIGN KEY([DocNumberOrganizationId]) REFERENCES [dbo].[DC_ORGANIZATION] ([OrganizationId]),
    CONSTRAINT [FK_DOC_NUMBER_DOC_PERIOD] FOREIGN KEY([DocNumberPeriodId]) REFERENCES [dbo].[DOC_PERIOD] ([PeriodId]),
    CONSTRAINT [FK_DOC_NUMBER_DOC_POOL] FOREIGN KEY([DocNumberPoolId]) REFERENCES [dbo].[DOC_POOL] ([PoolId]),
    CONSTRAINT [FK_DOC_NUMBER_DOC_TYPE] FOREIGN KEY([DocNumberDocTypeId]) REFERENCES [dbo].[DOC_TYPE] ([DocTypeId])
)
