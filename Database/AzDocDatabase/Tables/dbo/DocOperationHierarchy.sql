CREATE TABLE [dbo].[DocOperationHierarchy](
	[HierarchyId] int identity NOT NULL,
	[DocTypeId] int NULL,
	[OrganizationId] int NULL,
	[DocumentStatusId] int NULL,
	[OldDocumentStatusId] int NULL,
	[DirectionTypeId] int NULL,
	[SendStatusId] int NULL,
	[OperationTypeId] int NULL,
	[OperationStatusId] int NULL,
	[IsStatus] bit NULL,
	[CreateDate] [datetime] NULL)
