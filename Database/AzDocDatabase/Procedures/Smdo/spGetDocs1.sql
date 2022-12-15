
CREATE PROCEDURE [smdo].[spGetDocs1]
@isReceived bit= NULL,
@docId int= null
AS
BEGIN

IF @docid IS NULL
SELECT gsd.* FROM smdo.GetSmdoDocs gsd WHERE gsd.IsReceived=@isReceived ORDER BY gsd.DocId DESC
ELSE
SELECT 
gsd.*,
rdd.SignP7S,
rdd.AttachName,
rdd.DvcBase64,
ds.*,
CASE WHEN gsd.IsReceived=1 then 
(SELECT TOP 1 sd.DocEnterNo FROM smdo.RelatedDoc rd JOIN smdo.SmdoDocs sd ON rd.RelatedDocId = sd.DocId
 WHERE rd.DocId=gsd.DocId) 
ELSE
(SELECT TOP 1 sd.DocEnterNo FROM smdo.RelatedDoc rd JOIN smdo.SmdoDocs sd ON rd.DocId = sd.DocId
 WHERE rd.RelatedDocId=gsd.DocId)  
end RelatedDocName
FROM smdo.GetSmdoDocs gsd
LEFT JOIN smdo.ReceivedDocDetails rdd ON gsd.DocId = rdd.DocId
LEFT JOIN smdo.DtsSigners ds ON gsd.DocId = ds.DocId
WHERE gsd.DocId=@docId


END

