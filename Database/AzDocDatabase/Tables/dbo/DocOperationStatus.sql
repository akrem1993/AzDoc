CREATE TABLE [dbo].[DocOperationStatus](
	[StatusId] int identity NOT NULL,
	[StatusName] nvarchar(max) NULL,
	[IsDeleted] bit NULL)