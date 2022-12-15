CREATE TABLE [dbo].[DC_VACATION](
	[Id] int identity NOT NULL,
	[VacationTypeId] int NOT NULL,
	[VacationWorkplaceId] int NOT NULL,
	[VacationNewUserId] int NOT NULL,
	[VacationOldUserId] int NOT NULL,
	[VacationBeginDate] [datetime] NOT NULL,
	[VacationEndDate] [datetime] NOT NULL,
	[IsActive] bit NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] nvarchar(100) NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] nvarchar(100) NULL,
	[IsDeleted] bit NOT NULL,
	[OldUserLoginAccess] bit NULL,
    CONSTRAINT PkDC_VACATIONId PRIMARY KEY ([Id])
)
