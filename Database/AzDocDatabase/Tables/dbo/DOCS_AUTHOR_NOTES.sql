CREATE TABLE [dbo].[DOCS_AUTHOR_NOTES](
	[AuthorNoteId] int identity NOT NULL,
	[AuthorNoteText] nvarchar(max) NOT NULL,
	[AuthorNoteCreationDate] [date] NOT NULL CONSTRAINT [DF_DOCS_AUTHOR_NOTES_AuthorNoteCreationDate]  DEFAULT dbo.SYSDATETIME(),
	[AuthorNoteDocId] int NOT NULL,
	[AuthorWorkplaceId] int NOT NULL,
	[AuthorNoteIsShared] bit NOT NULL,
    CONSTRAINT [PK_DOCS_AUTHOR_NOTES] PRIMARY KEY ([AuthorNoteId]),
    CONSTRAINT [FK_DOCS_AUTHOR_NOTES_DC_WORKPLACE] FOREIGN KEY([AuthorWorkplaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId]),
	CONSTRAINT [FK_DOCS_AUTHOR_NOTES_DOCS] FOREIGN KEY([AuthorNoteDocId]) REFERENCES [dbo].[DOCS] ([DocId])
)
