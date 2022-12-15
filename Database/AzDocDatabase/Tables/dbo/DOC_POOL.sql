CREATE TABLE [dbo].[DOC_POOL](
	[PoolId] int identity NOT NULL,
	[PoolName] nvarchar(50) NOT NULL,
	[PoolCurrentNumber] int NULL,
 CONSTRAINT [PK_DOC_POOL] PRIMARY KEY ([PoolId])
 )
