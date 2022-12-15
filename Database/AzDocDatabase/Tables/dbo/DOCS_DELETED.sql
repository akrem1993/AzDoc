CREATE TABLE [dbo].[DOCS_DELETED](
	[Id] int identity NOT NULL,
	[DocId] int NOT NULL,
	[Note] nvarchar(max) NOT NULL,
	[DeletedDate] [datetime] NOT NULL,
	[DeletedUserId] int NOT NULL,
    CONSTRAINT [PK_DOCS_DELETED] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DOCS_DELETED_DOCS] FOREIGN KEY([DocId]) REFERENCES [dbo].[DOCS] ([DocId])
)
GO
