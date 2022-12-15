CREATE TABLE [dbo].[DC_USER](
	[UserId] int identity NOT NULL,
	[UserPersonnelId] int NULL,
	[UserName] nvarchar(50) NOT NULL,
	[UserPassword] nvarchar(128) NULL,
	[DefaultPage] int NOT NULL CONSTRAINT [DF_DC_USER_DefaultPage]  DEFAULT -1,
	[UserStatus] bit NOT NULL CONSTRAINT [DF_DC_USER_UserStatus]  DEFAULT 1,
	[Notifications] bit NULL,
	[DomenUserName] nvarchar(30) NULL,
	[DefaultLang] int NOT NULL CONSTRAINT [DF_DC_USER_DefaultLang]  DEFAULT 1,
	[DefaultLeftMenu] bit NULL,
    CONSTRAINT [PK_DC_USER] PRIMARY KEY ([UserId]),
    CONSTRAINT [UK_DC_USERUserName] UNIQUE ([UserName]),
	CONSTRAINT [FK_DC_USER_DC_PERSONNEL] FOREIGN KEY([UserPersonnelId]) REFERENCES [dbo].[DC_PERSONNEL] ([PersonnelId])
 )
