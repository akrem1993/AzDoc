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
-- Create date: 08.07.2019
-- Description: 
-- =============================================
CREATE PROCEDURE [dbo].[GetNotify]
@workPlaceId int
AS
SET NOCOUNT on;
BEGIN
    DECLARE @feedBackMessages int= dbo.fnGetFeedBackNotificationCount(@workPlaceId);
    DECLARE @unreadDocumentsCount int;

SELECT @unreadDocumentsCount = COUNT(0)
        FROM dbo.VW_DOC_INFO AS d
             LEFT JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
             LEFT JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
             LEFT JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
             LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
             LEFT JOIN dbo.DocOperationsLog dol ON dol.ExecutorId = e.ExecutorId
             LEFT JOIN dbo.DocOperationTypes dot ON dol.OperationTypeId = dot.TypeId
        WHERE e.ExecutorWorkplaceId = @workPlaceId
              AND e.ExecutorReadStatus = 0
              AND e.ExecutorControlStatus=0
              AND e.DirectionTypeId <> 4
              AND (
        (
            SELECT CASE
                       WHEN e.DirectionTypeId = 13
                       THEN 1
                       ELSE ISNULL(dr.DirectionConfirmed, 0)
                   END
        ) != 0
        OR
        (
            SELECT CASE
                       WHEN e.DirectionTypeId = 12
                       THEN 1
                       ELSE ISNULL(dr.DirectionConfirmed, 0)
                   END
        ) != 0);

SELECT @feedBackMessages AS FeedBackMessagesCount,@unreadDocumentsCount AS UnreadDocumentsCount;


END

