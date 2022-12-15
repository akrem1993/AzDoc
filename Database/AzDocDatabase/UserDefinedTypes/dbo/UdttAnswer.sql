CREATE TYPE [dbo].[UdttAnswer] AS TABLE(
	[DocId] int NOT NULL,
	[DocEnterno] nvarchar(max) NULL,
	[DocumentInfo] nvarchar(max) NULL,
	[DocDoctypeId] int NULL,
	[ResultId] int NULL
)