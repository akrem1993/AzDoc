-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 27.09.2019
-- Description:	Xidmeti mektubda melumat ucun gelen senedi geri qaytarilmasi
-- =============================================
CREATE PROCEDURE [serviceletters].[ReturnInfoDocument]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null
AS
DECLARE
@taskExecutorId int,
@taskDirectonId int,
@docStatus INT;
BEGIN
select @docStatus=d.DocDocumentstatusId from dbo.DOCS d where d.DocId=@docId AND d.DocDeleted=0;

IF @docStatus IS NULL THROW  56000,'Mövcud sənəd tapılmadı',1;

IF @docStatus not IN (35,16) THROW  56000,'Sənəd icrada deyil',1;

IF not EXISTS(SELECT dt.TaskId FROM dbo.DOC_TASK dt
              JOIN dbo.DOCS d ON dt.TaskDocId=d.DocId 
              WHERE 
              dt.TaskDocId=@docId 
              AND dt.TypeOfAssignmentId=3
              AND dt.WhomAddressId=@workPlaceId
              AND d.DocDoctypeId=18)
THROW  56000,'Mövcud şəxs tapılmadı',1;

SELECT 
@taskDirectonId=dd.DirectionId,
@taskExecutorId=de.ExecutorId 
FROM dbo.DOCS_EXECUTOR de
JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
WHERE 
de.ExecutorWorkplaceId=@workPlaceId
AND de.DirectionTypeId=18
AND de.ExecutorReadStatus=0
AND dd.DirectionConfirmed=1
     
UPDATE dbo.docs_directions
SET
dbo.docs_directions.DirectionConfirmed=0
WHERE 
dbo.docs_directions.DirectionId=@taskDirectonId

UPDATE dbo.DOCS_EXECUTOR
SET
    dbo.DOCS_EXECUTOR.ExecutionstatusId =1, -- int
    dbo.DOCS_EXECUTOR.ExecutorNote = @note, -- nvarchar
    dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1, -- bit
    dbo.DOCS_EXECUTOR.ExecutorResolutionNote = @note,
    dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1 -- bit
WHERE 
dbo.DOCS_EXECUTOR.ExecutorId=@taskExecutorId

UPDATE dbo.DocOperationsLog
SET
    dbo.DocOperationsLog.OperationStatus = 8, -- int
    dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
    dbo.DocOperationsLog.OperationNote = @note -- nvarchar
where 
dbo.DocOperationsLog.ExecutorId=@taskExecutorId
AND dbo.DocOperationsLog.DocId=@docId

begin--======Testiq eden shexs varsa imtina edilir
DECLARE @docConfirmedWorkPlace int,@docConfirmedVizaId int
SELECT 
@docConfirmedVizaId=dv.VizaId,
@docConfirmedWorkPlace=dv.VizaWorkPlaceId 
FROM 
dbo.DOCS_VIZA dv
WHERE
dv.VizaDocId=@docId
AND dv.IsDeleted=0
AND dv.VizaConfirmed=1
AND dv.VizaFromWorkflow=2


IF @docConfirmedWorkPlace IS NOT NULL
BEGIN

UPDATE dbo.DOCS_VIZA
SET
    dbo.DOCS_VIZA.VizaConfirmed = 0, -- tinyint
    dbo.DOCS_VIZA.IsDeleted = 1 -- bit
WHERE
dbo.DOCS_VIZA.VizaId=@docConfirmedVizaId;

end
END



END

