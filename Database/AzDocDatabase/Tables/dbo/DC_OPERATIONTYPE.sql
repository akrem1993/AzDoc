CREATE TABLE [dbo].[DC_OPERATIONTYPE](
	[OperationtypeId] int NOT NULL,
	[OperationtypeName] nvarchar(50) NOT NULL,
	[OperationtypeStatus] bit NOT NULL CONSTRAINT [DF_DC_OPERATIONTYPE_OperationtypeStatus]  DEFAULT 1,
	CONSTRAINT [PK_DC_OPERATIONTYPE] PRIMARY KEY ([OperationtypeId])
)
