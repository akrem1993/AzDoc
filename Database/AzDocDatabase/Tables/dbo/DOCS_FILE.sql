CREATE TABLE [dbo].[DOCS_FILE](
	[FileId] int identity NOT NULL,
	[FileDocId] int NOT NULL,
	[FileInfoId] int NOT NULL,
	[FileName] nvarchar(300) NULL,
	[FileVisaStatus] [tinyint] NULL CONSTRAINT [DF_DOCS_FILE_FileVisaStatus]  DEFAULT 0,
	[SignatureStatusId] [tinyint] NOT NULL CONSTRAINT [DF_DOCS_FILE_SignatureStatusId]  DEFAULT 1,
	[FileCurrentVisaGroup] [tinyint] NULL  CONSTRAINT [DF_DOCS_FILE_FileCurrentVisaGroup]  DEFAULT 0,
	[FileIsMain] bit NULL CONSTRAINT [DF_DOCS_FILE_FileIsMain_1]  DEFAULT 1,
	[SignatureNote] nvarchar(max) NULL,
	[IsDeleted] bit NULL,
	[IsReject] bit NULL,
	[SignatureWorkplaceId] int NULL,
	[SignatureDate] [datetime] NULL,
    CONSTRAINT [PK_DOCS_FILE] PRIMARY KEY ([FileId]),
    CONSTRAINT [FK_DOCS_FILE_DOCS_FILEINFO] FOREIGN KEY([FileInfoId]) REFERENCES [dbo].[DOCS_FILEINFO] ([FileInfoId]),
	CONSTRAINT [FK_DOCS_FILE_DOCS1] FOREIGN KEY([FileDocId]) REFERENCES [dbo].[DOCS] ([DocId])
)
