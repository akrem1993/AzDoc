CREATE TABLE [dbo].[DOCS_FILETICKETS](
	[TickedId] int identity NOT NULL,
	[TickedFileInfoId] int NULL,
	[EdocPath] nvarchar(200) NULL,
	[TickedStartDate] [datetime] NULL,
	[TickedEndDate] [datetime] NULL,
	[TickedMessage] nvarchar(max) NULL,
	[TickedFileId] int NULL,
	[SignatureTypeId] int NOT NULL,
	[TickedNotes] nvarchar(max) NULL,
    CONSTRAINT PkDOCS_FILETICKETSKey PRIMARY KEY ([TickedId]),
	CONSTRAINT [FK_DOCS_FILETICKETS_TickedFileInfoId] FOREIGN KEY([TickedFileInfoId]) REFERENCES [dbo].[DOCS_FILEINFO] ([FileInfoId])
)
