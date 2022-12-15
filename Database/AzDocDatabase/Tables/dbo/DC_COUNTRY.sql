CREATE TABLE [dbo].[DC_COUNTRY](
	[CountryId] int identity NOT NULL,
	[CountryName] nvarchar(250) NOT NULL,
	[CountryName2] nvarchar(250) NOT NULL,
	[CountryStatus] [tinyint] NOT NULL CONSTRAINT [DF_DC_COUNTRY_CountryStatus]  DEFAULT 1,
 CONSTRAINT [PK_DC_COUNTRYKey] PRIMARY KEY ([CountryId])
)
