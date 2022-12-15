CREATE TABLE [dbo].[DM_ACTION](
	[ActionId] int identity NOT NULL,
	[ActionName] nvarchar(100) NOT NULL,
	[ActionStatus] bit NOT NULL CONSTRAINT [DF_DM_ACTION_ActionStatus]  DEFAULT 1,
 CONSTRAINT [PK_DM_ACTION] PRIMARY KEY ([ActionId])
 )
