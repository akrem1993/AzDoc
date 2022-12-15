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
-- Author:  Abdullayeva Gular
-- Create date: 22.06.2019
-- Description: Senedin emeliyyatlarini getirmek
-- =============================================
CREATE PROCEDURE [outgoingdoc].[GetDocumentActions] 
@docId int,
@workPlaceId int,
@menuTypeId int=0
AS
BEGIN
DECLARE @Actions TABLE(
                        Id INT, 
                        Name NVARCHAR(MAX),
                        ActionIndex INT);

DECLARE
@documentStatusId INT,
@documentStatusName NVARCHAR(MAX), 
@directionType INT, 
@docCreatorWorkPLaceId INT, 
@docTypeId INT, 
@executorReadStatus INT,
@sendStatus INT, 
@positonGroupId INT,
@isViza bit=0;


SELECT 
@docTypeId = d.DocDoctypeId, 
@documentStatusId = d.DocDocumentstatusId, 
@documentStatusName = ds.DocumentstatusName, 
@docCreatorWorkPLaceId = d.DocInsertedById
FROM
dbo.DOCS d JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
WHERE 
d.DocId = @docId
--AND d.DocResultId IS NULL;

 SELECT
 @directionType = e.DirectionTypeId, 
 @executorReadStatus = e.ExecutorReadStatus, 
 @sendStatus = e.SendStatusId
 FROM dbo.DOCS_EXECUTOR e
 WHERE 
 e.ExecutorDocId = @docId
 AND e.ExecutorWorkplaceId = @workPlaceId
 AND e.ExecutorReadStatus = 0;

  --/* Muveqqeti redakte aciram */
        IF EXISTS
        (
            SELECT dew.*
            FROM dbo.DOCS_EDIT_WORKPLACE dew
            WHERE dew.WorkPlaceId = @workPlaceId
                  AND dew.DocId = @docId
                  AND dew.IsStatus = 1
        )
            BEGIN
                INSERT INTO @Actions
                (Id, 
                 Name, 
                 ActionIndex
                )
                       SELECT dan.ActionId, 
                              dan.ActionName, 
                              dan.ActionIndex
                       FROM dbo.DOC_ACTION_NAME dan
                       WHERE dan.ActionId = 2;
        END;

        /* Muveqqeti redakte aciram */

 IF (@directionType=3 AND EXISTS(SELECT dv.VizaId 
         FROM dbo.DOCS_VIZA dv
         WHERE 
         dv.VizaDocId=@docId
         AND dv.VizaWorkPlaceId=@workPlaceId 
         AND dv.VizaFromWorkflow in(3,4)))
         --or 
         --EXISTS(SELECT dv.VizaId 
         --FROM dbo.DOCS_VIZA dv
         --WHERE 
         --dv.VizaDocId=@docId
         --AND dv.VizaWorkPlaceId=@workPlaceId 
           --)
 SET @isViza=1;

 INSERT INTO @Actions
   (Id,
    Name, 
   ActionIndex)
 SELECT 
 dan.ActionId, 
 dan.ActionName, 
 dan.ActionIndex
 FROM dbo.DOC_ACTION_TYPE dat
 INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
 WHERE 
 dat.DocTypeId = @docTypeId
 AND dat.DocumentStatusId = @documentStatusId
 AND dat.DirectionType = @directionType
 AND dan.MenuType in (0,@menuTypeId)
 AND dan.ActionStatus = 1
 AND dat.ActionId NOT IN
   (SELECT CASE WHEN @docCreatorWorkPLaceId = @workPlaceId THEN 9
         ELSE-1
         END
   )  
 AND dat.ActionId NOT IN (SELECT CASE WHEN @isViza=1 THEN 2  ELSE -1 end)
 AND dat.ActionId not in (select case when @isViza=1 Then 3 Else -1 end)

 ORDER BY dan.ActionIndex ASC;


 IF EXISTS( SELECT a.Id FROM @Actions a)
 BEGIN
   SELECT a.Id AS Id, 
    a.Name
   FROM @Actions a
   ORDER BY a.ActionIndex ASC;
 END
 ELSE
 BEGIN
   SELECT-1 AS Id, N'Sənəd ' + LOWER(@documentStatusName) AS Name;
 END;

END

