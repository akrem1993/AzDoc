CREATE TABLE [dbo].[LogApp](
	[Id] [bigint] identity NOT NULL,
	[LogType] nvarchar(max) NULL,
	[Url] nvarchar(max) NULL,
	[DocId] nvarchar(100) NULL,
	[Controller] nvarchar(max) NULL,
	[ControllerAction] nvarchar(max) NULL,
	[RequestData] nvarchar(max) NULL,
	[RequestParams] nvarchar(max) NULL,
	[Message] nvarchar(max) NULL,
	[UserName] nvarchar(max) NULL,
	[WorkPlace] nvarchar(max) NULL,
	[UserIp] nvarchar(50) NULL,
	[Date] [datetime] NULL CONSTRAINT [DfLogAppDate] DEFAULT [dbo].sysdatetime()
)
