CREATE TABLE [dbo].[DC_YURIDICALFORM](
	[FormId] int identity NOT NULL,
	[FormName] nvarchar(100) NULL,
	[FormStatus] bit NOT NULL CONSTRAINT [DF__DC_YURIDI__FormS__5F9E293D]  DEFAULT 1,
    CONSTRAINT [PK_DC_YURIDICALFORM] PRIMARY KEY ([FormId])
 )
