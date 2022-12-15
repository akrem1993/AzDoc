/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/



CREATE PROCEDURE [outgoingdoc].[AddDocumentReserve] @docType     INT = NULL, 
                                                     @workPlaceId INT = 0, 
                                                     @formTypeId  INT = 0, 
                                                     @docId       INT = NULL
AS
BEGIN 
    SET nocount ON; 

    DECLARE @orgId INT; 

    SELECT @orgId = (SELECT [dbo].[Fnpropertybyworkplaceid](@workPlaceId, 12)); 

    SELECT s.formtypeid, 
           s.id, 
           s.NAME 
    FROM   ( 
           --TypeOfDocument 
           SELECT 2                                              FormTypeId, 
                  dw.workplaceid                                 AS Id, 
                  Isnull(' ' + dp.personnelname, '') 
                  + Isnull(' ' + dp.personnelsurname, '') 
                  + Isnull(' ' + dp.personnellastname, '') 
                  + Isnull(' ' + ddp.departmentpositionname, '') AS NAME, 
                  dpg.positiongrouplevel 
           FROM   dbo.dc_workplace dw 
                  JOIN dbo.dc_user du 
                    ON dw.workplaceuserid = du.userid 
                  JOIN dbo.dc_personnel dp 
                    ON du.userpersonnelid = dp.personnelid 
                  JOIN dbo.dc_department_position ddp 
                    ON dw.workplacedepartmentpositionid = 
                       ddp.departmentpositionid 
                  JOIN dbo.dc_position_group dpg 
                    ON ddp.positiongroupid = dpg.positiongroupid 
                  JOIN dbo.dc_workplace_role dwr 
                    ON dw.workplaceid = dwr.workplaceid 
           WHERE  dp.personnelstatus = 1 
                  AND dwr.roleid = 240 
                  AND dw.workplaceid IN (SELECT dw.workplaceid 
                                         FROM   dbo.dc_workplace dw 
                                         WHERE  dw.workplacedepartmentid IN 
                      (SELECT ddp.departmentid 
                       FROM   dbo.dc_department_position 
                              ddp 
                       WHERE  ddp.positiongroupid IN( 1, 2 
                              ) 
                               OR ddp.departmentpositionid 
                                  = 21)) 
           UNION 
           SELECT 2                                              FormTypeId, 
                  dw.workplaceid                                 AS Id, 
                  Isnull(' ' + dp.personnelname, '') 
                  + Isnull(' ' + dp.personnelsurname, '') 
                  + Isnull(' ' + dp.personnellastname, '') 
                  + Isnull(' ' + ddp.departmentpositionname, '') AS NAME, 
                  dpg.positiongrouplevel 
           FROM   dbo.dc_workplace dw 
                  JOIN dbo.dc_user du 
                    ON dw.workplaceuserid = du.userid 
                  JOIN dbo.dc_personnel dp 
                    ON du.userpersonnelid = dp.personnelid 
                  JOIN dbo.dc_department_position ddp 
                    ON dw.workplacedepartmentpositionid = 
                       ddp.departmentpositionid 
                  JOIN dbo.dc_position_group dpg 
                    ON ddp.positiongroupid = dpg.positiongroupid 
                  JOIN dbo.dc_workplace_role dwr 
                    ON dw.workplaceid = dwr.workplaceid 
           WHERE  dp.personnelstatus = 1 
                  AND dwr.roleid = 240 
                  AND dw.workplaceid IN (SELECT dw.workplaceid 
                                         FROM   dbo.dc_workplace dw 
                                         WHERE  dw.workplacedepartmentpositionid 
                                                IN 
                                                (SELECT ddp.departmentpositionid 
                                                 FROM 
                                                dbo.dc_department_position ddp 
                                                WHERE 
                                                ddp.positiongroupid IN 
                      (SELECT dpg.positiongroupid 
                       FROM   dbo.dc_position_group 
                              dpg 
                       WHERE  dpg.positiongroupid IN( 
                              5 ) 
                              AND dpg.positiongroupstatus 
                                  = 1)) 
                      AND dw.workplaceorganizationid = 1) 
            UNION 
            SELECT 10                  FormTypeId, 
                   dcdp.departmentid   Id, 
                   dcdp.departmentname [Name], 
                   ''                  AS PositionGroupLevel 
            FROM   dbo.dc_department dcdp 
            WHERE 
       
             departmentorganization = 1 
              AND departmenttypeid IN ( 5, 1 ) AND dcdp.DepartmentId NOT IN (1155,1156,1059)
			UNION  SELECT 10                  FormTypeId, 
                   do.OrganizationId   Id, 
                   do.OrganizationName [Name], 
                   ''                  AS PositionGroupLevel 
            FROM  dbo.DC_ORGANIZATION do 
            WHERE 
      
             do.OrganizationTopId = 1 ) s 
    ORDER  BY s.positiongrouplevel ASC; 
END; 

