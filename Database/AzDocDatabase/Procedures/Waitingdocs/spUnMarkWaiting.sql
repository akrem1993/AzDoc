CREATE PROCEDURE [WaitingDocs].[spUnMarkWaiting]
	@docId int,@workplaceId int
AS
BEGIN

--declare @docId int=114613,@workplaceId int=48
declare @errMessage nvarchar(200),@transactionId varchar(32)=lower(replace(newid(),'-','')),@transactionDate datetime=getdate();



if @docId<1 return;

begin try
begin tran
   if not exists(select top(1) 0 from [WaitingDocs].[DOCS] where DocId=@docId and [RecoveryDate] is null and WorkplaceId=@workplaceId)
	begin
	  set @errMessage=N'Sənəd gözləmədə deyil ('+replace(str(@docId),space(1),'')+')';
	  throw 50001,@errMessage,11;
	end

	UPDATE d
	SET
	    DocPeriodId = wd.DocPeriodId,DocOrganizationId = wd.DocOrganizationId,DocDoctypeId = wd.DocDoctypeId, DocEnterdate = wd.DocEnterdate, DocEnternop1  = wd.DocEnternop1, DocEnternop2  = wd.DocEnternop2,DocEnternop3 = wd.DocEnternop3,DocEnternop4  = wd.DocEnternop4, 
	    DocRegisterId = wd.DocRegisterId,DocEnternoControl  = wd.DocEnternoControl, DocDocno = wd.DocDocno,DocDocdate = wd.DocDocdate, DocDuplicateDocId = wd.DocDuplicateDocId,DocDuplicateId = wd.DocDuplicateId,DocFormId = wd.DocFormId,DocReceivedFormId = wd.DocReceivedFormId,DocBarcode = wd.DocBarcode, 
	    DocPageCount = wd.DocPageCount,DocCopiesCount = wd.DocCopiesCount,DocAttachmentCount = wd.DocAttachmentCount,DocAppliertypeId = wd.DocAppliertypeId,DocUndercontrolStatusId = wd.DocUndercontrolStatusId,DocUndercontrolDayCount = wd.DocUndercontrolDayCount,DocControlStatusId = wd.DocControlStatusId,DocControlDayCount = wd.DocControlDayCount, 
	    DocDocumentstatusId = wd.DocDocumentstatusId,DocDescriptionId = wd.DocDescriptionId,DocDescription = wd.DocDescription,DocDescriptionR = wd.DocDescriptionR,DocMainExecutorId = wd.DocMainExecutorId,DocTopDepartmentId = wd.DocTopDepartmentId,DocPlannedDate = wd.DocPlannedDate,DocPlannedDateI = wd.DocPlannedDateI, 
	    DocPlannedDateD = wd.DocPlannedDateD,DocReportedDate = wd.DocReportedDate,DocReportNote = wd.DocReportNote,DocExecutedDate = wd.DocExecutedDate,DocProlongDate = wd.DocProlongDate,DocSendDate = wd.DocSendDate,DocControlNotes = wd.DocControlNotes,DocApplytypeId = wd.DocApplytypeId,DocTopicId = wd.DocTopicId, 
	    DocExecutionStatusId = wd.DocExecutionStatusId,DocSendedDocumentId = wd.DocSendedDocumentId,DocRelatedNIdn = wd.DocRelatedNIdn,DocRelatedtoSendedDocumentId = wd.DocRelatedtoSendedDocumentId,DocSendTypeId = wd.DocSendTypeId,DocTemplateId = wd.DocTemplateId,DocClosed = wd.DocClosed,DocDeleted = wd.DocDeleted, 
	    DocDeletedById = wd.DocDeletedById,DocDeletedByDate = wd.DocDeletedByDate,DocInsertedById = wd.DocInsertedById,DocInsertedByDate = wd.DocInsertedByDate,DocUpdatedById = wd.DocUpdatedById,DocUpdatedByDate = wd.DocUpdatedByDate,DocTopicType = wd.DocTopicType,DocIsAppealBoard = wd.DocIsAppealBoard,DocReportedWorkplaceId = wd.DocReportedWorkplaceId, 
	    DocDocumentOldStatusId = wd.DocDocumentOldStatusId, DocResultId = wd.DocResultId,DocNormTypeId = wd.DocNormTypeId,DocSendById = wd.DocSendById,DocPrintedById = wd.DocPrintedById,DocPrintedDate = wd.DocPrintedDate	
	--select * 
	from [dbo].[DOCS] d
	join [WaitingDocs].[DOCS] wd ON d.DocId=wd.DocId
	where [RecoveryDate] is null and wd.DocId=@docId and WorkplaceId=@workplaceId;

	update [WaitingDocs].[DOCS] set [RecoveryDate]=@transactionDate,TransactionId=@transactionId  where [RecoveryDate] is null and DocId=@docId and WorkplaceId=@workplaceId;


	if @@ROWCOUNT<1
		begin
		  set @errMessage=N'Sənəd gözləmədə deyil ('+replace(str(@docId),space(1),'')+')';
		  throw 50001,@errMessage,11;
		end
	
		--directions
	UPDATE [WaitingDocs].[DOCS_DIRECTIONS]
	set [RecoveryDate]=@transactionDate,TransactionId=@transactionId 
	WHERE [DirectionDocId]=@docId and [RecoveryDate] is null;

	SET IDENTITY_INSERT [dbo].[DOCS_DIRECTIONS] ON
	INSERT INTO [dbo].[DOCS_DIRECTIONS]([DirectionId],[DirectionDocId],[DirectionDate],[DirectionWorkplaceId],[DirectionPersonFullName],[DirectionTemplateId],[DirectionTypeId]
				,[DirectionControlStatus],[DirectionPlanneddate],[DirectionPlannedDay],[DirectionExecutionStatusId],[DirectionVizaId],[DirectionConfirmed]
				,[DirectionSendStatus],[DirectionCreatorWorkplaceId],[DirectionInsertedDate],[DirectionPersonId],[DirectionUnixTime],[DirectionNote]
				,[DirectionConfirmPersonId],[DirectionConfirmWorkplaceId])
	select [DirectionId],[DirectionDocId],[DirectionDate],[DirectionWorkplaceId],[DirectionPersonFullName],[DirectionTemplateId],[DirectionTypeId]
				,[DirectionControlStatus],[DirectionPlanneddate],[DirectionPlannedDay],[DirectionExecutionStatusId],[DirectionVizaId],[DirectionConfirmed]
				,[DirectionSendStatus],[DirectionCreatorWorkplaceId],[DirectionInsertedDate],[DirectionPersonId],[DirectionUnixTime],[DirectionNote]
				,[DirectionConfirmPersonId],[DirectionConfirmWorkplaceId] 
	from [WaitingDocs].[DOCS_DIRECTIONS] where [DirectionDocId]=@docId and [TransactionId]=@transactionId
	SET IDENTITY_INSERT [dbo].[DOCS_DIRECTIONS] OFF

		--executors
	UPDATE [WaitingDocs].[DOCS_EXECUTOR]
	set [RecoveryDate]=@transactionDate,TransactionId=@transactionId 
	WHERE [ExecutorDocId]=@docId and [RecoveryDate] is null;

	SET IDENTITY_INSERT [dbo].[DOCS_EXECUTOR] ON
	INSERT INTO [dbo].[DOCS_EXECUTOR]([ExecutorId],[ExecutorDirectionId],[ExecutorDocId],[ExecutorWorkplaceId],[ExecutorFullName],[ExecutorMain],[DirectionTypeId],[ExecutorOrganizationId]
	,[ExecutorTopDepartment],[ExecutorDepartment],[ExecutorSection],[ExecutorSubsection],[ExecutorStepId],[ExecutionstatusId],[ExecutorNote]
	,[ExecutorReadStatus],[ExecutorResolutionNote],[SendStatusId],[ExecutorPersonId],[ExecutorStatus],[ExecutorConfirmed],[ExecutorNotDeleted]
	,[ExecutorControlStatus],[ExecutorTopId])
	select [ExecutorId],[ExecutorDirectionId],[ExecutorDocId],[ExecutorWorkplaceId],[ExecutorFullName],[ExecutorMain],[DirectionTypeId],[ExecutorOrganizationId]
	,[ExecutorTopDepartment],[ExecutorDepartment],[ExecutorSection],[ExecutorSubsection],[ExecutorStepId],[ExecutionstatusId],[ExecutorNote]
	,[ExecutorReadStatus],[ExecutorResolutionNote],[SendStatusId],[ExecutorPersonId],[ExecutorStatus],[ExecutorConfirmed],[ExecutorNotDeleted]
	,[ExecutorControlStatus],[ExecutorTopId]
	 from [WaitingDocs].[DOCS_EXECUTOR] where [ExecutorDocId]=@docId and [TransactionId]=@transactionId
	SET IDENTITY_INSERT [dbo].[DOCS_EXECUTOR] OFF

		--doc files
	UPDATE [WaitingDocs].[DOCS_FILE]
	set [RecoveryDate]=@transactionDate,TransactionId=@transactionId 
	WHERE [FileDocId]=@docId and [RecoveryDate] is null;

	SET IDENTITY_INSERT [dbo].[DOCS_FILE] ON
	INSERT INTO [dbo].[DOCS_FILE]([FileId],[FileDocId],[FileInfoId],[FileName],[FileVisaStatus],[SignatureStatusId],[FileCurrentVisaGroup],[FileIsMain],[SignatureNote],[IsDeleted],[IsReject],[SignatureWorkplaceId],[SignatureDate])
	select [FileId],[FileDocId],[FileInfoId],[FileName],[FileVisaStatus],[SignatureStatusId],[FileCurrentVisaGroup],[FileIsMain],[SignatureNote],[IsDeleted],[IsReject],[SignatureWorkplaceId],[SignatureDate] from [WaitingDocs].[DOCS_FILE]
	where [FileDocId]=@docId and [TransactionId]=@transactionId
	SET IDENTITY_INSERT [dbo].[DOCS_FILE] OFF


		--releteds
	UPDATE [WaitingDocs].[DOCS_RELATED]
	set [RecoveryDate]=@transactionDate,TransactionId=@transactionId
	WHERE [RecoveryDate] IS NULL and DocId=@docId;

	SET IDENTITY_INSERT [dbo].[DOCS_RELATED] ON
	insert into [dbo].[DOCS_RELATED]([RelatedId],[RelatedDocId],[RelatedDocumentId],[RelatedTypeId])
	select [RelatedId],[RelatedDocId],[RelatedDocumentId],[RelatedTypeId] from [WaitingDocs].[DOCS_RELATED] where DocId=@docId  and [TransactionId]=@transactionId;
	SET IDENTITY_INSERT [dbo].[DOCS_RELATED] OFF

	commit;
end try
begin catch
rollback;
	--exec dbo.spError @workplaceId=@workplaceId,@transactionId=@transactionId
end catch

END

