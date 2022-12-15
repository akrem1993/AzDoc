CREATE TABLE [dbo].[DC_PERSONNEL_SIGN](
	[PersonelSignId] int identity NOT NULL,
	[PersonnelId] int NULL,
	[PersonnelSignPath] nvarchar(max) NOT NULL,
	[PersonnelSignInsertDate] [datetime] NULL,
	[PersonnelSignTypeId] int NULL,
	[PersonnelSignStatus] bit NULL,
    CONSTRAINT [PK_DC_PERSONEL_SIGN] PRIMARY KEY ([PersonelSignId])
 )
