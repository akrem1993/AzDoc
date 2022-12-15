CREATE TABLE [dbo].[DOC_QUESTION](
	[Id] int identity NOT NULL,
	[QuestionTopId] int NULL,
	[QuestionBody] nvarchar(max) NULL,
	[QuestionOrderindex] int NOT NULL,
	[QuestionStatus] bit NOT NULL,
	[QuestionTitle] nvarchar(max) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] nvarchar(256) NULL,
	[UpdatedBy] nvarchar(256) NULL,
 CONSTRAINT [PK_DOC_QUESTION] PRIMARY KEY ([Id])
)