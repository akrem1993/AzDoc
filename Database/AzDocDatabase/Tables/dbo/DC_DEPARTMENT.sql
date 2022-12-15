CREATE TABLE [dbo].[DC_DEPARTMENT](
	[DepartmentId] int identity NOT NULL,
	[DepartmentName] nvarchar(250) NULL,
	[DepartmentOrganization] int NULL,
	[DepartmentTopId] int NULL,
	[DepartmentTypeId] int NULL,
	[DepartmentVirtual] int NULL,
	[DepartmentOrderindex] int NULL,
	[DepartmentIndex] nvarchar(10) NULL,
	[DepartmentCode] int NULL,
	[DepartmentTopDepartmentId] int NULL,
	[DepartmentDepartmentId] int NULL,
	[DepartmentSectionId] int NULL,
	[DepartmentSubSectionId] int NULL,
	[DepartmentStatus] bit NULL CONSTRAINT [DF_DC_DEPARTMENT_DepartmentStatus]  DEFAULT 1,
	CONSTRAINT [FK_DC_DEPARTMENT_DC_DEPARTMENT1] FOREIGN KEY([DepartmentDepartmentId]) REFERENCES [dbo].[DC_DEPARTMENT] ([DepartmentId]),
    CONSTRAINT [PK_DC_DEPARTMENT] PRIMARY KEY CLUSTERED ([DepartmentId])
)
