CREATE TABLE [smdo].[SmdoDocsFile](
	[FileId] int identity NOT NULL,
	[FileDocId] int NOT NULL,
	[FilePath] nvarchar(max) NULL,
	[FileName] nvarchar(max) NULL,
	[FileGuid] nvarchar(250) NULL,
	CONSTRAINT PkSmdoDocsFileKey PRIMARY KEY([FileDocId])
)