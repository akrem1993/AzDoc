CREATE TABLE [dbo].[DOC_TOPIC_TYPE](
	[TopicTypeId] int identity NOT NULL,
	[TopicTypeName] nvarchar(250) NOT NULL,
	[TopicTypeOrderIndex] int NULL,
	[TopicTypeStatus] bit NOT NULL CONSTRAINT [DF_DOC_TOPIC_TYPE_TopicTypeStatus] DEFAULT 1,
	[TopicTypeDoctypeId] int NULL,
	[OrganizationId] int NULL,
 CONSTRAINT [PK_DOC_TOPIC_TYPE] PRIMARY KEY CLUSTERED  ([TopicTypeId])
)
