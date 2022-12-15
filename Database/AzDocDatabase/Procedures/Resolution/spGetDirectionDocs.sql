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
CREATE PROCEDURE [resolution].[spGetDirectionDocs] @workplaceId INT=NULL, 
                                                  /*migrate3*/ 
                                                  @docId       INT=NULL, 
                                                  @directionId INT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 
	    IF( @directionId < 0 ) 
        BEGIN 
           BEGIN 
		IF EXISTS (SELECT TOP 1 * FROM dbo.DOCS_EXECUTOR de  WHERE de.ExecutorDocId=@docId AND de.DirectionTypeId!=11 AND de.ExecutorWorkplaceId=24)
		BEGIN     select 18 as DirectionTypeId,dbo.Get_person(2, @workplaceId) DirectionPersonFullName END
		ELSE BEGIN SELECT dbo.Get_person(2, @workplaceId) DirectionPersonFullName  END       
        END 
        END 
      ---------------------- 
      ELSE 



    --IF( @directionId < 0 ) 
    --  BEGIN 
    --      SELECT dbo.Get_person(2, @workplaceId) DirectionPersonFullName 
    --  END 
    ---------------------- 
    --ELSE 
        BEGIN 
            IF EXISTS (SELECT directionid 
                       FROM   docs dc 
                              LEFT JOIN docs_directions dd 
                                     ON dd.directiondocid = dc.docid 
                              LEFT JOIN docs_executor de 
                                     ON de.executordirectionid = dd.directionid 
                       WHERE  ( @docId IS NULL 
                                 OR docid = @docId ) 
                              AND ( directionid = @directionId 
                                     OR @directionId <= 0 ) 
                              AND directionconfirmed = 1 
                              AND directioncreatorworkplaceid = 24
         AND ExecutorWorkplaceId=24
                              AND de.directiontypeid = 1 
                              AND (executormain = 1 or SendStatusId=2)) 
              BEGIN 
                  SELECT directionid, 
                         directiondocid, 
                         directionunixtime, 
                         directioncreatorworkplaceid 
                         DirectionWorkplaceId 
                         , 
                         --  else DirectionWorkplaceId end DirectionWorkplaceId, 
                         directionconfirmed, 
                         directioncontrolstatus, 
                         directionsendstatus, 
                         directiondate, 
                         dbo.Get_person(2, directioncreatorworkplaceid) 
                         DirectionPersonFullName, 
                        
                         directioninserteddate, 
                         docenterdate, 
                         docplanneddate, 
                         docdocdate, 
                         directiondate, 
                         directionworkplaceid, 
                         directioncontrolstatus, 
                         directionplanneddate, 
                         positiongroupid, 
                         docid, 
                         directionid 
      
                  FROM   docs dc 
                         LEFT JOIN docs_directions dd 
                                ON dd.directiondocid = dc.docid 
                         LEFT JOIN dc_workplace dw 
                                ON dw.workplaceid = dd.directionworkplaceid 
                         LEFT JOIN dc_department_position dp 
                                ON 
              dp.departmentpositionid = dw.workplacedepartmentpositionid 
                  WHERE  ( @docId IS NULL 
                            OR docid = @docId ) 
                         AND ( directionid = @directionId 
                                OR @directionId <= 0 ) 
              END 
            ELSE 
              BEGIN 
                  SELECT directionid, 
                         directiondocid, 
                         directionunixtime, 
                         directionworkplaceid, 
                         directionconfirmed, 
                         directioncontrolstatus, 
                         directionsendstatus, 
                         directiondate, 
                         directionpersonfullname, 
                         directionpersonfullname, 
                         directioninserteddate, 
                         docenterdate, 
                         docplanneddate, 
                         docdocdate, 
                         directiondate, 
                         directionworkplaceid, 
                         directioncontrolstatus, 
                         directionplanneddate, 
                         positiongroupid, 
                         docid, 
                         directionid
      
                  FROM   docs dc 
                         LEFT JOIN docs_directions dd 
                                ON dd.directiondocid = dc.docid 
                         LEFT JOIN dc_workplace dw 
                                ON dw.workplaceid = dd.directionworkplaceid 
                         LEFT JOIN dc_department_position dp 
                                ON 
              dp.departmentpositionid = dw.workplacedepartmentpositionid 
                  WHERE  ( @docId IS NULL 
                            OR docid = @docId ) 
                         AND ( directionid = @directionId 
                                OR @directionId <= 0 ) 
              END 
        END 
  END

