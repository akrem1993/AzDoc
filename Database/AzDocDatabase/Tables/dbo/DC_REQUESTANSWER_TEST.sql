CREATE TABLE [dbo].[DC_REQUESTANSWER_TEST](
	[MessageId] int identity NOT NULL,
	[RequestId] int NOT NULL,
	[MessageText] nvarchar(max) NULL,
	[WorkPlaceId] int NOT NULL,
	[MessageDate] [datetime] NOT NULL,
	[AnswerMessageId] int NULL,
	[IsSeen] bit NOT NULL)
