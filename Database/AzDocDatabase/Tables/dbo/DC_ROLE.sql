CREATE TABLE [dbo].[DC_ROLE](
	[RoleId] int NOT NULL,
	[RoleName] nvarchar(50) NOT NULL,
	[RoleComment] nvarchar(100) NULL,
	[RoleApplicationId] int NULL,
	[RoleStatus] bit NULL CONSTRAINT [DF__DC_ROLE__RoleSta__7E8CC4B1]  DEFAULT 1,
	CONSTRAINT [PK_DC_ROLE] PRIMARY KEY ([RoleId]),
	CONSTRAINT [FK_DC_ROLE_DC_APPLICATION] FOREIGN KEY([RoleApplicationId]) REFERENCES [dbo].[DC_APPLICATION] ([ApplicationId])
)
