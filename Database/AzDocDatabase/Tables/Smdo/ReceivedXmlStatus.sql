CREATE TABLE [smdo].[ReceivedXmlStatus](
	[id] int identity NOT NULL,
	[XmlData] nvarchar(max) NULL,
	[XmlStatus] bit NULL CONSTRAINT DfReceivedXmlStatusXmlStatus DEFAULT 0,
	[ReceivedDate] [datetime] NULL CONSTRAINT DfReceivedXmlStatusReceivedDate DEFAULT [dbo].[sysdatetime]()
)