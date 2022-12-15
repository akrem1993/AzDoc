CREATE TABLE [dbo].[DC_REPEATPERIOD](
	[Id] [tinyint] NOT NULL,
	[Name] nvarchar(200) NOT NULL,
	[Status] bit NOT NULL CONSTRAINT DfDC_REPEATPERIODStatus DEFAULT 1,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] nvarchar(200) NULL,
	[UpdatedBy] nvarchar(200) NULL,
    CONSTRAINT PkDC_REPEATPERIODId PRIMARY KEY ([Id])
)
