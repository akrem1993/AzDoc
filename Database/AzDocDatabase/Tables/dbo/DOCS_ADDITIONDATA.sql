CREATE TABLE [dbo].[DOCS_ADDITIONDATA](
	[AdditionDataId] int identity NOT NULL,
	[DocumentId] int NOT NULL,
	[KeyField] varchar(100) NULL,
	[Field1] [float] NOT NULL,
	[Field2] [float] NULL,
	[Field3] [float] NULL,
	[Field4] [float] NULL,
	[Field5] [float] NULL,
	[Field6] nvarchar(max) NULL,
	[Field7] nvarchar(200) NULL,
	[Field8] nvarchar(200) NULL,
	[Field9] nvarchar(200) NULL,
	[Field10] nvarchar(200) NULL,
	[Field11] [datetime] NULL,
	[Field12] [datetime] NULL,
	[Field13] [datetime] NULL,
	[Field14] [datetime] NULL,
	[Field15] [datetime] NULL,
	[Field16] bit NULL,
	[Field17] bit NULL,
	[Field18] [float] NULL,
	[Field19] int NULL,
	[Field20] int NULL,
	[ParentId] int NULL,
	[Field21] int NULL,
	[Field22] int NULL,
	[Field23] int NULL,
 CONSTRAINT [PK_DOCS_ADDITIONDATA] PRIMARY KEY ([DocumentId])
)
