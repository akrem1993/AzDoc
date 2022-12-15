CREATE TABLE [dbo].[DOC_TOPIC](
	[TopicId] int identity NOT NULL,
	[TopicTypeId] int NOT NULL,
	[ParentTopicId] int NULL,
	[TopicName] nvarchar(250) NOT NULL,
	[TopicOrderIndex] int NULL,
	[TopicIndex] nvarchar(10) NULL,
	[TopicStatus] bit NOT NULL CONSTRAINT [DF_DOC_TOPIC_TopicStatus]  DEFAULT 1,
 CONSTRAINT [PK_DOC_TOPIC] PRIMARY KEY ([TopicId]),
 CONSTRAINT [FK_DOC_TOPIC_DOC_TOPIC_TYPE] FOREIGN KEY([TopicTypeId]) REFERENCES [dbo].[DOC_TOPIC_TYPE] ([TopicTypeId])
)
