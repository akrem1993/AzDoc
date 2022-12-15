CREATE TABLE [dbo].[DOC_EXECUTIONSTATUS](
	[ExecutionstatusId] int identity NOT NULL,
	[ExecutionstatusName] nvarchar(200) NOT NULL,
	[ExecutionstatusStatus] bit NOT NULL CONSTRAINT [DF__DOC_EXECU__Execu__0504B816]  DEFAULT 1,
    CONSTRAINT [PK_DOC_EXECUTIONSTATUS] PRIMARY KEY ([ExecutionstatusId])
)
