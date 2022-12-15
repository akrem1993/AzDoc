CREATE TABLE [dbo].[DOC_ACTION_NAME](
	[ActionId] int identity NOT NULL,
	[ActionName] nvarchar(50) NOT NULL,
	[ActionStatus] bit NOT NULL,
	[MenuType] int NOT NULL,
	[ActionIndex] int NOT NULL
)