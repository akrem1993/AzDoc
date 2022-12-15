CREATE TABLE [dbo].[DOCS_FILESIGN](
	[Id] int identity NOT NULL,
	[FileInfoId] int NOT NULL,
	[SignatureDate] [datetime] NULL,
	[SignatureWorkplaceId] int NULL,
	[SignaturePersonnelId] int NULL,
	[SignatureTypeId] int NOT NULL CONSTRAINT [DF_DOCS_FILESIGN_TYPEID]  DEFAULT 1,
	[EdocPath] nvarchar(200) NULL,
	[FileId] int NULL,
	[SignatureNote] nvarchar(2000) NULL,
    CONSTRAINT [PK_DOCS_FILESIGN] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DOCS_FILESIGN_DOCS_FILEINFO] FOREIGN KEY([FileInfoId]) REFERENCES [dbo].[DOCS_FILEINFO] ([FileInfoId])
)
