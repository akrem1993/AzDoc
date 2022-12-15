/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  musayev nurlan,rufin ehmedov
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[createFakeDocument] @docType INT = 3, 
                                        @docId   INT = 58454
AS
    BEGIN
        DECLARE @newDocId INT,@newDocNo nvarchar(max);

  select @newDocNo = 'LS-' + CONVERT(varchar(max), (select count(0) + 1 from dbo.DOCS d where d.DocDoctypeId=@docType)) + '/' + (SELECT  FORMAT(dbo.SYSDATETIME(), 'yy'))

        IF @docType = 3
            BEGIN
                INSERT INTO dbo.DOCS
                (
                --DocId - column value is auto-generated
                DocPeriodId, 
                DocOrganizationId, 
                DocDoctypeId, 
                DocEnterdate, 
                DocEnterno, 
                DocEnternop1, 
                DocEnternop2, 
                DocEnternop3, 
                DocEnternop4, 
                DocRegisterId, 
                DocEnternoControl, 
                DocDocno, 
                DocDocdate, 
                DocDuplicateDocId, 
                DocDuplicateId, 
                DocFormId, 
                DocReceivedFormId, 
                DocBarcode, 
                DocPageCount, 
                DocCopiesCount, 
                DocAttachmentCount, 
                DocAppliertypeId, 
                DocUndercontrolStatusId, 
                DocUndercontrolDayCount, 
                DocControlStatusId, 
                DocControlDayCount, 
                DocDocumentstatusId, 
                DocDescriptionId, 
                DocDescription, 
                DocDescriptionR, 
                DocMainExecutorId, 
                DocTopDepartmentId, 
                DocPlannedDate, 
                DocPlannedDateI, 
                DocPlannedDateD, 
                DocReportedDate, 
                DocReportNote, 
                DocExecutedDate, 
                DocProlongDate, 
                DocSendDate, 
                DocControlNotes, 
                DocApplytypeId, 
                DocTopicId, 
                DocExecutionStatusId, 
                DocSendedDocumentId, 
                DocRelatedNIdn, 
                DocRelatedtoSendedDocumentId, 
                DocSendTypeId, 
                DocTemplateId, 
                DocClosed, 
                DocDeleted, 
                DocDeletedById, 
                DocDeletedByDate, 
                DocInsertedById, 
                DocInsertedByDate, 
                DocUpdatedById, 
                DocUpdatedByDate, 
                DocTopicType, 
                DocIsAppealBoard, 
                DocReportedWorkplaceId, 
                DocDocumentOldStatusId, 
                DocResultId
                )
                       SELECT d.DocPeriodId, 
                              d.DocOrganizationId, 
                              d.DocDoctypeId, 
                              dbo.SYSDATETIME(), 
                              d.DocEnterno, 
                              d.DocEnternop1, 
                              d.DocEnternop2, 
                              d.DocEnternop3, 
                              d.DocEnternop4, 
                              d.DocRegisterId, 
                              d.DocEnternoControl, 
                              @newDocNo, 
                              dbo.SYSDATETIME(), 
                              d.DocDuplicateDocId, 
                              d.DocDuplicateId, 
                              d.DocFormId, 
                              d.DocReceivedFormId, 
                              d.DocBarcode, 
                              d.DocPageCount, 
                              d.DocCopiesCount, 
                              d.DocAttachmentCount, 
                              d.DocAppliertypeId, 
                              d.DocUndercontrolStatusId, 
                              d.DocUndercontrolDayCount, 
                              d.DocControlStatusId, 
                              d.DocControlDayCount, 
                              d.DocDocumentstatusId, 
                              d.DocDescriptionId, 
                              d.DocDescription, 
                              d.DocDescriptionR, 
                              d.DocMainExecutorId, 
                              d.DocTopDepartmentId, 
                              d.DocPlannedDate, 
                              d.DocPlannedDateI, 
                              d.DocPlannedDateD, 
                              d.DocReportedDate, 
                              d.DocReportNote, 
                              d.DocExecutedDate, 
                              d.DocProlongDate, 
                              d.DocSendDate, 
                              d.DocControlNotes, 
                              d.DocApplytypeId, 
                              d.DocTopicId, 
                              d.DocExecutionStatusId, 
                              d.DocSendedDocumentId, 
                              d.DocRelatedNIdn, 
                              d.DocRelatedtoSendedDocumentId, 
                              d.DocSendTypeId, 
                              d.DocTemplateId, 
                              0, 
                              0, 
                              d.DocDeletedById, 
                              dbo.SYSDATETIME(), 
                              d.DocInsertedById, 
                              dbo.SYSDATETIME(), 
                              d.DocUpdatedById, 
                              d.DocUpdatedByDate, 
                              d.DocTopicType, 
                              d.DocIsAppealBoard, 
                              d.DocReportedWorkplaceId, 
                              d.DocDocumentOldStatusId, 
                              d.DocResultId
                       FROM dbo.DOCS d
                       WHERE d.DocId = @docId;



                SET @newDocId = SCOPE_IDENTITY();

                DECLARE @newDirectionId INT, @dirCount INT;
    DECLARE @DirTable TABLE (DirectionId int,Rownumber int)
    DECLARE @ExecTable TABLE (ExecutorId int,Rownumber int)

                SELECT @dirCount = COUNT(0)
                FROM dbo.DOCS_DIRECTIONS dd
                WHERE dd.DirectionDocId = @docId;

    INSERT @DirTable
    (
        DirectionId,
        Rownumber
    )
    SELECT dd.DirectionId,ROW_NUMBER() OVER(ORDER BY dd.DirectionId) FROM dbo.DOCS_DIRECTIONS dd WHERE dd.DirectionDocId=@docId

    INSERT @ExecTable
    (
        ExecutorId,
        Rownumber
    )
    SELECT de.ExecutorId,ROW_NUMBER() OVER(ORDER BY de.ExecutorId) FROM dbo.DOCS_EXECUTOR de WHERE de.ExecutorDocId=@docId
    
                WHILE @dirCount > 0
                    BEGIN
                        INSERT INTO dbo.DOCS_DIRECTIONS
                        (
                        --DirectionId - column value is auto-generated
                        DirectionDocId, 
                        DirectionDate, 
                        DirectionWorkplaceId, 
                        DirectionPersonFullName, 
                        DirectionTemplateId, 
                        DirectionTypeId, 
                        DirectionControlStatus, 
                        DirectionPlanneddate, 
                        DirectionPlannedDay, 
                        DirectionExecutionStatusId, 
                        DirectionVizaId, 
                        DirectionConfirmed, 
                        DirectionSendStatus, 
                        DirectionCreatorWorkplaceId, 
                        DirectionInsertedDate, 
                        DirectionPersonId, 
                        DirectionUnixTime
                        )
                               SELECT @newDocId, 
                                      dbo.SYSDATETIME(), 
                                      dd.DirectionWorkplaceId, 
                                      dd.DirectionPersonFullName, 
                                      dd.DirectionTemplateId, 
                                      dd.DirectionTypeId, 
                                      dd.DirectionControlStatus,  
                                      dbo.SYSDATETIME(), 
           dd.DirectionPlannedDay, 
                                      dd.DirectionExecutionStatusId, 
                                      dd.DirectionVizaId, 
                                      dd.DirectionConfirmed, 
                                      dd.DirectionSendStatus, 
                                      dd.DirectionCreatorWorkplaceId, 
                                      dbo.SYSDATETIME(), 
                                      dd.DirectionPersonId, 
                                      dd.DirectionUnixTime
                               FROM dbo.DOCS_DIRECTIONS dd
                               WHERE dd.DirectionId=(SELECT dt.DirectionId FROM @DirTable dt WHERE dt.Rownumber=@dirCount);


                        SET @newDirectionId = SCOPE_IDENTITY();


                        INSERT INTO dbo.DOCS_EXECUTOR
                        (
                        --ExecutorId - column value is auto-generated
                        ExecutorDirectionId, 
                        ExecutorDocId, 
                        ExecutorWorkplaceId, 
                        ExecutorFullName, 
                        ExecutorMain, 
                        DirectionTypeId, 
                        ExecutorOrganizationId, 
                        ExecutorTopDepartment, 
                        ExecutorDepartment, 
                        ExecutorSection, 
                        ExecutorSubsection, 
                        ExecutorStepId, 
                        ExecutionstatusId, 
                        ExecutorNote, 
                        ExecutorReadStatus, 
                        ExecutorResolutionNote, 
                        SendStatusId
                        )
                               SELECT @newDirectionId, 
                                      @newDocId, 
                                      de.ExecutorWorkplaceId, 
                                      de.ExecutorFullName, 
                                      de.ExecutorMain, 
                                      de.DirectionTypeId, 
                                      de.ExecutorOrganizationId, 
                                      de.ExecutorTopDepartment, 
                                      de.ExecutorDepartment, 
                                      de.ExecutorSection, 
                                      de.ExecutorSubsection, 
                                      de.ExecutorStepId, 
                                      de.ExecutionstatusId, 
                                      de.ExecutorNote, 
                                      de.ExecutorReadStatus, 
                                      de.ExecutorResolutionNote, 
                                      de.SendStatusId
                               FROM dbo.DOCS_EXECUTOR de
                               WHERE de.ExecutorId=(SELECT et.ExecutorId FROM @ExecTable et WHERE et.Rownumber=@dirCount);
                        SET @dirCount-=1;
        END;
                DECLARE @newFileId INT;
                INSERT INTO dbo.DOCS_FILE
                (
                --FileId - column value is auto-generated
                FileDocId, 
                FileInfoId, 
                FileName, 
                FileVisaStatus, 
                SignatureStatusId, 
                FileCurrentVisaGroup, 
                FileIsMain, 
                SignatureNote, 
                IsDeleted, 
                IsReject, 
                SignatureWorkplaceId, 
                SignatureDate
                )
                       SELECT @newDocId, 
                              df.FileInfoId, 
                              df.FileName, 
                              df.FileVisaStatus, 
                              df.SignatureStatusId, 
                              df.FileCurrentVisaGroup, 
                              df.FileIsMain, 
                              df.SignatureNote, 
                              df.IsDeleted, 
                              df.IsReject, 
                              df.SignatureWorkplaceId, 
                              df.SignatureDate
                       FROM dbo.DOCS_FILE df
                       WHERE df.FileDocId = @docId
        AND df.FileIsMain=1;

                SET @newFileId = SCOPE_IDENTITY();

                INSERT INTO dbo.DOCS_VIZA
                (
                --VizaId - column value is auto-generated
                VizaDocId, 
                VizaFileId, 
                VizaWorkPlaceId, 
                VizaReplyDate, 
                VizaNotes, 
                VizaOrderindex, 
                VizaSenderWorkPlaceId, 
                VizaSenddate, 
                VizaConfirmed, 
                IsDeleted, 
                VizaAgreementTypeId, 
                VizaFromWorkflow
                )
                       SELECT  
                              @newDocId, 
                              @newFileId, 
                              dv.VizaWorkPlaceId, 
                              dv.VizaReplyDate, 
                              dv.VizaNotes, 
                              dv.VizaOrderindex, 
                              dv.VizaSenderWorkPlaceId, 
                              dv.VizaSenddate, 
                              dv.VizaConfirmed, 
                              dv.IsDeleted, 
                              dv.VizaAgreementTypeId, 
                              dv.VizaFromWorkflow
                       FROM dbo.DOCS_VIZA dv
        WHERE dv.VizaDocId=@docId;




    INSERT dbo.DOCS_ADDRESSINFO
    (
        --AdrId - column value is auto-generated
        AdrDocId,
        AdrTypeId,
        AdrOrganizationId,
        AdrAuthorId,
        AdrAuthorDepartmentName,
        AdrPersonId,
        AdrPositionId,
        AdrUndercontrol,
        AdrUndercontrolDays,
        FullName,
        AdrSendStatusId
    )
    SELECT  
        @newDocId, 
        da.AdrTypeId, 
        da.AdrOrganizationId, 
        da.AdrAuthorId, 
        da.AdrAuthorDepartmentName, 
        da.AdrPersonId, 
        da.AdrPositionId, 
        da.AdrUndercontrol, 
        da.AdrUndercontrolDays, 
        da.FullName, 
        da.AdrSendStatusId
    FROM dbo.DOCS_ADDRESSINFO da
    WHERE da.AdrDocId=@docId;

    
    INSERT dbo.DOC_TASK
    (
        --TaskId - column value is auto-generated
        TaskDocNo,
        TaskDocId,
        TypeOfAssignmentId,
        TaskNo,
        TaskDecription,
        TaskCycleId,
        ExecutionPeriod,
        PeriodOfPerformance,
        OriginalExecutionDate,
        WhomAddressId,
        OrganizationId,
        TaskStatus,
        TaskCreateWorkPlaceId,
        TaskCreateDate
    )
    SELECT  
      dt.TaskDocNo,
        @newDocId, 
        dt.TypeOfAssignmentId, 
        dt.TaskNo, 
        dt.TaskDecription, 
        dt.TaskCycleId, 
        dt.ExecutionPeriod, 
        dt.PeriodOfPerformance, 
        dt.OriginalExecutionDate, 
        dt.WhomAddressId, 
        dt.OrganizationId, 
        dt.TaskStatus, 
        dt.TaskCreateWorkPlaceId, 
        dt.TaskCreateDate
    FROM dbo.DOC_TASK dt
    WHERE dt.TaskDocId=@docId;
        END;
    END;

