CREATE TABLE [dbo].[DC_REQUESTFILES](
	[RuquestFilesId] int identity NOT NULL,
	[FileInfoId] int NOT NULL,
	[RequestId] int NOT NULL,
	[Type] int NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[Status] bit NOT NULL,
 CONSTRAINT [PK_DC_REQUESTFILES] PRIMARY KEY ([RuquestFilesId]),
 CONSTRAINT [FK_DC_REQUESTFILES_DC_REQUEST] FOREIGN KEY([FileInfoId]) REFERENCES [dbo].[DOCS_FILEINFO] ([FileInfoId]),
 CONSTRAINT [FK_DC_REQUESTFILES_DC_REQUEST1] FOREIGN KEY([RequestId]) REFERENCES [dbo].[DC_REQUEST] ([RequestId])
 )
