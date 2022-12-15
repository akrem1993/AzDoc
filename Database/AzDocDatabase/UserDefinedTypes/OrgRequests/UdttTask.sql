CREATE TYPE [orgrequests].[UdttTask] AS TABLE(
	[TypeOfAssignment] int NOT NULL,
	[TaskNo] [decimal](18, 9) NOT NULL,
	[Task] nvarchar(max) NOT NULL,
	[WhomAddressId] int NOT NULL
)