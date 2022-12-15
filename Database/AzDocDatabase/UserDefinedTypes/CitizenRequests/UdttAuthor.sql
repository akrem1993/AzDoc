CREATE TYPE [citizenrequests].[UdttAuthor] AS TABLE(
	[AuthorId] int NOT NULL,
	[AuthorOrganizationId] int NULL,
	[OrganizationName] nvarchar(max) NULL,
	[FullName] nvarchar(max) NULL,
	[AuthorDepartmentName] nvarchar(max) NULL,
	[PositionName] nvarchar(max) NULL,
	[PrevOrganization] nvarchar(max) NULL
)