CREATE TABLE [dbo].[DC_WORKPLACE](
	[WorkplaceId] int identity NOT NULL,
	[WorkplaceUserId] int NULL,
	[WorkplaceOrganizationId] int NOT NULL,
	[WorkplaceDepartmentId] int NOT NULL,
	[WorkplaceDepartmentPositionId] int NOT NULL,
	[WorkPlaceStatus] bit NULL CONSTRAINT DfDC_WORKPLACEWorkPlaceStatus DEFAULT 1,
    CONSTRAINT [PK_DC_WORKPLACE] PRIMARY KEY ([WorkplaceId]),
    CONSTRAINT [FK_DC_WORKPLACE_DC_DEPARTMENT] FOREIGN KEY([WorkplaceDepartmentId]) REFERENCES [dbo].[DC_DEPARTMENT] ([DepartmentId]),
    CONSTRAINT [FK_DC_WORKPLACE_DC_DEPARTMENT_POSITION] FOREIGN KEY([WorkplaceDepartmentPositionId]) REFERENCES [dbo].[DC_DEPARTMENT_POSITION] ([DepartmentPositionId]),
    CONSTRAINT [FK_DC_WORKPLACE_DC_ORGANIZATION] FOREIGN KEY([WorkplaceOrganizationId]) REFERENCES [dbo].[DC_ORGANIZATION] ([OrganizationId]),
    CONSTRAINT [FK_DC_WORKPLACE_DC_USER] FOREIGN KEY([WorkplaceUserId]) REFERENCES [dbo].[DC_USER] ([UserId])
 )
