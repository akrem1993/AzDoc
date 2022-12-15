CREATE TABLE [dbo].[DMSTableRelation](
	[Id] int identity NOT NULL,
	[IdTable] int NOT NULL,
	[RelatedIdTable] int NOT NULL,
 CONSTRAINT [PK_dbo.DMSTableRelation] PRIMARY KEY ([Id]),
 CONSTRAINT [FK_dbo.DMSTableRelation_dbo.DMSTables_IdTable] FOREIGN KEY([IdTable]) REFERENCES [dbo].[DMSTables] ([Id]),
 CONSTRAINT [FK_dbo.DMSTableRelation_dbo.DMSTables_RelatedIdTable] FOREIGN KEY([RelatedIdTable]) REFERENCES [dbo].[DMSTables] ([Id])
)
