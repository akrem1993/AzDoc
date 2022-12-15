/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddNewVizaExecutors]
@fileInfoId int,
@vizaDocId int,
@orderIndex int,
@workPlaceId int,
@vizaWorkPlaceId int,
@result int output
WITH EXEC AS CALLER
AS
declare @fileId int;
select @fileId=f.FileId from docs_file f where f.FileInfoId = @fileInfoId AND f.IsDeleted=0;

declare @chiefWorkPlaceId int, --senedi yaradannin sektor ve ya sobe mudirini saxlayir
		@positionGroupId int;
--set @chiefWorkPlaceId=dbo.fnGetDepartmentChief(@workPlaceId);

SELECT @positionGroupId=ddp.PositionGroupId 
FROM dbo.DC_WORKPLACE dw 
INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
WHERE dw.WorkplaceId=@workPlaceId

declare @vizaFromWorkflowOrderIndex int;

SELECT @chiefWorkPlaceId= CASE WHEN @positionGroupId NOT IN (32) then dv.VizaWorkPlaceId ELSE dv.VizaSenderWorkPlaceId end,
	   @vizaFromWorkflowOrderIndex=dv.VizaOrderindex
FROM dbo.DOCS_VIZA dv 
WHERE dv.VizaDocId=@vizaDocId 
		AND dv.VizaFromWorkflow=1 AND dv.IsDeleted=0 
		AND dv.VizaOrderindex=( SELECT max(dv.VizaOrderindex) 
								FROM dbo.DOCS_VIZA dv 
								WHERE dv.VizaDocId=@vizaDocId 
										AND dv.VizaFromWorkflow=1 
										AND dv.IsDeleted=0);

SET @chiefWorkPlaceId=ISNULL(@chiefWorkPlaceId,@workPlaceId);

if(@vizaFromWorkflowOrderIndex is not null and @vizaFromWorkflowOrderIndex >= @orderIndex)
begin
    set @result = 0; -- Qrup nömrəsini düzgün daxil edin
end
else
begin 
    exec dbo.spVizaAdd
    @isDeleted=0,
    @vizaDocId=@vizaDocId, 
    @vizaFileId=@fileId, 
    @vizaConfirmed=0, 
    @vizaOrderIndex=@orderIndex, 
    @vizaSendDate=null, 
    @vizaWorkPlaceId=@vizaWorkPlaceId, 
    @vizaAgreementTypeId=1,
    @vizaSenderWorkPlaceId=@chiefWorkPlaceId, 
    @vizaFromWorkFlow=3,
    @result = @result out
end;

