CREATE TABLE [dbo].[DC_RIGHT_TYPE](
	[RightTypeId] int NOT NULL,
	[RightTypeName] nvarchar(500) NOT NULL,
	[RightTypeStatus] bit NOT NULL CONSTRAINT [DF_DC_RIGHT_TYPE_RightTypeStatus]  DEFAULT 1,
 CONSTRAINT [PK_DC_RIGHT_TYPE] PRIMARY KEY ([RightTypeId]) 
 )
