CREATE TABLE [dbo].[TempDocLogMigrate](
	[DocId] int NULL,
	[ExecutorId] int NULL,
	[SenderWorkPlaceId] int NULL,
	[ReceiverWorkPlaceId] int NULL,
	[DocTypeId] int NULL,
	[OperationTypeId] int NULL,
	[DirectionTypeId] int NULL,
	[OperationDate] [datetime2](3) NULL,
	[OperationStatus] int NULL,
	[OperationStatusDate] [datetime2](3) NULL,
	[OperationNote] [ntext] NULL,
	[IsDeleted] bit NULL,
	[OperationFileId] int NULL
)