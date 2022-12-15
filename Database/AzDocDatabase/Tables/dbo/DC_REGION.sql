CREATE TABLE [dbo].[DC_REGION](
	[RegionId] int NOT NULL,
	[RegionName] nvarchar(250) NULL,
	[RegionCountryId] int NULL,
	[RegionTopId] int NULL,
	[RegionTypeId] int NULL,
	[RegionZoneId] int NULL,
	[RegionStatus] [tinyint] NULL,
	[RegionId2] char(8) NULL,
	[RegionTopId2] char(8) NULL,
    CONSTRAINT [PK_DC_REGION] PRIMARY KEY ([RegionId]),
    CONSTRAINT [FK_DC_REGION_DC_COUNTRY] FOREIGN KEY([RegionCountryId]) REFERENCES [dbo].[DC_COUNTRY] ([CountryId])
 )
