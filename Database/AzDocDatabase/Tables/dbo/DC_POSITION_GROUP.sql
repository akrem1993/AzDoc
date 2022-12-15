CREATE TABLE [dbo].[DC_POSITION_GROUP](
	[PositionGroupId] int NOT NULL,
	[PositionGroupName] nvarchar(100) NOT NULL,
	[PositionGroupSql] nvarchar(max) NULL,
	[PositionGroupLevel] int NOT NULL,
	[PositionGroupStatus] bit NOT NULL CONSTRAINT [DF_DC_POSITION_GROUP_PositionGroupStatus]  DEFAULT 1,
	[PositionIsDirector] bit NULL CONSTRAINT [DF_DC_POSITION_GROUP_PositionIsDirector]  DEFAULT 0,
 CONSTRAINT [PK_DC_POSITION_GROUP] PRIMARY KEY ([PositionGroupId])
 )
