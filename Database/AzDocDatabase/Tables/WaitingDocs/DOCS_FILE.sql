CREATE TABLE [WaitingDocs].[DOCS_FILE](
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
	[WorkPlaceId] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[RecoveryDate] [datetime] NULL,
	[TransactionId] [varchar](32) NULL
)
