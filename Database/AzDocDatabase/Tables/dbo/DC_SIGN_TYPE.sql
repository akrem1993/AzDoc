CREATE TABLE [dbo].[DC_SIGN_TYPE](
	[SignTypeId] int identity NOT NULL,
	[SignTypeName] nvarchar(200) NULL,
	[SignHeight] int NULL,
	[SignWeight] int NULL,
	[SignTypeStatus] bit NULL,
	[CoordinateX] int NULL,
	[CoordinateY] int NULL,
 CONSTRAINT [PK_DC_SIGN_TYPE] PRIMARY KEY ([SignTypeId])
 )
