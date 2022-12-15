CREATE TABLE [dbo].[DOCS_EXECUTORINFO](
	[Id] int identity NOT NULL,
	[InfoDocId] int NULL,
	[ParentId] int NULL,
	[OrganizationId] int NULL,
	[DepartmentId] int NULL,
	[ExecutorId] int NULL,
	[DocumentStatusId] int NULL,
	[RelatedDocId] int NULL,
	[Owner] bit NULL,
	[LevelIndex] varchar(20) NULL,
    CONSTRAINT [PK_DOCS_EXECUTORINFO] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EXECUTORINFO_DEPARTMENTID] FOREIGN KEY([DepartmentId]) REFERENCES [dbo].[DC_DEPARTMENT] ([DepartmentId]),
	CONSTRAINT [FK_EXECUTORINFO_DOCUMENTSTATUS] FOREIGN KEY([DocumentStatusId]) REFERENCES [dbo].[DOC_DOCUMENTSTATUS] ([DocumentstatusId]),
	CONSTRAINT [FK_EXECUTORINFO_ORGANIZATIONID] FOREIGN KEY([OrganizationId]) REFERENCES [dbo].[DC_ORGANIZATION] ([OrganizationId])
)
