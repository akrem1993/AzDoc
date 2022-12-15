/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  <A.Gular>
-- Create date: <7/22/2019>
-- Description: <Change execution date>
-- =============================================
CREATE PROCEDURE [resolution].[ChangeExecutionDate] 
@changeType int=null,
@newDirectionPlannedDate DateTime=null,
@currentWorkplaceId int=null,--270-f
@executorResolutionNote  nvarchar(4000)=null,
@operation int,
@docId int,
@docTypeId int,
@directionTypeId int, --1
@directionId int=null

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
IF( @operation = 3 ) --deyiwdirilme ucun gondermek 
  BEGIN 

DECLARE @oldDirectionPlannedDate DATETIME, 
        @authorWorkplace         INT, 
        @executorId              INT, 
		@operationId              INT,
        @existdirectionId        INT; 

SELECT @oldDirectionPlannedDate = docplanneddate 
FROM   docs 
WHERE  docid = @docId 

SELECT @authorWorkplace = directionworkplaceid, 
       @existdirectionId = directionid 
FROM   docs_directions 
WHERE  directionid = (SELECT executordirectionid 
                      FROM   docs_executor 
                      WHERE  executordocid = @docId 
                             AND executorworkplaceid = @currentWorkplaceId 
                             AND directiontypeid = 1 
                             AND executormain = 1) 

SELECT @executorId = executorid 
FROM   docs_executor 
WHERE  executordirectionid = @existdirectionId 
       AND executorworkplaceid = @currentWorkplaceId 

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
     @executorId, -- ExecutorId - int
     @currentWorkplaceId, -- SenderWorkPlaceId - int
     @authorWorkplace, -- ReceiverWorkPlaceId - int
     1, -- DocTypeId - int
     6, -- OperationTypeId - int
     7, -- DirectionTypeId - int
     dbo.SYSDATETIME(), -- OperationDate - datetime
     1, -- OperationStatus - int
     NULL, -- OperationStatusDate - datetime
     @executorResolutionNote, -- OperationNote - nvarchar,
  NULL
 )
    SET @operationId = SCOPE_IDENTITY();


INSERT INTO docs_directionchange 
VALUES      (@existdirectionId, 
             @docId, 
             NULL, 
             NULL, 
             @oldDirectionPlannedDate, 
             @newDirectionPlannedDate, 
             @executorResolutionNote, 
             dbo.SYSDATETIME(), 
             0, 
             NULL, 
             2, 
             NULL,
			 @operationId) 



                UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarinda gorunmesi ucun temp
                  SET 
                      executorreadstatus = 0, 
                      ExecutorControlStatus = 0,
					  sendstatusid=6
                WHERE ExecutorWorkplaceId = @authorWorkplace
                AND executorDocId=@docId				                    
             -- AND DirectionTypeId=12
  END 
IF( @operation = 1 ) --tesdig 
 BEGIN 
 	UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarindan itemsi ucun 
				 SET 
                      executorreadstatus = 1, 
                      ExecutorControlStatus = 1					
                WHERE 				
                executorDocId=@docId	
		     	AND SendStatusId=6
				--AND ExecutorWorkplaceId = @currentWorkplaceId;

  UPDATE dbo.docs_directionchange 
  SET    directionchangestatus=1, 
         directionchangeconfirmnote=@executorResolutionNote 
  WHERE  docid=@docId 
  AND    directionid=@directionId 
  SELECT TOP 1 @newdirectionplanneddate=newdirectionplanneddate, 
         @oldDirectionPlannedDate=olddirectionplanneddate
          
  FROM   dbo.docs_directionchange 
  WHERE  docid=@docId 
  AND    directionid=@directionId 
      ORDER BY dbo.docs_directionchange.DirectionChangeId  DESC

	UPDATE dbo.docs 
	SET     DocPlannedDateD = @newdirectionplanneddate 
	WHERE  docid = @docId 

	UPDATE dbo.DOCS_DIRECTIONS 
	SET    directionplanneddate = @newdirectionplanneddate 
	WHERE  directionid = @directionId 
 
END
IF(@operation=2)--imtina 
BEGIN 
UPDATE dbo.docs_executor --tesdig eden wexsin oxunmamiwlarindan itemsi ucun 
				 SET 
                      executorreadstatus = 1, 
                      ExecutorControlStatus = 1					
                WHERE 				
                executorDocId=@docId	
		     	AND SendStatusId=6
				--AND ExecutorWorkplaceId = @currentWorkplaceId;
  UPDATE dbo.docs_directionchange 
  SET    directionchangestatus=2, 
         directionchangeconfirmnote=@executorResolutionNote 
  WHERE  docid=@docId 
  AND    directionid=@directionId 

   
 END
END

