CREATE TABLE [smdo].[SmdoLogData](
	[Id] int identity NOT NULL,
	[DocId] int NULL,
	[XmlData] nvarchar(max) NULL,
	[MsgGuid] nvarchar(max) NULL,
	[IsReceived] bit NULL CONSTRAINT DfSmdoLogDataIsReceived DEFAULT 0
)