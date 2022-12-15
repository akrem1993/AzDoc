CREATE TABLE [dbo].[DC_REQUESTSTATUS](
	[RequestStatusId] int identity NOT NULL,
	[RequestStatusName] nvarchar(max) NOT NULL,
	[RequestStatus] bit NOT NULL,
 CONSTRAINT [PK_DC_REQUESTSTATUS] PRIMARY KEY ([RequestStatusId])
)
