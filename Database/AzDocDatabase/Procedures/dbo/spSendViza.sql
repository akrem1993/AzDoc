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
-- Create date: 18.03.2019
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSendViza]
  @fileId int, 
  @vizaId int, 
  @workPlaceId int, 
  @result int OUTPUT
WITH EXEC AS CALLER
AS
declare @FileCurrentVisaGroup tinyint;
declare @ChiefWorkPlaceId int;--senedin yaradanin shobe mudirinin workplacesi
declare @DocsViza table(VizaDocId int,VizaOrderIndex int null,VizaWorkPlaceId int,VizaFromWorkflow int null,VizaAgreementTypeId int null);
BEGIN
  select @FileCurrentVisaGroup=f.FileCurrentVisaGroup from DOCS_FILE f where f.FileId=@fileId;
  insert into @DocsViza (VizaDocId,
        VizaOrderindex,
        VizaWorkPlaceId,
        VizaFromWorkflow,
        VizaAgreementTypeId)
       select v.VizaDocId,
         v.VizaOrderindex,
         v.VizaWorkPlaceId,
         v.VizaFromWorkflow,
         v.VizaAgreementTypeId from DOCS_VIZA v where v.VizaId=@vizaId;
    declare @docDeleted tinyint;
 select @docDeleted=DocDeleted from DOCS where DocId=(select VizaDocId from @DocsViza);

 if exists(select * from @DocsViza)
 begin
  
  
  declare @VizaOrderIndex int ,@vizaWorkPlaceId int ;
  select @VizaOrderIndex=VizaOrderIndex,@vizaWorkPlaceId=VizaWorkPlaceId from @DocsViza;

  if @FileCurrentVisaGroup=@VizaOrderIndex or @VizaOrderIndex is null
  begin 
  
   declare @dcWorkPlaceDepartmentId int;
   select @dcWorkPlaceDepartmentId=w.WorkplaceDepartmentId from DOCS_FILE f 
                join DOCS_FILEINFO fi on f.FileInfoId=fi.FileInfoId 
                join DC_WORKPLACE w on fi.FileInfoWorkplaceId=w.WorkplaceId
                where f.FileId=@fileId;  

   declare @vizaFullName nvarchar(max),@vizaDepartmentName nvarchar(max),@vizaFromWorkflow int ;
   set @ChiefWorkPlaceId=[dbo].[fnGetChiefByDepartmentID](@dcWorkPlaceDepartmentId,@workPlaceId);
   set @vizaFullName=cast([dbo].fnGetPersonnelDetailsbyWorkPlaceId(@vizaWorkPlaceId,1) as nvarchar(max));
   set @vizaDepartmentName=cast([dbo].fnGetPersonnelDetailsbyWorkPlaceId(@vizaWorkPlaceId,2) as nvarchar(max));
   
   begin--Əgər şəxs şöbə müdirinə sənədi göndərərsə öz adından göndərilir.
    if @ChiefWorkPlaceId=@vizaWorkPlaceId or @vizaFromWorkflow=1 --(Chief=1)
    begin
     select @ChiefWorkPlaceId=FileInfoWorkplaceId from DOCS_FILEINFO where FileInfoId=(select f.FileInfoId 
                          from DOCS_FILE f where FileId= @fileId)
                      
    end;
    
    declare @directionType int,@sendStatus int;
    select @directionType=case when v.VizaAgreementTypeId=1 then 3 
           else 15 end 
           from @DocsViza v;
    select @sendStatus=case when v.VizaAgreementTypeId=1 then 7 
          else 12 end 
          from @DocsViza v;

                declare @Departament table (DepartmentOrganization int null,DepartmentTopDepartmentId int null,DepartmentId int,DepartmentSectionId int null,DepartmentSubSectionId int null)

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
              where w.WorkplaceId=@ChiefWorkPlaceId
    
    declare @directionId int;
        select @directionId=DirectionId from DOCS_DIRECTIONS where DirectionDocId=(select FileDocId from
                  DOCS_FILE where FileId=@fileId)
    
    --if (@directionId is not null)
    --begin
      -- Update DOCS_DIRECTIONS set DirectionCreatorWorkplaceId=@ChiefWorkPlaceId,
      --  --DirectionTypeId=@directionType,
      --  DirectionWorkplaceId=@ChiefWorkPlaceId,
      --  DirectionInsertedDate=SYSDATETIME(),
      --  DirectionDate=SYSDATETIME(),
      --  DirectionVizaId=@vizaId,
      --  DirectionConfirmed=case @docDeleted when 2 then 0 else 1 end
      --where DirectionId=@directionId;
    --end
    --else
    --begin 
     -- Insert into DOCS_DIRECTIONS(
     --     DirectionCreatorWorkplaceId,
     --     DirectionDocId,
     --     DirectionTypeId,
     --     DirectionWorkplaceId,
     --     DirectionInsertedDate,
     --     DirectionDate,
     --     DirectionVizaId,
     --     DirectionConfirmed) 
     --values
     --    (
     --     @ChiefWorkPlaceId,
     --     (select VizaDocId from @DocsViza),
     --     @directionType,
     --     @ChiefWorkPlaceId,
     --     SYSDATETIME(),
     --     SYSDATETIME(),
     --     @vizaId,
     --     0--case @docDeleted when 2 then 0 else 1 end
     --    )
     -- set @directionId=SCOPE_IDENTITY();
    --end;

    --if not exists(select VizaId from DOCS_VIZA v where v.VizaDocId=(select FileDocId from DOCS_FILE f where f.FileId=@fileId))
    --begin 
      
    --end;
    --Insert into DOCS_EXECUTOR(DirectionTypeId,
    --       ExecutorDocId,
    --       ExecutorMain,
    --       ExecutorWorkplaceId,
    --       ExecutorFullName,
    --       ExecutorOrganizationId,
    --       ExecutorTopDepartment,
    --       ExecutorDepartment,
    --       ExecutorSection,
    --       ExecutorSubsection,
    --       SendStatusId,
    --       ExecutorDirectionId) 
    -- values 
    --       (@directionType,
    --       (select VizaDocId from @DocsViza),
    --       0,
    --       @vizaWorkPlaceId,
    --       @vizaFullName,
    --       (select DepartmentOrganization from @Departament),
    --       (select DepartmentTopDepartmentId from @Departament),
    --       (select DepartmentId from @Departament),
    --       (select DepartmentSectionId from @Departament),
    --       (select DepartmentSubSectionId from @Departament),
    --       @sendStatus,
    --       @directionId)  

   end;

  end;
    
    
 end;
END

