CREATE TABLE [dbo].[DC_REQUEST_TEST](
	[RequestId] int identity NOT NULL,
	[RequestHeader] nvarchar(max) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[WorkPlaceId] int NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[RequestType] int NOT NULL,
	[RequestStatus] int NOT NULL)
