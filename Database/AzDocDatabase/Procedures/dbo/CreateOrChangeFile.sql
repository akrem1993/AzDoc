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
-- Author:  Rufin Ahmadov
-- Create date: 12.06.2019
-- Description: ...
-- =============================================
CREATE PROCEDURE [dbo].[CreateOrChangeFile]
 @docId int OUT ,
 @workPlaceId int,
 @parentFileInfoId int,-- for file change 
 @docTypeId int,
 @fileInfoCapacity bigint,
 @fileInfoExtention varchar(5),
 @fileInfoPath nvarchar(200), 
 @fileInfoName nvarchar(300),
 @fileInfoGuId nvarchar(100),
 @result INT OUT
AS
BEGIN
 SET NOCOUNT ON;

 BEGIN TRY
  BEGIN TRANSACTION 
   
  DECLARE @newFileInfoId int,
    @fileIsMain bit=0;

   IF(@docId=-1) ---------------------------------------------------- create document----------------------------------------------
   BEGIN
    EXEC [dbo].[spCreateDocument]
       @docTypeId = @docTypeId,
       @docDeleted = 3,
       @workPlaceId = @workPlaceId,
       @docId = @docId OUTPUT,
       @result = @result OUTPUT

    IF(@result=0)
  ROLLBACK TRANSACTION;
   END;

   IF (@parentFileInfoId=-1) -- ADD FILE INFO
    BEGIN
     INSERT INTO dbo.DOCS_FILEINFO
     (
        FileInfoWorkplaceId, FileInfoParentId, 
        FileInfoVersion, FileInfoType, 
        FileInfoCapacity, FileInfoExtention, 
        FileInfoInsertdate, FileInfoPath, 
        FileInfoName, FileInfoGuId
  ) 
     VALUES 
  (
        @workPlaceId, NULL,
        1, NULL, 
        @fileInfoCapacity, @fileInfoExtention, 
        dbo.sysdatetime(), @fileInfoPath, 
        @fileInfoName, @fileInfoGuId
  )
     set @newFileInfoId = SCOPE_IDENTITY();
    END
   ELSE   --CHANGE FILE INFO
    BEGIN

     DECLARE	@oldFileId int, 
				@fileInfoVersion tinyint, 
				@fileInfoAttachmentCount int

     SELECT @oldFileId=df.FileId,
            @fileInfoVersion=d.FileInfoVersion,
            @fileInfoAttachmentCount=d.FileInfoAttachmentCount, 
            @fileIsMain=df.FileIsMain
     FROM dbo.DOCS_FILEINFO d
			INNER JOIN docs_file df on df.FileInfoId  = d.FileInfoId
     where d.FileInfoId = @parentFileInfoId;

     INSERT INTO dbo.DOCS_FILEINFO
     (
        FileInfoWorkplaceId, FileInfoParentId, 
        FileInfoVersion, FileInfoType, 
        FileInfoCapacity,FileInfoExtention, 
        FileInfoInsertdate,FileInfoPath, 
        FileInfoName, FileInfoGuId,  
        FileInfoContent,FileInfoAttachmentCount
  ) 
     VALUES 
     ( 
       @workPlaceId, @parentFileInfoId, 
       @fileInfoVersion, NULL, 
       @fileInfoCapacity, @fileInfoExtention, 
       dbo.sysdatetime(), @fileInfoPath, 
       @fileInfoName, @fileInfoGuId, 
       NULL, @fileInfoAttachmentCount
  )
    set @newFileInfoId = SCOPE_IDENTITY();
    
 UPDATE dbo.DOCS_FILE
 SET dbo.DOCS_FILE.IsDeleted = 1,
 dbo.DOCS_FILE.FileVisaStatus=0 --Shahriyar deyishdi
 WHERE dbo.DOCS_FILE.FileId = @oldFileId;
END; -- END ELSE

    INSERT INTO dbo.DOCS_FILE
    (
      FileDocId, FileInfoId, 
      [FileName], FileVisaStatus, 
      SignatureStatusId, FileCurrentVisaGroup, 
      FileIsMain,SignatureNote, 
      IsDeleted, IsReject, 
      SignatureWorkplaceId, SignatureDate) 
    VALUES 
      (@docId, @newFileInfoId, 
      @fileInfoName, 1/*NotViza*/,   --Shahriyar deyishdi..FileVisaStatus=1 eledim
      1 /*NotSigned*/, 1, 
      @fileIsMain, NULL, 
      0, 0, 
      NULL, NULL)

    DECLARE @newFileId int  = scope_identity();

    if(@parentFileInfoId<>-1)
    BEGIN
      exec dbo.spChangeOldViza
       @fileInfoId=@parentFileInfoId,
       @newFileId=@newFileId,
       @docId=@docId;

    DECLARE @docDocumentStatus int;
    SELECT @docDocumentStatus = d.DocDocumentstatusId 
    FROM dbo.DOCS d 
    WHERE d.DocId = @docId

    IF(@docDocumentStatus=30) -- eger senedin statusu imzadadirsa
    BEGIN
  DECLARE @executorId int,
    @directionId int;

  SELECT @executorId = de.ExecutorId,
      @directionId = de.ExecutorDirectionId
  FROM dbo.DOCS_EXECUTOR de 
  WHERE de.ExecutorDocId = @docId 
     AND de.ExecutorWorkplaceId = @workPlaceId 
     AND de.DirectionTypeId = 8
     AND de.ExecutorReadStatus = 0;

  IF (@executorId IS NOT NULL) --yarida qalib
  BEGIN
   DECLARE @OldVizas table(VizaId int);

   INSERT INTO @OldVizas
       SELECT dv.VizaId
       FROM dbo.DOCS_VIZA dv
       WHERE dv.VizaDocId = @docId
       AND dv.IsDeleted = 0;

   IF EXISTS(SELECT VizaId FROM @OldVizas)
   BEGIN
    UPDATE dbo.DOCS_EXECUTOR
      SET 
       ExecutorReadStatus = 1
    WHERE ExecutorId = @executorId;

    UPDATE dbo.DOCS_DIRECTIONS
      SET 
       DirectionConfirmed = 0
    WHERE DirectionId = @directionId;

    UPDATE dbo.DocOperationsLog
      SET 
       dbo.DocOperationsLog.OperationStatus = 11, -- int -- redakte edilib
       dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME() -- datetime
    WHERE dbo.DocOperationsLog.DocId = @docId
       AND dbo.DocOperationsLog.ExecutorId = @executorId;

    UPDATE dbo.DOCS_FILE 
      SET 
       SignatureStatusId = 3, 
       SignatureDate = dbo.SYSDATETIME(), 
       SignatureWorkplaceId = @workPlaceId
    WHERE FileDocId = @docId
       AND FileIsMain = 1
       AND IsDeleted = 0
       AND dbo.DOCS_FILE.IsReject = 0;

    DECLARE @firstVizaWorkplaceId INT, 
      @newDirectionId INT, 
      @firstVizaId INT, 
      @newExecutorId INT;

    UPDATE dbo.DOCS_VIZA -- kohne vizalari yeniden imza edenin adindan gedir sened
      SET 
       dbo.DOCS_VIZA.VizaConfirmed = 0, 
       --dbo.DOCS_VIZA.VizaSenderWorkPlaceId = @workPlaceId, 
       dbo.DOCS_VIZA.VizaNotes = NULL, 
       dbo.DOCS_VIZA.VizaReplyDate = NULL, 
       dbo.DOCS_VIZA.VizaSenddate = NULL
    WHERE VizaId IN
    (
     SELECT VizaId
     FROM @OldVizas
    );

    UPDATE dbo.DOCS_DIRECTIONS
      SET 
       DirectionConfirmed = 0
    WHERE DirectionDocId = @docId
       AND DirectionVizaId IN
    (
     SELECT VizaId
     FROM @OldVizas
    );

    SELECT @firstVizaWorkplaceId = dv.VizaWorkPlaceId, 
        @firstVizaId = dv.VizaId-- sened 1 index nomreli wexse yeniden gonderilir
    FROM dbo.DOCS_VIZA dv
    WHERE dv.VizaDocId = @docId 
       AND dv.VizaOrderindex = 1
       AND dv.VizaFromWorkflow = 1
       AND dv.IsDeleted = 0;

    INSERT INTO DOCS_DIRECTIONS
    (DirectionCreatorWorkplaceId, 
     DirectionDocId, 
     DirectionTypeId, 
     DirectionWorkplaceId, 
     DirectionInsertedDate, 
     DirectionDate, 
     DirectionVizaId, 
     DirectionConfirmed, 
     DirectionSendStatus
    )
    VALUES
    (@workPlaceId, 
     @docId, 
     3, 
     @workPlaceId, 
     dbo.SYSDATETIME(), 
    dbo.SYSDATETIME(), 
     @firstVizaId, 
     1, 
     1
    );
    SET @newDirectionId = SCOPE_IDENTITY();

declare @Departament table 
(DepartmentOrganization int null,
DepartmentTopDepartmentId int null,
DepartmentId int,
DepartmentSectionId int null,
DepartmentSubSectionId int null)

Insert into @Departament(DepartmentOrganization,
          DepartmentTopDepartmentId,
          DepartmentId,
          DepartmentSectionId,
          DepartmentSubSectionId) 
select d.DepartmentOrganization,
          d.DepartmentTopDepartmentId,
          d.DepartmentId,
          d.DepartmentSectionId,
          d.DepartmentSubSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @firstVizaWorkplaceId

    INSERT INTO DOCS_EXECUTOR
    (DirectionTypeId, 
     ExecutorDocId, 
     ExecutorMain, 
     ExecutorWorkplaceId, 
     ExecutorFullName, 

     ExecutorOrganizationId, 
     ExecutorTopDepartment, 
     ExecutorDepartment, 
     ExecutorSection, 
     ExecutorSubsection, 

     SendStatusId, 
     ExecutorDirectionId, 
     ExecutorReadStatus
	 
	 
    )
    VALUES
    (3, 
     @docId, 
     0, 
     @firstVizaWorkplaceId, 
     dbo.fnGetPersonnelbyWorkPlaceId(@firstVizaWorkplaceId, 106), 
     (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

     NULL, 
     @newDirectionId, 
     0
	 
    );
    SET @newExecutorId = SCOPE_IDENTITY();

    EXEC dbo.LogDocumentOperation 
      @docId = @docId, 
      @ExecutorId = @newExecutorId, 
      @SenderWorkPlaceId = @workPlaceId, 
      @ReceiverWorkPlaceId = @firstVizaWorkplaceId, 
      @DocTypeId = @docTypeId, 
      @OperationTypeId = 7, 
      @DirectionTypeId = 13, 
      @OperationStatusId = NULL, 
      @OperationStatusDate = NULL, 
      @OperationNote = NULL;

    UPDATE dbo.DOCS--sened yeniden vizadadir statusu alir
      SET 
       DocDocumentOldStatusId = 30, 
       DocDocumentstatusId = 28
    WHERE DocId = @docId
       AND dbo.DOCS.DocDeleted = 0;

   END;
  END
    END
 END
    else
    begin  

      declare @Viza table(VizaId int  null);

    insert into @Viza
     select top(1) v.VizaId
     from DOCS_VIZA v 
     where v.VizaDocId = @docId 
      and v.VizaAgreementTypeId=2
     order by v.VizaId;
  
      if exists(select * from @Viza)
      begin
  update docs_viza 
  SET  VizaFileId = @newFileId -- int
  WHERE VizaId = (select VizaId from @Viza) -- int
      end;
    end;

    SET @result = 1;
  COMMIT TRANSACTION;
 END TRY
 BEGIN CATCH 
  ROLLBACK TRANSACTION;

  INSERT INTO dbo.debugTable
  VALUES(ERROR_MESSAGE(), dbo.sysdatetime());

 END CATCH

END

