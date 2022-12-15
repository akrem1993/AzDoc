CREATE TYPE [admin].[UdttWorkPlaces] AS TABLE(
	[WorkplaceId] int NOT NULL,
	[OrganizationId] int NULL,
	[DepartmentId] int NULL,
	[SectorId] int NULL,
	[DepartmentPositionId] int NULL,
	[JsonRoleId] nvarchar(max) NULL
)