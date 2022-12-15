CREATE TABLE [dbo].[DOC_DIRECTION_TEMPLATE](
	[DirTemplateId] int identity NOT NULL,
	[DirTemplateTreeeId] int NOT NULL,
	[DirTemplateDirectionType] int NOT NULL,
	[DirTemplateWorkplaceId] int NULL,
	[Template] nvarchar(max) NOT NULL,
	[DirtemplateStatus] bit NOT NULL CONSTRAINT [DF__DOC_DIREC__dirte__2779CBAB]  DEFAULT 1,
	[DirTemplateDoctypeId] int NULL,
 CONSTRAINT [PK_DOC_DIRECTION_TEMPLATE] PRIMARY KEY ([DirTemplateId]),
 CONSTRAINT [FK_DOC_DIRECTION_TEMPLATE_DC_WORKPLACE] FOREIGN KEY([DirTemplateWorkplaceId]) REFERENCES [dbo].[DC_WORKPLACE] ([WorkplaceId]),
 CONSTRAINT [FK_DOC_DIRECTION_TEMPLATE_DOC_DIRECTIONTYPE] FOREIGN KEY([DirTemplateDirectionType]) REFERENCES [dbo].[DOC_DIRECTIONTYPE] ([DirectionTypeId])
)
