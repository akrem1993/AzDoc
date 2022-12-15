CREATE TABLE [dbo].[DC_REQUESTTYPE](
	[RequestTypeId] int identity NOT NULL,
	[RequestTypeName] nvarchar(max) NOT NULL,
	[RequestTypeStatus] bit NOT NULL,
 CONSTRAINT [PK_DC_REQUESTTYPE] PRIMARY KEY ([RequestTypeId])
 )
