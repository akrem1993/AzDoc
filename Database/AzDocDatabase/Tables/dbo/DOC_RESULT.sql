CREATE TABLE [dbo].[DOC_RESULT](
	[Id] int NOT NULL,
	[ResultName] nvarchar(50) NOT NULL,
	[ResultStatus] bit NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] nvarchar(256) NULL,
	[UpdatedBy] nvarchar(256) NULL,
	[ResultOrderindex] int NULL,
 CONSTRAINT [PK_DOC_RESULT] PRIMARY KEY ([Id])
)