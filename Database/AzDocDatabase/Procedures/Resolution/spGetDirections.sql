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
CREATE PROCEDURE [resolution].[spGetDirections]
 @docId int,
 @workPlaceId int,
 @redirectTypeId int,
 @pageIndex int=1,
 @pageSize int=20,
 @totalCount int output

AS
BEGIN 
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements. 
    SET nocount ON; 
    SET @totalCount=0; 

    --set @totalCount =4 
    -- Insert statements for procedure here 
    SELECT * 
    FROM   (SELECT dd.directionid, 
                   directiondocid, 
                   directiondate, 
                   directionworkplaceid, 
                   directionpersonfullname, 
                   directiontemplateid, 
                   directiontypeid, 
                   directioncontrolstatus, 
                   directionplanneddate, 
                   directionvizaid, 
                   directionconfirmed, 
                   directionsendstatus, 
                   directioncreatorworkplaceid, 
                   directioninserteddate, 
                   directionpersonid, 
                   directionunixtime, 
                   changetype, 
                   Stuff((SELECT ',' + executorfullname 
                          FROM   [dbo].[docs_executor] AS de 
                                 JOIN dc_workplace dw 
                                   ON dw.workplaceid = de.executorworkplaceid 
                                 JOIN [dc_department_position] dp 
                                   ON 
           dp.departmentpositionid = dw.workplacedepartmentpositionid 
                   JOIN dc_position_group dcp 
                     ON dcp.positiongroupid = dp.positiongroupid 
            WHERE  [executordirectionid] = dd.directionid 
                   AND executormain = 1 
				   	  and (ExecutionstatusId is NULL  OR de.ExecutionstatusId=1)
            ORDER  BY executormain, 
                      positiongrouplevel 
            FOR xml path('')), 1, 1, '') MainExecutor, 
                   Stuff((SELECT ',' + executorfullname 
                          FROM   [dbo].[docs_executor] AS de 
                                 JOIN dc_workplace dw 
                                   ON dw.workplaceid = de.executorworkplaceid 
                                 JOIN [dc_department_position] dp 
                                   ON 
           dp.departmentpositionid = dw.workplacedepartmentpositionid 
                   JOIN dc_position_group dcp 
                     ON dcp.positiongroupid = dp.positiongroupid 
            WHERE  [executordirectionid] = dd.directionid 
                   AND executormain <> 1 
                   AND sendstatusid NOT IN ( 5, 14, 15,10/*silinib*/ ) 
				   and (ExecutionstatusId is NULL /* OR de.ExecutionstatusId=1*/)
            --and ExecutionstatusId not in (14) 
            ORDER  BY executormain, 
                      positiongrouplevel 
            FOR xml path('')), 1, 1, '') CommonExecutors 
            FROM   docs_directions dd 
                   LEFT JOIN docs_directionchange dc 
                          ON dc.directionid = dd.directionid 
                             AND directionchangestatus = 0 
            WHERE  directiondocid = @docId 
	
                   AND @workPlaceId IN ( directioncreatorworkplaceid, 
                                         directionworkplaceid 
                                       ) 
                   AND directiontypeid IN ( @redirectTypeId, 6, 7,20 )) e 
    WHERE  ( @workPlaceId = directionworkplaceid 
             AND ( Len(e.mainexecutor) > 0 
                    OR Len(e.commonexecutors) > 0 ) and  DirectionTypeId!=20 ) --derkanrin tesdiginnen imtina hali 
            OR ( @workPlaceId != directionworkplaceid  )

    ORDER  BY directionid 
END 


