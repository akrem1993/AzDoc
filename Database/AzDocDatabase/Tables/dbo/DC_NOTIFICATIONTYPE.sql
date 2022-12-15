CREATE TABLE [dbo].[DC_NOTIFICATIONTYPE](
	[NotificationTypeId] int IDENTITY  CONSTRAINT [PK_DC_NOTIFICATIONTYPE] PRIMARY KEY ([NotificationTypeId]),
	[NotificationTypeText] nvarchar(50) NULL,
	[NotificationParentId] int NULL,
	[NotificationTypeStatus] bit NULL,

 )
