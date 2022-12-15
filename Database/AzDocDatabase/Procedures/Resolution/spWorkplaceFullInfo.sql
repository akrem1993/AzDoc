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
CREATE PROCEDURE [resolution].[spWorkplaceFullInfo]
 
 @workPlaceId int

AS
BEGIN 
    SET concat_null_yields_null OFF; 
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET nocount ON; 

    SELECT workplaceid, 
           personnelname, 
           personnellastname, 
           personnelsurname, 
           personnelname + ' ' + personnelsurname AS PersonnelFullname, 
           workplaceorganizationid, 
           departmenttopdepartmentid, 
           workplacedepartmentid, 
           departmentsectionid, 
           departmentsubsectionid, 
           departmentpositionname, 
           positiongrouplevel 
    FROM   dbo.dc_workplace dw 
           LEFT JOIN dbo.dc_user du 
                  ON du.userid = dw.workplaceuserid 
           LEFT JOIN dbo.dc_personnel dp 
                  ON dp.personnelid = du.userpersonnelid 
           LEFT JOIN dbo.dc_department dd 
                  ON dd.departmentid = dw.workplacedepartmentid 
           LEFT JOIN dbo.dc_department_position ddp 
                  ON ddp.departmentpositionid = dw.workplacedepartmentpositionid 
           LEFT JOIN dbo.dc_position_group dg 
                  ON dg.positiongroupid = ddp.positiongroupid 
    WHERE  dw.workplaceid = @workPlaceId 
END 

