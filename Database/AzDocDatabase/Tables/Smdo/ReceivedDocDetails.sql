CREATE TABLE [smdo].[ReceivedDocDetails](
	[Id] int identity NOT NULL,
	[DocId] int NULL,
	[SignP7S] nvarchar(max) NULL,
	[AttachName] nvarchar(max) NULL,
	[AttachPath] nvarchar(max) NULL,
	[AttachGuid] nvarchar(max) NULL,
	[DvcBase64] nvarchar(max) NULL,
	[Subjects] nvarchar(max) NULL,
	[SerialNumber] nvarchar(max) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL
)