CREATE TABLE [dbo].[DOC_SENDSTATUS_TYPE](
	[SendStatusTypeId] int identity NOT NULL,
	[SendStatusId] int NOT NULL,
	[DocTypeId] int NOT NULL,
	[SendTypeStatus] int NOT NULL)
