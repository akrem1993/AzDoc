CREATE TABLE [dbo].[DC_AGENCY](
	[AgencyId] int identity NOT NULL,
	[AgencyName] nvarchar(250) NOT NULL,
	[AgencyTopId] int NULL,
	[AgencyOrganizationId] int NULL,
    CONSTRAINT [PK_DC_AGENCYKey] PRIMARY KEY ([AgencyId])
 )
