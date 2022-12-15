CREATE   PROC [orgrequests].GetDocs
@docIds nvarchar(max)=NULL
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
    orgrequests.OrgRequestsDocs ord
    WHERE
    ord.DocId=d.[value]
) as allDocs
ORDER BY
allDocs.DirectionInsertedDate DESC,
allDocs.ExecutorReadStatus
end
