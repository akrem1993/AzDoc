
CREATE PROCEDURE [WaitingDocs].[spMarkAsWaiting]
	@docId int,@workplaceId int
AS
BEGIN
--@docId int=114613,@workplaceId int=48
declare @errMessage nvarchar(200);


if @docId<1 return;
/*
select * from [WaitingDocs].DOCS where DocId=114613
SELECT * FROM [WaitingDocs].DOCS_DIRECTIONS dd WHERE dd.DirectionDocId=114613
SELECT * FROM [WaitingDocs].DOCS_EXECUTOR de WHERE de.ExecutorDocId=114613

SELECT * FROM [WaitingDocs].DOCS_FILE df WHERE df.FileDocId=114613
select* FROM  [WaitingDocs].DOCS_RELATED dr WHERE dr.RelatedDocId=114613
SELECT * FROM [WaitingDocs].DOCS_APPLICATION da WHERE da.AppDocId=114613
*/
begin try
begin tran
	UPDATE dbo.DOCS
	SET
	    DocPeriodId = NULL,DocOrganizationId = 0,DocDoctypeId = 0, DocEnterdate = NULL, /*DocEnterno  = NULL,*/DocEnternop1  = NULL, DocEnternop2  = NULL,DocEnternop3 = NULL,DocEnternop4  = NULL, 
	    DocRegisterId = NULL,DocEnternoControl  = NULL, DocDocno = NULL,DocDocdate = NULL, DocDuplicateDocId = NULL,DocDuplicateId = NULL,DocFormId = NULL,DocReceivedFormId = NULL,DocBarcode = NULL, 
	    DocPageCount = NULL,DocCopiesCount = NULL,DocAttachmentCount = NULL,DocAppliertypeId = NULL,DocUndercontrolStatusId = 0,DocUndercontrolDayCount = NULL,DocControlStatusId = 0,DocControlDayCount = NULL, 
	    DocDocumentstatusId = NULL,DocDescriptionId = NULL,DocDescription = NULL,DocDescriptionR = NULL,DocMainExecutorId = NULL,DocTopDepartmentId = NULL,DocPlannedDate = NULL,DocPlannedDateI = NULL, 
	    DocPlannedDateD = NULL,DocReportedDate = NULL,DocReportNote = NULL,DocExecutedDate = NULL,DocProlongDate = NULL,DocSendDate = NULL,DocControlNotes = NULL,DocApplytypeId = NULL,DocTopicId = NULL, 
	    DocExecutionStatusId = NULL,DocSendedDocumentId = NULL,DocRelatedNIdn = NULL,DocRelatedtoSendedDocumentId = NULL,DocSendTypeId = NULL,DocTemplateId = NULL,DocClosed = NULL,DocDeleted = NULL, 
	    DocDeletedById = NULL,DocDeletedByDate = NULL,DocInsertedById = NULL,DocInsertedByDate = NULL,DocUpdatedById = NULL,DocUpdatedByDate = NULL,DocTopicType = NULL,DocIsAppealBoard = 0,DocReportedWorkplaceId = NULL, 
	    DocDocumentOldStatusId = NULL, DocResultId = NULL,DocNormTypeId = NULL,DocSendById = NULL,DocPrintedById = NULL,DocPrintedDate = NULL			
	OUTPUT deleted.DocId,
		deleted.[DocPeriodId],deleted.[DocOrganizationId],deleted.[DocDoctypeId],deleted.[DocEnterdate],deleted.[DocEnterno],deleted.[DocEnternop1],deleted.[DocEnternop2],deleted.[DocEnternop3],deleted.[DocEnternop4]
		,deleted.[DocRegisterId],deleted.[DocEnternoControl],deleted.[DocDocno],deleted.[DocDocdate],deleted.[DocDuplicateDocId],deleted.[DocDuplicateId],deleted.[DocFormId]
		,deleted.[DocReceivedFormId],deleted.[DocBarcode],deleted.[DocPageCount],deleted.[DocCopiesCount],deleted.[DocAttachmentCount],deleted.[DocAppliertypeId]
		,deleted.[DocUndercontrolStatusId],deleted.[DocUndercontrolDayCount],deleted.[DocControlStatusId],deleted.[DocControlDayCount],deleted.[DocDocumentstatusId]
		,deleted.[DocDescriptionId],deleted.[DocDescription],deleted.[DocDescriptionR],deleted.[DocMainExecutorId],deleted.[DocTopDepartmentId],deleted.[DocPlannedDate]
		,deleted.[DocPlannedDateI],deleted.[DocPlannedDateD],deleted.[DocReportedDate],deleted.[DocReportNote],deleted.[DocExecutedDate],deleted.[DocProlongDate]
		,deleted.[DocSendDate],deleted.[DocControlNotes],deleted.[DocApplytypeId],deleted.[DocTopicId],deleted.[DocExecutionStatusId],deleted.[DocSendedDocumentId]
		,deleted.[DocRelatedNIdn],deleted.[DocRelatedtoSendedDocumentId],deleted.[DocSendTypeId],deleted.[DocTemplateId],deleted.[DocClosed],deleted.[DocDeleted]
		,deleted.[DocDeletedById],deleted.[DocDeletedByDate],deleted.[DocInsertedById],deleted.[DocInsertedByDate],deleted.[DocUpdatedById],deleted.[DocUpdatedByDate]
		,deleted.[DocTopicType],deleted.[DocIsAppealBoard],deleted.[DocReportedWorkplaceId],deleted.[DocDocumentOldStatusId],deleted.[DocResultId]
		,deleted.[DocNormTypeId],deleted.[DocSendById],deleted.[DocPrintedById],deleted.[DocPrintedDate],@workplaceId
	INTO [WaitingDocs].docs(
	[DocId],[DocPeriodId],[DocOrganizationId],[DocDoctypeId],[DocEnterdate],[DocEnterno],[DocEnternop1],[DocEnternop2],[DocEnternop3],[DocEnternop4],[DocRegisterId]
		 ,[DocEnternoControl],[DocDocno],[DocDocdate],[DocDuplicateDocId],[DocDuplicateId],[DocFormId],[DocReceivedFormId],[DocBarcode],[DocPageCount],[DocCopiesCount],[DocAttachmentCount],[DocAppliertypeId]		
		 ,[DocUndercontrolStatusId],[DocUndercontrolDayCount],[DocControlStatusId],[DocControlDayCount],[DocDocumentstatusId]
		 ,[DocDescriptionId],[DocDescription],[DocDescriptionR],[DocMainExecutorId],[DocTopDepartmentId],[DocPlannedDate]		
		 ,[DocPlannedDateI],[DocPlannedDateD],[DocReportedDate],[DocReportNote],[DocExecutedDate],[DocProlongDate]		
		 ,[DocSendDate],[DocControlNotes],[DocApplytypeId],[DocTopicId],[DocExecutionStatusId],[DocSendedDocumentId]
		 ,[DocRelatedNIdn],[DocRelatedtoSendedDocumentId],[DocSendTypeId],[DocTemplateId],[DocClosed],[DocDeleted]		
		 ,[DocDeletedById],[DocDeletedByDate],[DocInsertedById],[DocInsertedByDate],[DocUpdatedById],[DocUpdatedByDate]		
		 ,[DocTopicType],[DocIsAppealBoard],[DocReportedWorkplaceId],[DocDocumentOldStatusId],[DocResultId],[DocNormTypeId],[DocSendById],[DocPrintedById],[DocPrintedDate],[WorkplaceId])
	WHERE DocDoctypeId<>0 and DocId=@docId;	

	if @@ROWCOUNT < 1
	begin
	  set @errMessage=N'Aktiv sənəd tapılmadı ('+replace(str(@docId),space(1),'')+')';
	  throw 50001,@errMessage,11;
	end


		--releteds
	DELETE FROM [dbo].[DOCS_RELATED]
	OUTPUT deleted.[RelatedId],deleted.[RelatedDocId],deleted.[RelatedDocumentId],deleted.[RelatedTypeId],@workplaceId,@docId
	INTO [WaitingDocs].[DOCS_RELATED]([RelatedId],[RelatedDocId],[RelatedDocumentId],[RelatedTypeId],[WorkplaceId],[DocId])
	WHERE @docId IN (isnull(RelatedDocId,0),isnull(RelatedDocumentId,0))

		--executors
	DELETE FROM [dbo].[DOCS_EXECUTOR]
	OUTPUT deleted.[ExecutorId],deleted.[ExecutorDirectionId],deleted.[ExecutorDocId],deleted.[ExecutorWorkplaceId],deleted.[ExecutorFullName],deleted.[ExecutorMain],deleted.[DirectionTypeId],deleted.[ExecutorOrganizationId]
	,deleted.[ExecutorTopDepartment],deleted.[ExecutorDepartment],deleted.[ExecutorSection],deleted.[ExecutorSubsection],deleted.[ExecutorStepId],deleted.[ExecutionstatusId],deleted.[ExecutorNote]
	,deleted.[ExecutorReadStatus],deleted.[ExecutorResolutionNote],deleted.[SendStatusId],deleted.[ExecutorPersonId],deleted.[ExecutorStatus],deleted.[ExecutorConfirmed],deleted.[ExecutorNotDeleted]
	,deleted.[ExecutorControlStatus],deleted.[ExecutorTopId],@workplaceId
	INTO [WaitingDocs].[DOCS_EXECUTOR]
     ([ExecutorId],[ExecutorDirectionId],[ExecutorDocId],[ExecutorWorkplaceId],[ExecutorFullName],[ExecutorMain],[DirectionTypeId],[ExecutorOrganizationId]
	,[ExecutorTopDepartment],[ExecutorDepartment],[ExecutorSection],[ExecutorSubsection],[ExecutorStepId],[ExecutionstatusId],[ExecutorNote]
	,[ExecutorReadStatus],[ExecutorResolutionNote],[SendStatusId],[ExecutorPersonId],[ExecutorStatus],[ExecutorConfirmed],[ExecutorNotDeleted]
	,[ExecutorControlStatus],[ExecutorTopId],[WorkplaceId])
	WHERE [ExecutorDocId]=@docId;
	
		--directions
	DELETE FROM [dbo].[DOCS_DIRECTIONS]
	OUTPUT deleted.[DirectionId],deleted.[DirectionDocId],deleted.[DirectionDate],deleted.[DirectionWorkplaceId],deleted.[DirectionPersonFullName],deleted.[DirectionTemplateId]
		   ,deleted.[DirectionTypeId],deleted.[DirectionControlStatus],deleted.[DirectionPlanneddate],deleted.[DirectionPlannedDay],deleted.[DirectionExecutionStatusId]
		   ,deleted.[DirectionVizaId],deleted.[DirectionConfirmed],deleted.[DirectionSendStatus],deleted.[DirectionCreatorWorkplaceId],deleted.[DirectionInsertedDate]
		   ,deleted.[DirectionPersonId],deleted.[DirectionUnixTime],deleted.[DirectionNote],deleted.[DirectionConfirmPersonId],deleted.[DirectionConfirmWorkplaceId],@workplaceId
	INTO [WaitingDocs].[DOCS_DIRECTIONS]
	([DirectionId],[DirectionDocId],[DirectionDate],[DirectionWorkplaceId],[DirectionPersonFullName],[DirectionTemplateId],[DirectionTypeId]
				,[DirectionControlStatus],[DirectionPlanneddate],[DirectionPlannedDay],[DirectionExecutionStatusId],[DirectionVizaId],[DirectionConfirmed]
				,[DirectionSendStatus],[DirectionCreatorWorkplaceId],[DirectionInsertedDate],[DirectionPersonId],[DirectionUnixTime],[DirectionNote]
				,[DirectionConfirmPersonId],[DirectionConfirmWorkplaceId],[WorkplaceId])
	WHERE [DirectionDocId]=@docId;

		--doc files
	DELETE FROM [dbo].[DOCS_FILE]
	OUTPUT deleted.[FileId],deleted.[FileDocId],deleted.[FileInfoId],deleted.[FileName],deleted.[FileVisaStatus],deleted.[SignatureStatusId],deleted.[FileCurrentVisaGroup]
		   ,deleted.[FileIsMain],deleted.[SignatureNote],deleted.[IsDeleted],deleted.[IsReject],deleted.[SignatureWorkplaceId],deleted.[SignatureDate],@workplaceId
	INTO [WaitingDocs].[DOCS_FILE]
    ([FileId],[FileDocId],[FileInfoId],[FileName],[FileVisaStatus],[SignatureStatusId],[FileCurrentVisaGroup],[FileIsMain],[SignatureNote],[IsDeleted],[IsReject],[SignatureWorkplaceId],[SignatureDate],[WorkplaceId])
	WHERE [FileDocId]=@docId;

	commit;
end try
begin catch
rollback;
	--exec dbo.spError @workplaceId=@workplaceId
end catch

END