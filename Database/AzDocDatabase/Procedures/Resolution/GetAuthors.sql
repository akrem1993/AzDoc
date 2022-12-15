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
-- Author:  <Abdullayeva Gular>
-- Create date: <6/23/2019>
-- Description: <Get Authors for Direction>
-- =============================================
CREATE PROCEDURE [resolution].[GetAuthors]
--@workplaceId int=null,
@docId int=null,
@directionId int=null,
@directionConfirmedId int=null,
@directionCreatorWorkplaceId int=null,
@directionWorkplaceId int=null


AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 IF( @directionId < 0 ) 
  -- or @directionConfirmedId=1/*DMSMigrate3*/) 
  IF EXISTS (SELECT TOP 1 * FROM dbo.DOCS_EXECUTOR dd WHERE dd.ExecutorDocId=@docId AND dd.DirectionTypeId!=11 AND dd.ExecutorWorkplaceId=24)--rol
		BEGIN     
		 SELECT fromworkplaceid                    AS DirectionWorkplaceID, 
             dbo.Get_person(2, fromworkplaceid) AS DirectionPersonFullName 
      FROM   dc_resolution_right 
      WHERE  toworkplaceid = 2
	   END
		ELSE
  BEGIN 
      SELECT fromworkplaceid                    AS DirectionWorkplaceID, 
             dbo.Get_person(2, fromworkplaceid) AS DirectionPersonFullName 
      FROM   dc_resolution_right 
      WHERE  toworkplaceid = @directionWorkplaceId
  END 
ELSE 


--IF( @directionId < 0 ) 
--  -- or @directionConfirmedId=1/*DMSMigrate3*/) 

--  BEGIN 
--      SELECT fromworkplaceid                    AS DirectionWorkplaceID, 
--             dbo.Get_person(2, fromworkplaceid) AS DirectionPersonFullName 
--      FROM   dc_resolution_right 
--      WHERE  toworkplaceid = @directionWorkplaceId
--  END 
--ELSE 
  BEGIN /*derkenar hazirliyan shexsin esas icraci olub olmadigi yoxlanirlir*/
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
                        AND directioncreatorworkplaceid = 24  /*24 rol teyin olunamdigi ucun workplace id yazilir.umumi shobenin mudiri rolu*/ 
                        AND executorworkplaceid =  24 
                        AND de.directiontypeid = 1 
                        AND (executormain = 1 or SendStatusId=2)) --umumi shobenin mudirine  icra ve ya icra ve melumat ucun gelerse
        BEGIN 
            SELECT directionworkplaceid, 
                   directionpersonfullname 
            FROM   docs_directions 
            WHERE  directiondocid = @docId 
                   AND directiontypeid = 1 
				   and DirectionId=@directionId
        END 
		ELSE IF EXISTS (SELECT TOP 1 * FROM dbo.DOCS_EXECUTOR dd WHERE dd.ExecutorDocId=@docId AND dd.DirectionTypeId!=11 AND dd.ExecutorWorkplaceId=24)
						--BEGIN
						--            SELECT directionworkplaceid, 
      --             directionpersonfullname 
      --      FROM   docs_directions 
      --      WHERE  directiondocid = @docId 
      --             AND directiontypeid = 1 
				  -- and DirectionId=@directionId
				  -- UNION 
	       SELECT ExecutorWorkplaceId AS DirectionWorkplaceID,ExecutorFullName AS DirectionPersonFullName
	      FROM dbo.DOCS_EXECUTOR dd WHERE dd.ExecutorDocId=@docId AND  dd.ExecutorWorkplaceId=24 AND dd.DirectionTypeId=1
		--  END

      --  else 
      --  begin  
      SELECT directionid 
      FROM   docs_directions 
      WHERE  directiondocid = @docId 
             AND ( directionid != @directionId 
                   AND directionconfirmed = @directionConfirmedId 
                   AND directioncreatorworkplaceid = 
                       @directionCreatorWorkplaceId 
                   AND directionworkplaceid = @directionWorkplaceId ) 
  --end 
  END 


END

