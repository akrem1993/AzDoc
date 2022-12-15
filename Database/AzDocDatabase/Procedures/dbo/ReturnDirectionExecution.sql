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
-- Author:  Musayev Nurlan
-- Create date: 26.06.2019
-- Description: Derkenarla gelen senedin geri qaytarilmasi
-- =============================================
CREATE PROCEDURE [dbo].[ReturnDirectionExecution]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null
AS
DECLARE 
@docType int,
@docStatus int,
@executorId int,
@executorDirectionId int,
@senderWorkPlaceId int,
@senderExecutorId int
BEGIN
SELECT @docType=d.DocDoctypeId,@docStatus=d.DocDocumentstatusId FROM dbo.DOCS d WHERE d.DocId=@docId AND d.DocDeleted=0;
    
IF @docType IS NULL THROW 56000,'Sened tapilmadi',1;

IF @docStatus<>1 THROW 56000,'Sened icraatda deyil',1;
    
SELECT 
@executorId=de.ExecutorId,
@senderWorkPlaceId=dd.DirectionWorkplaceId,
@executorDirectionId=dd.DirectionId
FROM dbo.DOCS_EXECUTOR de 
JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
WHERE 
de.ExecutorDocId=@docId 
AND de.ExecutorWorkplaceId=@workPlaceId 
AND de.DirectionTypeId=1
AND de.ExecutorReadStatus=0;

IF @executorId IS NULL THROW 56000,'Movcud icraci tapilmadi',1;

SELECT @senderExecutorId= de.ExecutorId FROM dbo.DOCS_EXECUTOR de
JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
WHERE
de.ExecutorDocId=@docId
AND de.ExecutorReadStatus=1
AND de.SendStatusId IS NOT NULL
AND de.ExecutorWorkplaceId=@senderWorkPlaceId
AND de.DirectionTypeId=1
AND dd.DirectionConfirmed=1;


UPDATE dbo.DOCS_EXECUTOR--ozu oxunulmuw kimi teyin olunur
SET
ExecutorReadStatus = 1,
ExecutorControlStatus=1,
dbo.DOCS_EXECUTOR.ExecutorMain=0,
dbo.DOCS_EXECUTOR.ExecutionstatusId=1--geri qaytarilib
WHERE 
dbo.DOCS_EXECUTOR.ExecutorId=@executorId

UPDATE dbo.DOCS_EXECUTOR--
SET
ExecutorReadStatus = 0,
ExecutorControlStatus=0
WHERE 
dbo.DOCS_EXECUTOR.ExecutorId=@senderExecutorId;

--UPDATE dbo.DOCS_DIRECTIONS
--SET
--DirectionConfirmed = 0 -- tinyint
--WHERE 
--DirectionId=@executorDirectionId;


EXEC dbo.LogDocumentOperation
 @docId = @docId,
 @ExecutorId = null,
 @SenderWorkPlaceId = @workPlaceId,
 @ReceiverWorkPlaceId =  @senderWorkPlaceId,
 @OperationTypeId = 17,
 @DirectionTypeId = 20,
 @OperationStatusId = null,
 @OperationStatusDate = null,
 @OperationNote =@note

    
END

