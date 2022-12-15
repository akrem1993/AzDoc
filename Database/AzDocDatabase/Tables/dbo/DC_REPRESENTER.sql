CREATE TABLE [dbo].[DC_REPRESENTER](
	[RepresenterId] int NOT NULL,
	[RepresenterName] nvarchar(100) NULL,
	[RepresenterStatus] bit NOT NULL CONSTRAINT [DF__DC_REPRES__Repre__5708E33C]  DEFAULT 1,
 CONSTRAINT [PK_DC_REPRESENTER] PRIMARY KEY ([RepresenterId])
 )
