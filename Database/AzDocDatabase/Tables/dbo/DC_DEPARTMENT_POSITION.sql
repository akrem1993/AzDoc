CREATE TABLE [dbo].[DC_DEPARTMENT_POSITION](
	[DepartmentPositionId] int identity NOT NULL,
	[DepartmentId] int NOT NULL,
	[PositionGroupId] int NULL,
	[DepartmentPositionName] nvarchar(100) NULL,
	[DepartmentPositionIndex] nvarchar(25) NULL,
	[DepartmentPositionStatus] bit NULL CONSTRAINT [DF_DC_DEPARTMENT_POSITION_DepartmentPositionStatus]  DEFAULT 1,
	[DepartmentPositionNameEn] nvarchar(100) NULL,
	[DepartmentPositionNameRu] nvarchar(100) NULL,
    CONSTRAINT [PK_DC_DEPARTMENT_POSITION] PRIMARY KEY ([DepartmentPositionId]),
    CONSTRAINT [FK_DC_DEPARTMENT_POSITION_DC_DEPARTMENT] FOREIGN KEY([DepartmentId]) REFERENCES [dbo].[DC_DEPARTMENT] ([DepartmentId]),
	CONSTRAINT [FK_DC_DEPARTMENT_POSITION_DC_POSITION_GROUP] FOREIGN KEY([PositionGroupId]) REFERENCES [dbo].[DC_POSITION_GROUP] ([PositionGroupId])
 )
