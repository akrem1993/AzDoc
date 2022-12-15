CREATE PROCEDURE [smdo].[AddDocSubject]
@docId int,
@subject nvarchar(max)=null
AS
BEGIN

UPDATE smdo.SmdoDocs
SET
    smdo.SmdoDocs.DocSubject = @subject,smdo.smdodocs.DocDescription=@subject WHERE smdo.SmdoDocs.DocId=@docId -- nvarchar

END

