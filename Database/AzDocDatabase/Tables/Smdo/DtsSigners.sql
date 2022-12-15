CREATE TABLE [smdo].[DtsSigners](
	[Id] int identity NOT NULL,
	[DocId] int NULL,
	[subject] nvarchar(max) NULL,
	[serialNumber] nvarchar(max) NULL,
	[validFrom] [datetime] NULL,
	[validTo] [datetime] NULL,
	[issuer] nvarchar(max) NULL
)