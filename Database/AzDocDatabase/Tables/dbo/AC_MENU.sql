CREATE TABLE [dbo].[AC_MENU](
	[Id] int identity NOT NULL,
	[ParentId] int NULL,
	[SchemaId] int NULL,
	[DocTypeId] int NULL,
	[IconClass] varchar(50) NULL,
	[Caption] nvarchar(200) NOT NULL,
	[ControllerId] int NULL,
	[ActionName] nvarchar(100) NULL,
	[Parameters] varchar(200) NULL,
	[ForAllUser] bit NULL,
	[OrderNo] int NULL,
	CONSTRAINT PkAC_MENUKey PRIMARY KEY(Id) 
)
