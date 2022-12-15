/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spGetDocs]
@workPlaceId int,
@periodId int=null,
@docTypeId int,
@pageIndex int=1,
@pageSize int=20,
@totalCount int out,
 ---for searching
                                          @docenterno         NVARCHAR(50)  = NULL, 
                                          @docdocno           NVARCHAR(50)  = NULL, 
                                          @docenterdate       DATETIME      = NULL, 
                                          @documentstatusname NVARCHAR(MAX) = NULL,
										  
										  @docformid nvarchar(max)=NULL,
										  @formid nvarchar(max)=NULL
as
begin
if(@periodId is null) select @periodId= (select max(p.PeriodId) from DOC_PERIOD p)
--1 İmzalayan şəxs
--2 Kimə ünvanlanıb
--3 Təşkilat məlumatları


declare
@DepartmentOrganization int= null,
@DepartmentTopDepartmentId int= null,
@DepartmentId int,
@DepartmentSectionId int= null,
@DepartmentSubSectionId int= null;


select    
@DepartmentOrganization=DepartmentOrganization,
@DepartmentTopDepartmentId=d.DepartmentTopDepartmentId,
@DepartmentId=d.DepartmentId,
@DepartmentSectionId=d.DepartmentSectionId,
@DepartmentSubSectionId=d.DepartmentSubSectionId
from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
where w.WorkplaceId= @workPlaceId


IF EXISTS(SELECT vr.* FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=12) 
BEGIN
SELECT doc.* FROM
(
   SELECT DISTINCT d.DocId 
   FROM outgoingdoc.OutgoingDocs d 
   WHERE 
   d.DocOrganizationId=@DepartmentOrganization
   and (d.ExecutorWorkplaceId=@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
   and d.DocPeriodId=@periodId
--filter
   AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
   AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
   AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))) 
) AS allDocs
OUTER APPLY
(
  SELECT top(1) od.* 
  FROM 
  outgoingdoc.OutgoingDocs od
  WHERE od.DocId=allDocs.DocId
) AS doc
ORDER BY doc.DirectionInsertedDate DESC, 
doc.ExecutorReadStatus 
OFFSET @pageSize * (@pageIndex-1) Rows
FETCH NEXT @pageSize ROWS ONLY 




   SELECT  @totalCount=count(d.DocId) 
   FROM outgoingdoc.OutgoingDocs d 
   WHERE  
   d.DocOrganizationId=@DepartmentOrganization
   and (d.ExecutorWorkplaceId=@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
   and d.DocPeriodId=@periodId
--filter
   AND ((@docenterno IS NULL OR d.DocEnterno  LIKE '%'+ @docenterno + '%')
   AND (@docdocno IS NULL OR d.DocDocno  LIKE '%'+ @docdocno + '%')
   AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))


return;
END;


SELECT doc.* FROM
(
   SELECT DISTINCT d.DocId 
   FROM outgoingdoc.OutgoingDocs d 
   WHERE 
   d.ExecutorWorkplaceId=@workPlaceId 
   and d.DocPeriodId=@periodId
--filter
   AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
   AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
   AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))) 
) AS allDocs
OUTER APPLY
(
  SELECT top(1) od.* 
  FROM 
  outgoingdoc.OutgoingDocs od
  WHERE od.DocId=allDocs.DocId
) AS doc
ORDER BY doc.DirectionInsertedDate DESC, 
doc.ExecutorReadStatus 
OFFSET @pageSize * (@pageIndex-1) Rows
FETCH NEXT @pageSize ROWS ONLY 




   SELECT  @totalCount=count(d.DocId) 
   FROM outgoingdoc.OutgoingDocs d 
   WHERE  
   d.ExecutorWorkplaceId=@workPlaceId 
   and d.DocPeriodId=@periodId
--filter
   AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
   AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
   AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))
end

