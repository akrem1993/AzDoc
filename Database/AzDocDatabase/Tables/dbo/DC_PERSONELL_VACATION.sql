CREATE TABLE [dbo].[DC_PERSONELL_VACATION](
	[PersonellVacationId] int identity NOT NULL,
	[WorkplaceId] int NOT NULL,
	[ActingWorkplaceId] int NULL,
	[VacationTypeId] int NOT NULL,
	[BeginDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Status] bit NOT NULL CONSTRAINT [DF_DC_PERSONELL_VACATION_Status]  DEFAULT 1,
 CONSTRAINT [PK_DC_PERSONELL_VACATION] PRIMARY KEY ([PersonellVacationId]),
 CONSTRAINT [FK_DC_PERSONELL_VACATION_DC_WORKPLACE] FOREIGN KEY([ActingWorkplaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId])
 )
