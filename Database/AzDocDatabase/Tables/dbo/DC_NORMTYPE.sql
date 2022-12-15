CREATE TABLE [dbo].[DC_NORMTYPE](
	[Id] int NOT NULL,
	[NormTypeName] nvarchar(200) NOT NULL,
	[NormTypeIndex] nvarchar(10) NULL,
	[NormTypeStatus] bit NULL CONSTRAINT DfDC_NORMTYPENormTypeStatus DEFAULT 1,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] nvarchar(256) NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedBy] nvarchar(256) NULL,
	[NormTypeFormId] int NULL,
    CONSTRAINT [PK_DC_NORMTYPE] PRIMARY KEY ([Id])
 )
