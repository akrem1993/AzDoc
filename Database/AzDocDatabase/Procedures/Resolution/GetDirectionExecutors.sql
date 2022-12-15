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
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [resolution].[GetDirectionExecutors]
@directionId int,
@directionWorkplaceId int
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;


select ExecutorDirectionId,ExecutorId,
ExecutorWorkplaceId,
ExecutorFullName,
ExecutorMain,
dp.PositionGroupId,
DepartmentPositionName,
ExecutorOrganizationId,
ExecutorTopDepartment,
ExecutorDepartment,
ExecutorSection,
ExecutorSubsection,
ExecutorReadStatus,
PositionGroupLevel,
de.SendStatusId,
SendStatusName,
ExecutorResolutionNote from DOCS_EXECUTOR de
left join  DC_WORKPLACE dw on dw.WorkplaceId=de.ExecutorWorkplaceId
left join DC_DEPARTMENT_POSITION dp on dp.DepartmentPositionId=dw.WorkplaceDepartmentPositionId
left join DC_POSITION_GROUP dg on dg.PositionGroupId=dp.PositionGroupId
left join DOC_SENDSTATUS ds on ds.SendStatusId=de.SendStatusId
where ExecutorDirectionId=@directionId and ExecutorWorkplaceId!=@directionWorkplaceId and de.SendStatusId!=5 AND ExecutionStatusId is null
END

