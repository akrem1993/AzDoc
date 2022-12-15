CREATE TABLE [dbo].[DC_POSITION](
	[PositionId] int identity NOT NULL,
	[PositionName] nvarchar(250) NULL,
	[PositionStatus] bit NOT NULL CONSTRAINT [DF_DC_POSITION_PositionStatus]  DEFAULT 1,
	[PositionIndex] nvarchar(10) NULL,
	CONSTRAINT [PK_DC_POSITION] PRIMARY KEY ([PositionId])
 )
