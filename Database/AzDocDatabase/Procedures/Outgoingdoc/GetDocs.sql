-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 30.09.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE outgoingdoc.GetDocs
@docIds nvarchar(max)=null
AS
BEGIN

SELECT  
allDocs.*
FROM
(
   SELECT o.[value] FROM OPENJSON(@docIds) o
) AS d
cross apply
(
    SELECT top(1) ord.* 
    FROM 
    outgoingdoc.OutgoingDocs ord
    WHERE
    ord.DocId=d.[value]
) as allDocs
ORDER BY
allDocs.DirectionInsertedDate DESC,
allDocs.ExecutorReadStatus

END

