CREATE TABLE [dbo].[DMS_APP_VERSION](
	[ID] int identity NOT NULL,
	[MajorVersion] int NOT NULL,
	[MinorVersion] int NOT NULL,
	[BuildVersion] int NOT NULL,
	[ApplicationType] nvarchar(50) NOT NULL,
	[CreatedBy] nvarchar(50) NOT NULL,
	[PublishDate] [smalldatetime] NOT NULL CONSTRAINT [DF_DMS_APP_VERSION_Add_Dt]  DEFAULT dbo.SYSDATETIME(),
 CONSTRAINT [PK_DMS_APP_VERSION] PRIMARY KEY ([ID])
 )
