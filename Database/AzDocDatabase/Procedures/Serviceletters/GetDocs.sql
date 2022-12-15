CREATE   PROC [serviceletters].[GetDocs]
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
    SELECT top(1) sld.* 
    FROM 
    serviceletters.ServiceLettersDocs sld
    WHERE
    sld.DocId=d.[value]
   --ORDER BY
   -- sld.DirectionInsertedDate DESC,
   -- sld.ExecutorReadStatus
) as allDocs
ORDER BY
allDocs.DirectionInsertedDate DESC,
allDocs.ExecutorReadStatus
end
