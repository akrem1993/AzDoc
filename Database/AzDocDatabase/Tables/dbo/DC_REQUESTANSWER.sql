CREATE TABLE [dbo].[DC_REQUESTANSWER](
	[RequestAnswerId] int identity NOT NULL,
	[RequestId] int NOT NULL,
	[RequestAnswerText] nvarchar(max) NULL,
	[WorkPlaceId] int NOT NULL,
	[RequestAnswerDate] [datetime] NULL,
	[RequestAnswerStatus] bit NOT NULL,
	[IsSeen] bit NOT NULL CONSTRAINT DfDC_REQUESTANSWERIsSeen DEFAULT 1,
 CONSTRAINT [PK_DC_REQUESTANSWER] PRIMARY KEY ([RequestAnswerId]),
 CONSTRAINT [FK_DC_REQUESTANSWER_DC_WORKPLACE] FOREIGN KEY([WorkPlaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId])
)
