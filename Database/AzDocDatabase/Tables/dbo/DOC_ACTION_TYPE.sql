CREATE TABLE [dbo].[DOC_ACTION_TYPE](
	[ActionTypeId] int identity NOT NULL,
	[ActionId] int NOT NULL,
	[DocTypeId] int NULL,
	[DocumentStatusId] int NULL,
	[DirectionType] int NULL,
	[OrganizationId] int NULL)
