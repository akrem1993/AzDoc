CREATE TABLE [dbo].[DMSTables](
	[Id] int identity NOT NULL,
	[Name] nvarchar(100) NULL,
	[DisplayName] nvarchar(100) NOT NULL,
	[Description] nvarchar(500) NULL,
	[TopId] int NULL,
	[OrderNo] int NOT NULL,
	[PageUrl] nvarchar(500) NULL,
	[GridWidth] int NULL,
	[Status] bit NOT NULL,
 CONSTRAINT [PK_dbo.DMSTables] PRIMARY KEY ([Id])
)