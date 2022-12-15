CREATE TYPE [dbo].[UdttApplication] AS TABLE(
	[AppId] int NULL,
	[DocEnterno] nvarchar(max) NULL,
	[AppFirstname] nvarchar(max) NOT NULL,
	[AppSurname] nvarchar(max) NOT NULL,
	[AppLastName] nvarchar(max) NULL,
	[AppCountryId] int NULL,
	[AppRegionId] int NULL,
	[AppSosialStatusId] int NULL,
	[AppRepresenterId] int NOT NULL,
	[AppAddress] nvarchar(max) NULL,
	[AppPhone] nvarchar(max) NULL,
	[AppEmail] nvarchar(max) NULL,
	[AppFormType] int NULL
)