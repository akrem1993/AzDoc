CREATE TABLE [dbo].[DC_REQUEST](
	[RequestId] int identity NOT NULL,
	[RequestText] nvarchar(max) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[RequestStatusId] int NOT NULL,
	[WorkPlaceId] int NOT NULL,
	[RequestTypeId] int NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[RequestStatus] bit NOT NULL,
    CONSTRAINT [PK_DC_REQUEST] PRIMARY KEY ([RequestId]),
	CONSTRAINT [FK_DC_REQUEST_DC_REQUEST] FOREIGN KEY([RequestId]) REFERENCES [dbo].[DC_REQUEST] ([RequestId]),
	CONSTRAINT [FK_DC_REQUEST_DC_REQUESTSTATUS] FOREIGN KEY([RequestStatusId]) REFERENCES [dbo].[DC_REQUESTSTATUS] ([RequestStatusId]),
	CONSTRAINT [FK_DC_REQUEST_DC_REQUESTTYPE] FOREIGN KEY([RequestTypeId]) REFERENCES [dbo].[DC_REQUESTTYPE] ([RequestTypeId]),
	CONSTRAINT [FK_DC_REQUEST_DC_WORKPLACE] FOREIGN KEY([WorkPlaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId])
 )
