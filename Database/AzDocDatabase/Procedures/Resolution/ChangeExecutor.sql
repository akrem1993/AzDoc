
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  <A.Gular>
-- Create date: <7/22/2019>
-- Description: <Change Main Executor>
-- =============================================
CREATE PROCEDURE [resolution].[ChangeExecutor] @operation              INT, 
                                              @docTypeId              INT, 
                                              @currentWorkplaceId     INT            = NULL, 
                                              @docId                  INT, 
                                              @executorResolutionNote NVARCHAR(4000) = NULL, 
                                              @directionTypeId        INT, --1
                                              @newWorkplaceId         INT            = NULL, 
                                              @directionId            INT            = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;
        IF(@operation = 3) --deyiwdirilme ucun gondermek 
            BEGIN
                DECLARE @authorWorkplace INT, @executorId INT, @existDirectionId INT,	@operationId              INT;
                SET @executorId =
                (
                    SELECT  executorid
                    FROM dbo.docs_executor
                    WHERE executordirectionid = @existDirectionId
                          AND executorworkplaceid = @currentWorkplaceId
					

                );				
                SELECT @authorWorkplace = directionworkplaceid, 
                       @existDirectionId = directionid
                FROM docs_directions
                WHERE directionid =
                (
                    SELECT TOP (1) executordirectionid
                    FROM docs_executor
                    WHERE executordocid = @docId
                          AND executorworkplaceid = @currentWorkplaceId
                          AND directiontypeid = 1
                          AND executormain = 1 ORDER BY dbo.docs_executor.ExecutorId desc
                );
			
                SELECT   TOP (1) executorid
                FROM dbo.docs_executor
                WHERE executordirectionid = @existDirectionId
                      AND executorworkplaceid = @currentWorkplaceId
					  ORDER BY dbo.docs_executor.ExecutorId DESC
			
					   
 INSERT dbo.DocOperationsLog
 (
     --OperationId - column value is auto-generated
     DocId,
     ExecutorId,
     SenderWorkPlaceId,
     ReceiverWorkPlaceId,
     DocTypeId,
     OperationTypeId,
     DirectionTypeId,
     OperationDate,
     OperationStatus,
     OperationStatusDate,
     OperationNote,
  OperationFileId
 )
 VALUES
 (
     -- OperationId - int
     @docId, -- DocId - int
     NULL, -- ExecutorId - int
     @currentWorkplaceId, -- SenderWorkPlaceId - int
     @authorWorkplace, -- ReceiverWorkPlaceId - int
     1, -- DocTypeId - int
     10, -- OperationTypeId - int
     6, -- DirectionTypeId - int
     dbo.SYSDATETIME(), -- OperationDate - datetime
     1, -- OperationStatus - int
     NULL, -- OperationStatusDate - datetime
     @executorResolutionNote, -- OperationNote - nvarchar,
  NULL
 )
    SET @operationId = SCOPE_IDENTITY();

                INSERT INTO dbo.docs_directionchange
                VALUES
                (@existDirectionId, 
                 @docId, 
                 @currentWorkplaceId, 
                 @newWorkplaceId, 
                 NULL, 
                 NULL, 
                 @executorResolutionNote, 
                 dbo.Sysdatetime(), 
                 0, 
                 NULL, 
                 1, 
                 NULL,
				 @operationId
                );

                UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarinda gorunmesi ucun temp
                  SET 
                      executorreadstatus = 0, 
                      ExecutorControlStatus = 0,
					  sendstatusid=10
                WHERE ExecutorWorkplaceId = @authorWorkplace
                AND executorDocId=@docId				                   
              AND (DirectionTypeId=12 OR DirectionTypeId=18)
			    -- AND executordirectionid = @existDirectionId;
		     	--AND SendStatusId=5;--

                UPDATE docs_executor
                SET 
                docs_executor.ExecutionstatusId=1,
                docs_executor.ExecutorReadStatus=1
                WHERE
                docs_executor.ExecutorDocId=@docId
                AND docs_executor.ExecutorWorkplaceId=@currentWorkplaceId
                AND docs_executor.ExecutorReadStatus=0
                AND docs_executor.ExecutorMain=1
                AND docs_executor.SendStatusId=1
				  --EXEC dbo.Logdocumentoperation 
      --               @docId = @docId, 
      --               @ExecutorId = NULL, 
      --               @SenderWorkPlaceId = @currentWorkplaceId, 
      --               @ReceiverWorkPlaceId = @authorWorkplace, 
      --               @DocTypeId = 1, --  
      --               @OperationTypeId = 10, 
      --               @DirectionTypeId = 6, 
      --               @OperationStatusId = 1, 
      --               @OperationStatusDate = NULL, 
      --               --temp   
      --               @OperationNote = @executorResolutionNote;
              
        END;
        IF(@operation = 1) --tesdig 
            BEGIN
                DECLARE @oldExecutor INT, @newMainExecutor INT, @executorTopId INT, @newExecutorName NVARCHAR(500), @oldExecutorName NVARCHAR(500), @oldExecutorId INT, @newExecutorId INT;

                --select @directionId = DirectionId  from DOCS_DIRECTIONS where DirectionDocId=@docId and DirectionWorkplaceId=@currentWorkplaceId
                SET @executorId =
                (
                    SELECT executorid
                    FROM docs_executor
                    WHERE executordirectionid = @directionId
                          AND executorworkplaceid = @currentWorkplaceId
                );
                SELECT @oldExecutor = oldexecutorworkplaceid, 
                       @newWorkplaceId = newexecutorworkplaceid
                FROM docs_directionchange
                WHERE docid = @docId
                      AND directionid = @directionId;
                SELECT @newExecutorName = [dbo].[Get_person](2, @newWorkplaceId);
                SELECT @oldExecutorName = [dbo].[Get_person](2, @oldExecutor);
                SELECT @executorTopId = CASE
                                            WHEN de.executortopid IS NULL
                                            THEN de.executorid
                                            ELSE de.executortopid
                                        END
                FROM dbo.docs_executor de
                WHERE executordirectionid = @directionId
                      AND executormain = 1; 

				UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarindan itemsi ucun 
				 SET 
                      executorreadstatus = 1, 
                      ExecutorControlStatus = 1					
                WHERE 				
                executorDocId=@docId				                    
              AND (DirectionTypeId=12 OR DirectionTypeId=18)
		     	AND SendStatusId=10
				--AND ExecutorWorkplaceId = @currentWorkplaceId;

                UPDATE dbo.docs_executor
                  SET 
                      executionstatusid = 2
                WHERE executordirectionid = @directionId
                      AND executormain = 1
                      AND executorworkplaceid = @oldExecutor;
                IF EXISTS
                (
                    SELECT *
                    FROM dbo.docs_executor
                    WHERE dbo.docs_executor.ExecutorDirectionId = @directionId
                          AND dbo.docs_executor.ExecutorWorkplaceId = @newWorkplaceId
                )
                    BEGIN
                        UPDATE dbo.docs_executor
                          SET 
                              executionstatusid = 2, 
                              executorreadstatus = 1
                        WHERE executordirectionid = @directionId
                              AND executorworkplaceid = @newWorkplaceId;
                END;
                UPDATE dbo.docs_directionchange
                  SET 
                      directionchangestatus = 1, 
                      directionchangeconfirmnote = @executorResolutionNote
                WHERE docid = @docId
                      AND directionid = @directionId;
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
select  d.DepartmentOrganization,
          d.DepartmentTopDepartmentId,
          d.DepartmentId,
          d.DepartmentSectionId,
          d.DepartmentSubSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor
                INSERT INTO dbo.docs_executor
                (executordirectionid, 
                 executordocid, 
                 executorworkplaceid, 
                 executorfullname, 
                 executormain, 
                 directiontypeid, 
                 executororganizationid, 
                 executortopdepartment, 
                 executordepartment, 
                 executorsection, 
                 executorsubsection, 
                 executorstepid, 
                 executionstatusid, 
                 executornote, 
                 executorreadstatus, 
                 executorresolutionnote, 
                 sendstatusid, 
                 executortopid
                )
                VALUES
                (@directionId, 
                 @docId, 
                 @oldExecutor, 
                 @oldExecutorName, 
                 0, 
                 1, 
                 (select  d.DepartmentOrganization         
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor),-- executororganizationid
                 (select d.DepartmentTopDepartmentId         
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor), --executortopdepartment
                ( select  d.DepartmentId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor), --executordepartment
                 (select  d.DepartmentSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor), --executorsection
                 (select d.DepartmentSubSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @oldExecutor), --executorsubsection
                 NULL, 
                 NULL, 
                 NULL, 
                 0, --- 
                 @executorResolutionNote, 
                 2, 
                 @executorTopId
                );
                SET @oldExecutorId = SCOPE_IDENTITY();
                INSERT INTO dbo.docs_executor
                (executordirectionid, 
                 executordocid, 
                 executorworkplaceid, 
                 executorfullname, 
                 executormain, 
                 directiontypeid, 
                 executororganizationid, 
                 executortopdepartment, 
                 executordepartment, 
                 executorsection, 
                 executorsubsection, 
                 executorstepid, 
                 executionstatusid, 
                 executornote, 
                 executorreadstatus, 
                 executorresolutionnote, 
                 sendstatusid, 
                 executortopid
                )
                VALUES
                (@directionId, 
                 @docId, 
                 @newWorkplaceId, 
                 @newExecutorName, 
                 1, 
                 1, 
                 (select  d.DepartmentOrganization         
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @newWorkplaceId),-- executororganizationid
                 (select d.DepartmentTopDepartmentId         
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @newWorkplaceId), --executortopdepartment
                ( select  d.DepartmentId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @newWorkplaceId), --executordepartment
                 (select  d.DepartmentSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @newWorkplaceId), --executorsection
                 (select d.DepartmentSubSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              where w.WorkplaceId= @newWorkplaceId), --executorsubsection
                 NULL, 
                 NULL, 
                 NULL, 
                 0, --- 
                 @executorResolutionNote, 
                 1, 
                 @executorTopId
                );
                SET @newExecutorId = SCOPE_IDENTITY();
                INSERT INTO dbo.docoperationslog
                (docid, 
                 executorid, 
                 senderworkplaceid, 
                 receiverworkplaceid, 
                 doctypeid, 
                 operationtypeid, 
                 directiontypeid, 
                 operationstatus, 
                 operationstatusdate, 
                 operationnote, 
                 operationdate
                )
                VALUES
                (@docId, 
                 @newExecutorId, 
                 @currentWorkplaceId, 
                 @newWorkplaceId, 
                 1, 
                 1, 
                 1, 
                 1, 
                 NULL, 
                 @executorResolutionNote, 
                 dbo.Sysdatetime()
                ),
                (@docId, 
                 @oldExecutorId, 
                 @currentWorkplaceId, 
                 @oldExecutor, 
                 1, 
                 2, 
                 1, 
                 1, 
                 NULL, 
                 @executorResolutionNote, 
                 dbo.Sysdatetime()
                );
        END;
        IF(@operation = 2)--imtina
            BEGIN
                SELECT @oldExecutor = oldexecutorworkplaceid, 
                       @newWorkplaceId = newexecutorworkplaceid
                FROM dbo.docs_directionchange
                WHERE docid = @docId
                      AND directionid = @directionId;
				UPDATE dbo.docs_executor
                SET 
               docs_executor.ExecutionstatusId=0,
                docs_executor.ExecutorReadStatus=0,
				docs_executor.ExecutorControlStatus=0
                WHERE
                docs_executor.ExecutorDocId=@docId
                AND docs_executor.ExecutorWorkplaceId=@oldExecutor
                --AND docs_executor.ExecutorReadStatus=0
                AND docs_executor.ExecutorMain=1
                AND docs_executor.SendStatusId=1
			 UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarindan itemsi ucun 
				 SET 
                      executorreadstatus = 1, 
                      ExecutorControlStatus = 1					
                WHERE 				
                executorDocId=@docId				                    
              AND (DirectionTypeId=12 OR DirectionTypeId=18)
		     	AND SendStatusId=10
				--AND ExecutorWorkplaceId = @currentWorkplaceId;

                UPDATE dbo.docs_directionchange
                  SET 
                      directionchangestatus = 2, 
                      directionchangeconfirmnote = @executorResolutionNote
                WHERE docid = @docId
                      AND directionid = @directionId;
                UPDATE dbo.docs_directions ---muellifin directype-nin yeniden deyiwmesi 
                  SET 
                      directiontypeid = 1
                WHERE directionid = @directionId;
                EXEC dbo.Logdocumentoperation --muellifden icraciya yeniden icra ucun 
                     @docId = @docId, 
                     @ExecutorId = @executorId, 
                     @SenderWorkPlaceId = @currentWorkplaceId, 
                     @ReceiverWorkPlaceId = @oldExecutor, 
                     @DocTypeId = 1, --  
                     @OperationTypeId = 1, 
                     @DirectionTypeId = 1, 
                     @OperationStatusId = 1, 
                     @OperationStatusDate = NULL, 
                     --temp   
                     @OperationNote = @executorResolutionNote;
        END;
    END;

