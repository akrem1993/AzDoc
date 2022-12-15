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
-- Author:  Musayev Nurlan
-- Create date: 20.05.2019
-- Description: Vizani shobe ya sektor mudirine teyin edilmesi
-- =============================================
CREATE PROCEDURE [serviceletters].[SendVizaToChief]
@docId int,
@workPlaceId int
AS
DECLARE
    @receiverWorkPlaceId int,
    @chiefVizaId int,
    @directionId int,
    @executorId int;
BEGIN
SET NOCOUNT ON;

SELECT 
@chiefVizaId=dv.VizaId,
@receiverWorkPlaceId=dv.VizaWorkPlaceId 
FROM dbo.DOCS_VIZA dv
WHERE
dv.VizaDocId=@docId
and dv.VizaSenderWorkPlaceId=@workPlaceId
and (VizaFromWorkflow IN (1,3)) 
and IsDeleted=0;

IF @chiefVizaId IS NULL 
 THROW 51000, 'Şöbə və ya sektor müdirinin vizası tapılmadı', 1;

update dbo.DOCS_VIZA
set 
VizaSenddate=dbo.SYSDATETIME()
where 
VizaId=@chiefVizaId;

Insert into DOCS_DIRECTIONS(
              DirectionCreatorWorkplaceId,
              DirectionDocId,
              DirectionTypeId,
              DirectionWorkplaceId,
              DirectionInsertedDate,
              DirectionDate,
              DirectionVizaId,
              DirectionConfirmed,
              DirectionSendStatus
              ) 
         values
             (
              @workPlaceId,
              @docId,
              3,
              @receiverWorkPlaceId,
              dbo.SYSDATETIME(),
              dbo.SYSDATETIME(),
              @chiefVizaId,
              1,
              1
             )
       set @directionId=SCOPE_IDENTITY();

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
              where w.WorkplaceId= @receiverWorkPlaceId

        Insert into DOCS_EXECUTOR(DirectionTypeId,
               ExecutorDocId,
               ExecutorMain,
               ExecutorWorkplaceId,
               ExecutorFullName,
               SendStatusId,

               ExecutorOrganizationId,
               ExecutorTopDepartment,
               ExecutorDepartment,
               ExecutorSection,
               ExecutorSubsection,

               ExecutorDirectionId) 
         values 
               (3,
               @docId,
               0,
               @receiverWorkPlaceId,
               dbo.fnGetPersonnelbyWorkPlaceId(@receiverWorkPlaceId,106),
               7,

               (select DepartmentOrganization from @Departament),
          (select DepartmentTopDepartmentId from @Departament),
          (select DepartmentId from @Departament),
          (select DepartmentSectionId from @Departament),
          (select DepartmentSubSectionId from @Departament),

               @directionId) 
         SET @executorId=SCOPE_IDENTITY();


        EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @receiverWorkPlaceId,
          @DocTypeId = 3,
          @OperationTypeId = 7,
          @DirectionTypeId = 3,
          @OperationStatusId = 2,
          @OperationStatusDate = null,
          @OperationNote = null
END

