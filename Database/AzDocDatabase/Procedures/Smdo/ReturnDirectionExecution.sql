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
-- Create date: 22.06.2019
-- Description: Derkenarla gelen senedin geri qaytarilmasi
-- =============================================
CREATE PROCEDURE [smdo].[ReturnDirectionExecution]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null
AS
DECLARE 
@docType int,
@executorId int,
@executorDirectionId int,
@senderWorkPlaceId int
BEGIN
SELECT @docType=d.DocDoctypeId FROM dbo.DOCS d WHERE d.DocId=@docId;
    
IF @docType IS NULL THROW 56000,'Sened tapilmadi',1;
    
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

UPDATE dbo.DOCS_EXECUTOR--ozu oxunulmuw kimi teyin olunur
SET
ExecutorReadStatus = 1 -- bit
WHERE 
dbo.DOCS_EXECUTOR.ExecutorId=@executorId

UPDATE dbo.DOCS_EXECUTOR--
SET
ExecutorReadStatus = 0, -- bit,
ExecutorMain =0
WHERE 
dbo.DOCS_EXECUTOR.ExecutorWorkplaceId=@senderWorkPlaceId
AND dbo.DOCS_EXECUTOR.ExecutorReadStatus=1
AND dbo.DOCS_EXECUTOR.SendStatusId IS NOT NULL

UPDATE dbo.DOCS_DIRECTIONS
SET
DirectionConfirmed = 0 -- tinyint
WHERE 
DirectionId=@executorDirectionId;

UPDATE dbo.DocOperationsLog
SET
    dbo.DocOperationsLog.OperationStatus = 8, -- int
    dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
    dbo.DocOperationsLog.OperationNote = @note -- nvarchar
where 
dbo.DocOperationsLog.DocId=@docId
AND dbo.DocOperationsLog.ExecutorId=@executorId;

    
END

