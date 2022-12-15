CREATE TABLE [smdo].[SmdoDocs](
	[DocId] int identity NOT NULL,
	[AzDocId] int NOT NULL,
	[DocEnterNo] nvarchar(50) NULL,
	[DocEnterDate] [datetime] NULL,
	[DocCreator] int NULL,
	[DocMsgGuid] nvarchar(250) NULL,
	[DocFilePath] nvarchar(max) NULL,
	[DocStatus] int NULL,
	[DocAckStatus] [tinyint] NULL,
	[DocSigner] int NULL,
	[DocDescription] nvarchar(max) NULL,
	[DocKind] nvarchar(max) NULL,
	[IsReceived] bit NULL,
	[DocSubject] nvarchar(max) NULL
)