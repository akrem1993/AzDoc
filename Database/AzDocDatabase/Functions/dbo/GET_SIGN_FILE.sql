create FUNCTION [dbo].[GET_SIGN_FILE](@executorId int ) returns  int
as 
BEGIN
DECLARE @docId int
DECLARE @workplaceId int
DECLARE @executor_order int
DECLARE @fileId int

SELECT @docId=ExecutorDocId, @workplaceId=ExecutorWorkplaceId FROM DOCS_EXECUTOR WHERE ExecutorId=@executorId

Select @executor_order=t1.rn
From 
(
     select ExecutorId , row_number() over (order by ExecutorId) rn
     from DOCS_EXECUTOR e
  left join DOCS_DIRECTIONS d on d.DirectionId=e.ExecutorDirectionId
  WHERE ExecutorDocId=@docId AND ExecutorWorkplaceId=@workplaceId AND e.DirectionTypeId=8 and (d.DirectionConfirmed=1 OR d.DirectionConfirmed=2) 
 
) t1
Where t1.ExecutorId = @executorId

--SELECT @fileId= t2.FileId
--FROM 
--(
-- select FileId  , row_number() over (order by FileId) rn
-- FROM DOCS_FILE 
-- WHERE FileDocId = @docId AND SignatureWorkplaceId=@workplaceId
--) t2
--Where t2.rn = @executor_order


SELECT @fileId= t2.FileId
FROM 
(
 select f.FileId  , row_number() over (order by f.FileId) rn
 FROM DOCS_FILE f
  left join DOCS_FILESIGN fs on fs.FileId=f.FileId and (fs.SignatureTypeId=20 OR fs.SignatureTypeId=21)
 WHERE FileDocId = @docId AND (fs.SignatureWorkplaceId=@workplaceId OR f.SignatureWorkplaceId=@workplaceId)
) t2
Where t2.rn = @executor_order

 

--IF (@file_status IS NULL) SELECT @file_status_name = NULL
--ELSE IF (@file_status = 1) SELECT @file_status_name = N'İmzadadır'
--ELSE IF (@file_status = 2) SELECT @file_status_name = N'İmzalanıb'
--ELSE IF (@file_status = 3)  SELECT @file_status_name= N'İmtina edilib' 

RETURN @fileId
END
