CREATE TABLE [dbo].[DocOperationTypes](
	[TypeId] int identity NOT NULL,
	[TypeName] nvarchar(max) NOT NULL,
	[IsDeleted] bit NULL
)