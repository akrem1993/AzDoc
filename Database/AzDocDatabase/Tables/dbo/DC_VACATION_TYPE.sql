CREATE TABLE [dbo].[DC_VACATION_TYPE](
	[Id] int identity NOT NULL,
	[VacationTypeName] nvarchar(50) NOT NULL,
	[VacationTypeStatus] bit NOT NULL CONSTRAINT [DF_DC_VACATION_TYPE_VacationTypeStatus]  DEFAULT 1,
 CONSTRAINT [PK_DC_VACATION_TYPE] PRIMARY KEY ([Id])
)
