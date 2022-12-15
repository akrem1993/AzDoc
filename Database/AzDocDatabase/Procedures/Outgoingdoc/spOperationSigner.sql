/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationSigner]
@docId int,
@docTypeId int

as
 declare 
 @signatoryWorplaceId int,
 @vizaId int,
 @directionId int,
 @executorFullName nvarchar(max),
 @executorOrganizationId int,
 @executorDepartmentId int,
 @chiefWorkPlaceId int,
 @executorId int,
  @docCreatorWorkplaceId int,
   @answerDocId int,
  @documentStatusId int;
 BEGIN
        SELECT @documentStatusId=d.DocDocumentstatusId FROM dbo.DOCS d WHERE d.DocId=@docId;

        IF @documentStatusId<>28
            THROW 56000,N'Sənədin statusu vizada olmalıdır',1;


        select 
        @signatoryWorplaceId=a.AdrPersonId 
        from DOCS_ADDRESSINFO a 
        where 
        a.AdrDocId=@docId 
        and a.AdrTypeId=1
        
       if @signatoryWorplaceId IS null
              THROW 56000,N'İmza edən şəxs tapılmadı',1;
 SELECT @docCreatorWorkplaceId = d.DocInsertedById 
  FROM docs d 
  WHERE d.DocId=@docId; 
   
  --SELECT @chiefWorkPlaceId=dbo.fnGetDepartmentChief(@docCreatorWorkplaceId);
  SELECT @chiefWorkPlaceId=dv.VizaWorkPlaceId 
  FROM dbo.DOCS_VIZA dv 
  WHERE dv.IsDeleted=0 
		AND dv.VizaFromWorkflow=1  
		AND dv.VizaDocId=@docId
		AND dv.VizaOrderindex = (SELECT max(dv2.VizaOrderindex) 
								 FROM dbo.DOCS_VIZA dv2  
								 WHERE dv2.VizaDocId=@docId 
										AND dv2.IsDeleted=0 
										AND dv2.VizaFromWorkflow=1)

  --SELECT @answerDocId=dr.RelatedDocumentId FROM dbo.DOCS_RELATED dr WHERE dr.RelatedDocId = @docId AND dr.RelatedTypeId=2

  --IF @answerDocId IS NOT null-- eger sened cavab senedirdirse
  --BEGIN
  -- IF (@docCreatorWorkplaceId != @signatoryWorplaceId)
  -- BEGIN
  --  SELECT TOP 1 @chiefWorkPlaceId=dv.VizaSenderWorkPlaceId -- imzalayan wexse qurum rehberinin adindan gedir
  --  FROM 
  --    dbo.DOCS_VIZA dv 
  --  WHERE 
  --   dv.VizaDocId=@docId 
  --   AND dv.VizaFromWorkflow=1
  --   AND dv.VizaOrderindex=(SELECT max(dbo.docs_viza.VizaOrderindex) 
  --             FROM docs_viza 
  --             WHERE dbo.docs_viza.VizaDocId=@docId)

  --  SELECT @chiefWorkPlaceId = de2.ExecutorWorkplaceId 
  --  FROM dbo.DOCS_EXECUTOR de
  --   INNER JOIN dbo.DOCS_EXECUTOR de2 ON de.ExecutorTopId = de2.ExecutorId
  --  WHERE de.ExecutorDocId=@answerDocId 
  --     AND de.SendStatusId=1 
  --     AND de.ExecutorWorkplaceId = @chiefWorkPlaceId 
  --     AND de.ExecutorTopId IS NOT NULL 

  -- END;
  --END;

         UPDATE dbo.DOCS 
        set 
          DocDocumentstatusId=30, --İmzadadır
        DocDocumentOldStatusId=28   
        where DocId=@docId;

          select 
            @vizaId=v.VizaId 
            from dbo.DOCS_VIZA v 
            where  
            v.VizaDocId=@docId 
            and v.VizaWorkPlaceId=@chiefWorkPlaceId 
            and v.IsDeleted=0;

        Insert into DOCS_DIRECTIONS(
                DirectionCreatorWorkplaceId,
                DirectionDocId,
                DirectionTypeId,
                DirectionWorkplaceId,
                DirectionInsertedDate,
                DirectionDate,
                DirectionVizaId,
                DirectionConfirmed,
               DirectionSendStatus) 
           values
               (
                @chiefWorkPlaceId,
                @docId,
                8,
                @chiefWorkPlaceId,
                dbo.SYSDATETIME(),
                dbo.SYSDATETIME(),
                @vizaId,
                1,
               1
               )
            set @directionId=SCOPE_IDENTITY();

        set @executorFullName=cast([dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryWorplaceId,1) AS nvarchar(max));       

          select 
            @executorOrganizationId=wp.WorkplaceOrganizationId,
            @executorDepartmentId=wp.WorkplaceDepartmentId FROM
            dbo.DC_WORKPLACE wp 
            where 
            wp.WorkplaceId=@signatoryWorplaceId

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
              where w.WorkplaceId= @signatoryWorplaceId
           
        INSERT INTO dbo.DOCS_EXECUTOR
           (
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
            ExecutorReadStatus,
            SendStatusId) 
           VALUES (
            @directionId, 
            @docId, 
            @signatoryWorplaceId,
            @executorFullName, 
            0, 
            8,
            (select DepartmentOrganization from @Departament),
            (select DepartmentTopDepartmentId from @Departament),
            (select DepartmentId from @Departament),
            (select DepartmentSectionId from @Departament),
            (select DepartmentSubSectionId from @Departament),    
            0,
            8
            );

     SET @executorId=SCOPE_IDENTITY();

     EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @chiefWorkPlaceId,
          @ReceiverWorkPlaceId = @signatoryWorplaceId,
          @DocTypeId = 12,
          @OperationTypeId = 8,
          @DirectionTypeId = 8,
          @OperationStatusId = 7,
          @OperationStatusDate = null,
          @OperationNote = null

end

