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
CREATE PROCEDURE [resolution].[spSetPersonWorkplace]
 
 @workPlaceId int

AS
BEGIN -- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET 
  NOCOUNT ON;
SELECT 
  WorkplaceDepartmentPositionId, 
  dp.DepartmentId, 
  dp.PositionGroupId, 
  WorkplaceOrganizationId, 
  DepartmentTopDepartmentId, 
  DepartmentDepartmentId, 
  DepartmentSectionId, 
  DepartmentSubSectionId, 
  PositionGroupLevel, 
  WorkplaceDepartmentId, 
  (
    SELECT 
      top 1 dw.WorkplaceId 
    FROM 
      [dbo].[DC_DEPARTMENT] AS d 
      left join [DC_DEPARTMENT_POSITION] dp on dp.DepartmentId = d.DepartmentId 
      inner join [dbo].[DC_WORKPLACE] dw on dw.WorkplaceDepartmentPositionId = dp.DepartmentPositionId 
    WHERE 
      d.[DepartmentId] = case when DepartmentTypeId = 6 
      /*)DepartmentType.Sector*/
      and DepartmentTopId is not null then DepartmentTopId else WorkplaceDepartmentId end 
      and PositionGroupId in (
        17 
        /*PositionGroup.SectionChief*/
        , 
        18 
        /*)PositionGroup.SectionChiefDeputy*/
        ) 
    order by 
      PositionGroupId
  ) ChiefWorkplaceId 
FROM 
  [dbo].[DC_WORKPLACE] AS dw 
  left join [DC_DEPARTMENT_POSITION] dp on dp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId 
  left join DC_DEPARTMENT dd on dp.DepartmentId = dd.DepartmentId 
  left join DC_POSITION_GROUP dg on dg.PositionGroupId = dp.PositionGroupId 
WHERE 
  dw.[WorkplaceId] = @workPlaceId END

