CREATE TABLE [dbo].[DOC_CONTROL](
	[ControlId] int NOT NULL,
	[ControlName] nvarchar(50) NOT NULL,
	[ControlStatus] bit NOT NULL CONSTRAINT [DF_DOC_CONTROL_ControlStatus]  DEFAULT 1,
 CONSTRAINT [PK_DOC_CONTROL] PRIMARY KEY ([ControlId])
)