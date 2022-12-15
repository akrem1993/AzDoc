/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/


CREATE PROCEDURE [outgoingdoc].[spSendVizaToNextGroup]
@workPlaceId int,
@docId int,
@result int=null output
AS
DECLARE
    @vizaCount int=0,
    @vizaConfirmedCount int=0,
    @vizaOrderIndex int=0,
    @currentDirectionId int,
    @executorFullName nvarchar(max),
    @executorOrganizationId int,
    @executorDepartmentId int,
    @documentStatusId int;
BEGIN

select @documentStatusId=d.DocDocumentstatusId from dbo.DOCS d where d.DocId=@docId; 

 select 
 @vizaOrderIndex=v.VizaOrderindex 
 from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId 
 and v.VizaWorkPlaceId=@workPlaceId 
 AND v.IsDeleted=0;

 select 
 @vizaConfirmedCount=COUNT(0) 
 from dbo.DOCS_VIZA v
 where 
 v.VizaDocId=@docId
 and v.VizaOrderindex=@vizaOrderIndex
 and v.VizaConfirmed=0 
 and v.IsDeleted=0;
 
  IF(@vizaConfirmedCount=0)--movcud qrupda vizani testiqlenmeyen qalmayibsa novbeti qrupa baxilir
  BEGIN
     IF EXISTS(select v.VizaId from --novbeti qrupda vizalarin olmasi yoxlanilir
                                    dbo.DOCS_VIZA v 
                                    where 
                                    v.VizaDocId=@docId 
                                    --and v.VizaWorkPlaceId<>@workPlaceId 
                                    and v.VizaOrderindex>@vizaOrderIndex 
                                    AND v.VizaConfirmed=0
                                    and v.IsDeleted=0)
     BEGIN
      DECLARE @nextViza table(VizaId int,VizaWorkPlaceId int,VizaSenderWorkPlaceId int,RowNumber int);

      INSERT into @nextViza(
                         VizaId,
                         VizaWorkPlaceId,
                         VizaSenderWorkPlaceId,
                         RowNumber)
                         select 
                         v.VizaId,
                         v.VizaWorkPlaceId,
                         v.VizaSenderWorkPlaceId,
                         ROW_NUMBER() over (order by v.VizaId) 
                         from DOCS_VIZA v 
                         where  
                         v.VizaId in (
                                     select 
                                     dv.VizaId 
                                     from DOCS_VIZA dv 
                                     where 
                                     dv.VizaDocId=@docId
                                                  AND dv.VizaConfirmed=0
                                                  and v.IsDeleted=0
                                     and dv.VizaOrderindex=(
                                                       select 
                                                       s.VizaOrderindex 
                                                       from 
                                                       (select top 1 f.VizaOrderindex,
                                                       COUNT(f.VizaId) as CountVizaId
                                                       from dbo.DOCS_VIZA f 
                                                       where f.VizaDocId=@docId
                                                       and f.VizaConfirmed=0
                                                       and f.VizaOrderindex>@vizaOrderIndex
                                                       and f.IsDeleted=0
                                                       group by f.VizaOrderindex ) s)
                     
                            );

      Declare 
      @countNextViza int=0,
      @currentWorkPlaceId int,
      @currentVizaId int,
      @currentVizaSenderWorkPLaceId int,
      @currentExecutorId int;

      select @countNextViza=COUNT(0) from @nextViza;

       WHILE(@countNextViza>0)--sened gedir novbeti qrupdaki shexslere,vizanin testiqi ucun
       BEGIN
          select 
          @currentWorkPlaceId=nv.VizaWorkPlaceId,
          @currentVizaId=nv.VizaId,
          @currentVizaSenderWorkPLaceId=nv.VizaSenderWorkPlaceId
          from @nextViza nv 
          where 
          nv.RowNumber=@countNextViza;
          
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
          @workPlaceId,
          @docId,
          3,
          @currentVizaSenderWorkPLaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @currentVizaId,
          1,
          1)

        set @currentDirectionId=SCOPE_IDENTITY(); 

        update dbo.DOCS_VIZA
        set VizaSenddate=dbo.SYSDATETIME()
        where VizaId=@currentVizaId;

        select @executorFullName=(select CONVERT(nvarchar(max),(select [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@currentWorkPlaceId,1))));       

        SELECT 
                @executorOrganizationId=wp.WorkplaceOrganizationId,
                @executorDepartmentId=wp.WorkplaceDepartmentId 
                from dbo.DC_WORKPLACE wp 
                where wp.WorkplaceId=@currentWorkPlaceId

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
              where w.WorkplaceId= @currentWorkPlaceId

     
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
          @currentDirectionId, 
          @docId, 
          @currentWorkPlaceId,
          @executorFullName, 
          0, 
          3,
 
          (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),
      
          0,
7
          );
         SET @currentExecutorId=SCOPE_IDENTITY();
        
        delete from @Departament;
        
        EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @currentExecutorId,
          @SenderWorkPlaceId = @currentVizaSenderWorkPLaceId,
          @ReceiverWorkPlaceId = @currentWorkPlaceId,
          @DocTypeId = 12,
          @OperationTypeId = 7,
          @DirectionTypeId = 3,
          @OperationStatusId = 2,
          @OperationStatusDate = null,
          @OperationNote = null;
         
        set @countNextViza-=1
         END
     END
     ELSE
     BEGIN--===Novbeti qrup olmadiqda(butun vizalar testiqlenib)================================================>
         --if(@documentStatusId=28) --Əgər senedin statusu vizadadirsa,sened gedir imza eden shexse
         --BEGIN
                EXEC outgoingdoc.spOperationSigner
                            @docId = @docId,
                            @docTypeId = 3;
         --end 
     END--=========================================================================================
  END 
 SET  @result=1; 
END

