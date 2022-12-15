CREATE TABLE [dbo].[DOC_DESCRIPTION](
	[DescriptionId] int identity NOT NULL,
	[DescriptionDoctypeId] int NULL,
	[DescriptionTypeId] int NOT NULL CONSTRAINT [DF__DOC_DESCR__Descr__369C13AA]  DEFAULT -1,
	[DescriptionControlStatus] [tinyint] NULL CONSTRAINT [DF__DOC_DESCR__Descr__379037E3]  DEFAULT 0,
	[DescriptionExecutionStatusId] int NULL,
	[DescriptionContent] nvarchar(max) NOT NULL,
	[DescriptionStatus] bit NOT NULL CONSTRAINT [DF__DOC_DESCR__Descr__07E124C1]  DEFAULT 1,
 CONSTRAINT [PK_DOC_DESCRIPTION] PRIMARY KEY ([DescriptionId]),
 CONSTRAINT [FK_DOC_DESCRIPTION_DOC_TYPE] FOREIGN KEY([DescriptionDoctypeId]) REFERENCES [dbo].[DOC_TYPE] ([DocTypeId])
)
