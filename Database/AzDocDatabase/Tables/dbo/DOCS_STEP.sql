CREATE TABLE [dbo].[DOCS_STEP](
	[StepId] int identity NOT NULL,
	[StepDocId] int NOT NULL,
	[StepFrom] int NOT NULL,
	[StepTo] int NULL,
	[StepExecutorId] int NULL,
	[StepSendedtoId] int NULL,
    CONSTRAINT [PK_DOCS_STEP] PRIMARY KEY ([StepId]),
    CONSTRAINT [FK_DOCS_STEP_DOCS] FOREIGN KEY([StepDocId]) REFERENCES [dbo].[DOCS] ([DocId]),
    CONSTRAINT [FK_DOCS_STEP_DOCS_EXECUTOR] FOREIGN KEY([StepExecutorId]) REFERENCES [dbo].[DOCS_EXECUTOR] ([ExecutorId])
)
