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
-- Author:  Musaeyev Nurlan,Rufin Əhmədov
-- Create date: 30.04.2019
-- Description: Sənədin imtina edilməsi
-- =============================================
CREATE PROCEDURE [outgoingdoc].[spCancelDocumentRequest]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null,
@result int output
AS
BEGIN
declare 
@vizaId int,
@vizaSenderWorkPlaceId int,
@docStatus int,
@newVizaId int,
@newDirectionId int,
@executorId int,
@docCreatorWorkPlaceId int,
@direcitonId int;


declare @Departament table 
(DepartmentOrganization int null,
DepartmentTopDepartmentId int null,
DepartmentId int,
DepartmentSectionId int null,
DepartmentSubSectionId int null);

--select @docStatus=d.DocDocumentstatusId from dbo.docs d where d.DocId=@docId;
select @docStatus=d.DocDocumentstatusId,@docCreatorWorkPlaceId=d.DocInsertedById from dbo.docs d where d.DocId=@docId;

SELECT 
 @executorId =de.ExecutorId,
 @direcitonId=de.ExecutorDirectionId
 FROM dbo.DOCS_EXECUTOR de 
 WHERE 
 de.ExecutorDocId=@docId
 and ExecutorWorkplaceId=@workPlaceId
 AND de.ExecutorReadStatus=0;

begin--Sektor ya shobe mudiri imtina edirse
 select 
 @vizaId= v.VizaId,
 @vizaSenderWorkPlaceId=v.VizaSenderWorkPlaceId 
 from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId 
 and v.VizaFromWorkflow=1 
 and v.VizaWorkPlaceId=@workPlaceId
 and v.IsDeleted=0;

if @vizaId is not null
begin

 update dbo.DOCS_VIZA--Vizadan imtina edilir
 set 
 VizaConfirmed=0,
 VizaNotes=@note,
 VizaReplyDate=null
 where 
 VizaId=@vizaId;

 update dbo.DocOperationsLog
 SET
     dbo.DocOperationsLog.OperationStatus = 4, -- int
     dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
     dbo.DocOperationsLog.OperationNote = @note -- nvarchar
  where 
  dbo.DocOperationsLog.DocId=@docId
  AND dbo.DocOperationsLog.ExecutorId=@executorId;

 update dbo.DOCS--senedin statusu qaralama olur
 set 
 DocDocumentOldStatusId=@docStatus,
 DocDocumentstatusId=31
 where 
 DocId=@docId;

 update dbo.DOCS_EXECUTOR --vizadan imtina eden shexsin senedi oxunmush statusunu alir
 set
 ExecutorReadStatus=1
 where 
 ExecutorId=@executorId;

 update dbo.DOCS_DIRECTIONS--imtina olunmush senedi istifadecinin gridinden itiririk
 set DirectionConfirmed=0
 where 
 dbo.DOCS_DIRECTIONS.DirectionId=@direcitonId;

 begin--senedi redakte ucun teyin edirik
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
          13,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @vizaId,
          0,
          1
         )
  set @newDirectionId=SCOPE_IDENTITY();
 end;

  begin--senedi redakte ucun kime(senedi gonderen shexs) gonderildiyini teyin edirik

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
              where w.WorkplaceId= @vizaSenderWorkPlaceId

  Insert into DOCS_EXECUTOR(DirectionTypeId,
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
           ExecutorReadStatus) 
     values 
           (13,
           @docId,
           0,
           @vizaSenderWorkPlaceId,
           dbo.fnGetPersonnelbyWorkPlaceId(@vizaSenderWorkPlaceId,106),

           (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

           15,
           @newDirectionId,
           0)
       set @executorId=SCOPE_IDENTITY();
       
      EXEC dbo.LogDocumentOperation
        @docId = @docId,
        @ExecutorId = @executorId,
        @SenderWorkPlaceId = @workPlaceId,
        @ReceiverWorkPlaceId = @vizaSenderWorkPlaceId,
        @DocTypeId = 12,
        @OperationTypeId = 15,
        @DirectionTypeId = 13,
        @OperationStatusId = null,
        @OperationStatusDate = null,
        @OperationNote = null;
  end;
return;
end
set @result=6;
end-------------------------------------------


begin--Viza qrupundan kimse imtina edirse
declare @vizaOrderIndex int;

select 
@vizaId= v.VizaId,
@vizaOrderIndex=v.VizaOrderindex,
@vizaSenderWorkPlaceId=v.VizaSenderWorkPlaceId 
from dbo.DOCS_VIZA v 
where 
v.VizaDocId=@docId 
and v.VizaFromWorkflow in(3,4)
and v.VizaWorkPlaceId=@workPlaceId
and v.IsDeleted=0;

if @vizaId is not null
begin
declare  @OrderIndexVizas table (VizaId int);
 
 --evvelki ve movcud qrupu geri qaytaririq---------------------
 Insert @OrderIndexVizas(VizaId)  
 select v.VizaId from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId and 
 v.VizaOrderindex<=@vizaOrderIndex and 
 v.VizaFromWorkflow in(3,4)
 and v.IsDeleted=0

 update dbo.DOCS_VIZA--Vizadan imtina edilir ve silinir statusu alir
 set 
 VizaConfirmed=0,
 VizaNotes=@note,
 VizaReplyDate=null
 where 
 VizaId=@vizaId;

 update dbo.DocOperationsLog
 SET
     dbo.DocOperationsLog.OperationStatus = 4, -- int
     dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
     dbo.DocOperationsLog.OperationNote = @note -- nvarchar
  where 
  dbo.DocOperationsLog.DocId=@docId
  AND dbo.DocOperationsLog.ExecutorId=@executorId;

 UPDATE dbo.DOCS_EXECUTOR
 SET
 dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1 -- bit
 where 
 dbo.DOCS_EXECUTOR.ExecutorId=@executorId
 AND dbo.DOCS_EXECUTOR.ExecutorDocId=@docId;

 update dbo.DOCS_VIZA
 set 
 dbo.DOCS_VIZA.VizaConfirmed=0,
 dbo.DOCS_VIZA.VizaNotes=null,
 dbo.DOCS_VIZA.VizaReplyDate=null,
 dbo.DOCS_VIZA.VizaSenddate=NULL
 where 
 VizaId in (select VizaId from @OrderIndexVizas WHERE [@OrderIndexVizas].VizaId<>@vizaId);

 update dbo.DOCS_DIRECTIONS
 set DirectionConfirmed=0
 where 
 DirectionDocId=@docId
 and DirectionVizaId in (select VizaId from @OrderIndexVizas);

 -----------------Imtina eden shexsin redakte ucun senedi yollanilmasi-----------------
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
          13,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @vizaId,
          0,
          1
         )
   set @newDirectionId=SCOPE_IDENTITY();
 -------------------------------------------------------------------------------------

 --------------senedi redakte ucun kime(senedi gonderen shexs) gonderildiyini teyin edirik

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
              where w.WorkplaceId= @vizaSenderWorkPlaceId

 Insert into DOCS_EXECUTOR(DirectionTypeId,
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
           ExecutorReadStatus) 
     values 
           (13,
           @docId,
           0,
           @vizaSenderWorkPlaceId,
           dbo.fnGetPersonnelbyWorkPlaceId(@vizaSenderWorkPlaceId,106),

           (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

           null,
           @newDirectionId,
           0) 
       SET @executorId=SCOPE_IDENTITY();

       EXEC dbo.LogDocumentOperation
        @docId = @docId,
        @ExecutorId = @executorId,
        @SenderWorkPlaceId = @workPlaceId,
        @ReceiverWorkPlaceId = @vizaSenderWorkPlaceId,
        @DocTypeId = 12,
        @OperationTypeId = 15,
        @DirectionTypeId = 13,
        @OperationStatusId = null,
        @OperationStatusDate = null,
        @OperationNote = NULL;

 update dbo.DOCS--sened yeniden qaralama statusu alir
 set 
 DocDocumentOldStatusId=@docStatus,
 DocDocumentstatusId=31
 where 
 DocId=@docId;

 set @result=6;
return;
end


end-------------------------------------------


begin--Imza eden shexs imtina edirse
declare @chiefWorkPlaceId int,@newFileId int,@chiefVizaId int,@directionworkPlaceId int;
declare  @OldViza table (VizaId int); 

SET @executorId=null;
SET @direcitonId=null;

select 
@executorId=ex.ExecutorId,
@direcitonId=ex.ExecutorDirectionId,
@directionworkPlaceId=dd.DirectionWorkplaceId
from
DOCS_EXECUTOR ex JOIN dbo.DOCS_DIRECTIONS dd ON ex.ExecutorDirectionId = dd.DirectionId
where
ex.ExecutorDocId=@docId
and ex.ExecutorWorkplaceId=@workPlaceId
and ex.ExecutorReadStatus=0
and ex.DirectionTypeId=8

if @executorId is not null
BEGIN

 update dbo.DOCS_EXECUTOR
 set ExecutorReadStatus=1
 where
 ExecutorId=@executorId; 

 UPDATE dbo.DOCS_DIRECTIONS
 SET
 DirectionConfirmed=0
 WHERE 
 DirectionId IN (SELECT 
     e.DirectionId
     from dbo.DOCS_DIRECTIONS e
     WHERE
     e.DirectionDocId=@docId
     and e.DirectionTypeId=8);

 update dbo.DocOperationsLog
 SET
     dbo.DocOperationsLog.OperationStatus = 4, -- int
     dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
     dbo.DocOperationsLog.OperationNote = @note -- nvarchar
  where 
  dbo.DocOperationsLog.DocId=@docId
  AND dbo.DocOperationsLog.ExecutorId=@executorId;

 update dbo.DOCS_FILE
 set 
 SignatureStatusId=3,
 SignatureDate=dbo.SYSDATETIME(),
 SignatureNote=@note,
 SignatureWorkplaceId=@workPlaceId
 where 
 FileDocId=@docId 
 and FileIsMain=1
 and IsDeleted=0
 AND dbo.DOCS_FILE.IsReject=0;
 --------------------------------------------------------------

 Insert into @OldViza(VizaId)
 select
 v.VizaId
 from
 dbo.DOCS_VIZA v
 where
 v.VizaDocId=@docId
 and v.VizaFromWorkflow in(3,4)
 and v.IsDeleted=0;

 update dbo.DOCS_VIZA
 set
 dbo.DOCS_VIZA.VizaConfirmed=0,
 dbo.DOCS_VIZA.VizaNotes=null,
 dbo.DOCS_VIZA.VizaReplyDate=null,
 dbo.DOCS_VIZA.VizaSenddate=NULL
 where
 VizaId in (select VizaId from @OldViza);

 update dbo.DOCS_DIRECTIONS
 set DirectionConfirmed=0
 where 
 DirectionDocId=@docId
 and DirectionVizaId in (select VizaId from @OldViza);
 -----------------------------------------------------------------

 --set @chiefWorkPlaceId=dbo.fnGetDepartmentChiefInViza(@docId);
 set @chiefWorkPlaceId=@directionworkPlaceId;--dbo.[fnGetDepartmentChief](@docCreatorWorkPlaceId);

 select 
 @chiefVizaId =v.VizaId
 from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId 
 and v.VizaWorkPlaceId=@chiefWorkPlaceId 
 and v.IsDeleted=0 
 and v.VizaFromWorkflow=1;

  --IF @chiefVizaId IS null 
     --THROW 56000,'Şöbə müdirinin vizası tapılmadı',1;

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
          13,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @chiefVizaId,
          0,
          1
         )
   set @newDirectionId=SCOPE_IDENTITY();
 -------------------------------------------------------------------------------------

 --------------senedi redakte ucun kime(senedi gonderen shexs,bu halda shobe muduru olmalidir) gonderildiyini teyin edirik


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
              where w.WorkplaceId= @chiefWorkPlaceId

 Insert into DOCS_EXECUTOR(DirectionTypeId,
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
           ExecutorReadStatus) 
     values 
           (13,
           @docId,
           0,
           @chiefWorkPlaceId,
           dbo.fnGetPersonnelbyWorkPlaceId(@chiefWorkPlaceId,106),

           (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

           null,
           @newDirectionId,
           0)
         SET @executorId=SCOPE_IDENTITY();
           
      EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @chiefWorkPlaceId,
          @DocTypeId = 12,
          @OperationTypeId = 15,
          @DirectionTypeId = 13,
          @OperationStatusId = null,
          @OperationStatusDate = null,
          @OperationNote = NULL;

 update dbo.DOCS--sened yeniden qaralama statusu alir
 set 
 DocDocumentOldStatusId=@docStatus,
 DocDocumentstatusId=31
 where 
 DocId=@docId
 AND dbo.DOCS.DocDeleted=0;

 set @result=6;
return;
end

set @result=6;
end-------------------------------------------


begin--Tesdiq eden shexs imtina edirse

SET @executorId=null;
SET @direcitonId=null;

select 
@executorId=ex.ExecutorId,
@direcitonId=ex.ExecutorDirectionId
from
DOCS_EXECUTOR ex JOIN dbo.DOCS_VIZA dv ON ex.ExecutorWorkplaceId=dv.VizaWorkPlaceId AND ex.ExecutorDocId=dv.VizaDocId
where
ex.ExecutorDocId=@docId
and ex.ExecutorWorkplaceId=@workPlaceId
and ex.ExecutorReadStatus=0
and ex.DirectionTypeId=15
AND DV.VizaFromWorkflow=2

if @executorId is not null
BEGIN

 Update dbo.DOCS_VIZA
 set 
 VizaConfirmed=0,
 VizaReplyDate=null,
 VizaSenddate=null,
 VizaNotes=@note
 where
 VizaDocId=@docId
 and VizaWorkPlaceId=@workPlaceId
 and IsDeleted=0
 and VizaFromWorkflow=2;
 
 update dbo.DOCS_DIRECTIONS
 set DirectionConfirmed=0
 where
 DirectionId IN (SELECT 
     e.DirectionId
     from dbo.DOCS_DIRECTIONS e
     WHERE
     e.DirectionDocId=@docId
     and e.DirectionTypeId=15); 

 update DOCS_EXECUTOR
 set ExecutorReadStatus=1
 where
 ExecutorId=@executorId; 

 update dbo.DocOperationsLog
 SET
     dbo.DocOperationsLog.OperationStatus = 4, -- int
     dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
     dbo.DocOperationsLog.OperationNote = @note -- nvarchar
 where 
 dbo.DocOperationsLog.DocId=@docId
 AND dbo.DocOperationsLog.ExecutorId=@executorId;

 ----------------------------------------------------------------------------------------

 Insert into @OldViza(VizaId)
 select
 v.VizaId
 from
 dbo.DOCS_VIZA v
 where
 v.VizaDocId=@docId
 and v.VizaFromWorkflow in(3,4)
 and v.IsDeleted=0;

 update dbo.DOCS_VIZA
 set 
 VizaConfirmed=0,
 VizaNotes=null,
 VizaReplyDate=null,
 VizaSenddate=NULL
 where
 VizaId in (select VizaId from @OldViza);

 update dbo.DOCS_DIRECTIONS
 set DirectionConfirmed=0
 where 
 DirectionDocId=@docId
 and DirectionVizaId in (select VizaId from @OldViza);


    --set @chiefWorkPlaceId=dbo.[fnGetDepartmentChief](@docCreatorWorkPlaceId);

	SELECT @chiefWorkPlaceId=dv.VizaWorkPlaceId
	FROM dbo.DOCS_VIZA dv 
	WHERE dv.VizaDocId=@docId 
			AND dv.VizaFromWorkflow=1 AND dv.IsDeleted=0 
			AND dv.VizaOrderindex=( SELECT max(dv.VizaOrderindex) 
									FROM dbo.DOCS_VIZA dv 
									WHERE dv.VizaDocId=@docId 
											AND dv.VizaFromWorkflow=1 
											AND dv.IsDeleted=0);

  select 
  @chiefVizaId =v.VizaId
  from dbo.DOCS_VIZA v 
  where 
  v.VizaDocId=@docId 
  and v.VizaWorkPlaceId=@chiefWorkPlaceId 
  and v.IsDeleted=0 
  and v.VizaFromWorkflow=1;

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
          13,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @chiefVizaId,
          0,
          1
         )
   set @newDirectionId=SCOPE_IDENTITY();

 --------------senedi redakte ucun kime(senedi gonderen shexs,bu halda shobe muduru olmalidir) gonderildiyini teyin edirik

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
              where w.WorkplaceId= @chiefWorkPlaceId

 Insert into DOCS_EXECUTOR(DirectionTypeId,
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
           ExecutorReadStatus) 
     values 
           (13,
           @docId,
           0,
           @chiefWorkPlaceId,
           dbo.fnGetPersonnelbyWorkPlaceId(@chiefWorkPlaceId,106),

      (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

           null,
           @newDirectionId,
           0) 
     SET @executorId=SCOPE_IDENTITY();

     EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @chiefWorkPlaceId,
          @DocTypeId = 12,
          @OperationTypeId = 15,
          @DirectionTypeId = 13,
          @OperationStatusId = null,
          @OperationStatusDate = null,
          @OperationNote = null;

 update dbo.DOCS--sened yeniden qaralama statusu alir
 set 
 DocDocumentOldStatusId=@docStatus,
 DocDocumentstatusId=31
 where 
 DocId=@docId;
 -----------------------------------------------------------------------------
return;
end

set @result=6;
end-------------------------------------------


set @result=6;
END

