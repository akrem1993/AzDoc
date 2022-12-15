CREATE TABLE [smdo].[DtsChecks](
	[Id] int identity NOT NULL,
	[DocId] int NULL,
	[CheckName] nvarchar(max) NULL,
	[CheckStatus] int NULL,
	[Indicator] bit NULL,
	[CheckDescription] nvarchar(max) NULL
)