CREATE TABLE [dbo].[DC_ORGANIZATIONTYPE](
	[TypeId] int NOT NULL,
	[TypeName] nvarchar(250) NOT NULL,
	[TypeTopId] nvarchar(250) NULL,
	[TypeOrderindex] nvarchar(250) NULL,
	[TypeStatus] bit NULL CONSTRAINT [DF_DC_ORGANIZATIONTYPE_TypeStatus]  DEFAULT 1,
	[TypeIndex] nvarchar(10) NULL,
 CONSTRAINT [PK_DC_ORGANIZATIONTYPE] PRIMARY KEY ([TypeId])
)
