CREATE TABLE [smdo].[ReceivedDocs](
	[ReceivedId] int identity NOT NULL,
	[ReceivedDocId] int NOT NULL,
	[ReceiverIdName] nvarchar(250) NULL,
	[ReceiverOrgName] nvarchar(max) NULL,
	[ReceiverSystem] nvarchar(max) NULL,
	[OrgString] nvarchar(max) NULL,
	[OrgFullName] nvarchar(max) NULL,
	[OrgShortName] nvarchar(max) NULL,
	[OrgAddress] nvarchar(max) NULL,
	CONSTRAINT PkReceivedDocsKey PRIMARY KEY([ReceivedDocId])
)