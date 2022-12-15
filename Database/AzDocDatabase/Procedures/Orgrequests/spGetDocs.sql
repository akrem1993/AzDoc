
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [orgrequests].[spGetDocs] @workPlaceId        INT, 
                                          @periodId           INT           = NULL, 
                                          @docTypeId          INT, 
                                          @pageIndex          INT           = 1, 
                                          @pageSize           INT           = 20, 
                                          @totalCount         INT OUT,
                                          ---for searching
                                          @docenterno         NVARCHAR(50)  = NULL, 
                                          @docdocno           NVARCHAR(50)  = NULL, 
                                          @docenterdate       DATETIME      = NULL, 
                                          @docdocumentstatusid NVARCHAR(MAX) = NULL,
										  @docTopicTypeId     nvarchar(MAX) = NULL,
										  @docformid nvarchar(max)=NULL,
										  @formid nvarchar(max)=NULL
AS
BEGIN
   IF(@periodId IS NULL)  SELECT @periodId = MAX(p.PeriodId) FROM DOC_PERIOD p;

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


IF EXISTS(SELECT top(1) 0 FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=1) 
BEGIN
SELECT 
doc.* 
FROM
(
    SELECT 
    DISTINCT d.DocId 
    FROM orgrequests.OrgRequestsDocs d
    WHERE
    d.DocOrganizationId=@DepartmentOrganization
    AND (d.ExecutorWorkplaceId = @workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
    AND d.DocPeriodId = @periodId
--filter
    AND ((@docenterno IS NULL  OR d.DocEnterno LIKE N'%' +@docenterno + '%')
    AND (@docdocno IS NULL  OR d.DocDocno LIKE N'%' + @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))
) AS allDocs
OUTER APPLY
(
    SELECT top(1) ord.* 
    FROM orgrequests.OrgRequestsDocs ord
    WHERE allDocs.DocId=ord.DocId
) AS doc
ORDER BY 
doc.DirectionInsertedDate DESC, 
doc.ExecutorReadStatus
OFFSET @pageSize * (@pageIndex - 1) 
ROWS FETCH NEXT @pageSize ROWS ONLY;


SELECT 
@totalCount = COUNT(DISTINCT d.DocId)
FROM 
orgrequests.OrgRequestsDocs d
WHERE
d.DocOrganizationId=@DepartmentOrganization
AND (d.ExecutorWorkplaceId = @workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
AND d.DocPeriodId = @periodId
--filter
AND ((@docenterno IS NULL  OR d.DocEnterno LIKE N'%' +@docenterno + '%')
AND (@docdocno IS NULL  OR d.DocDocno LIKE N'%' + @docdocno + '%')
AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))


return;
end;



SELECT 
doc.* 
FROM
(
    SELECT 
    DISTINCT d.DocId 
    FROM orgrequests.OrgRequestsDocs d
    WHERE
    d.ExecutorWorkplaceId = @workPlaceId
    AND d.DocPeriodId = @periodId
--filter
    AND ((@docenterno IS NULL  OR d.DocEnterno LIKE N'%' +@docenterno + '%')
    AND (@docdocno IS NULL  OR d.DocDocno LIKE N'%' + @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))
) AS allDocs
OUTER APPLY
(
    SELECT top(1) ord.* 
    FROM orgrequests.OrgRequestsDocs ord
    WHERE allDocs.DocId=ord.DocId
) AS doc
ORDER BY 
doc.DirectionInsertedDate DESC, 
doc.ExecutorReadStatus
OFFSET @pageSize * (@pageIndex - 1) 
ROWS FETCH NEXT @pageSize ROWS ONLY;


SELECT 
@totalCount = COUNT(d.DocId)
FROM 
orgrequests.OrgRequestsDocs d
WHERE
d.ExecutorWorkplaceId = @workPlaceId
AND d.DocPeriodId = @periodId
--filter
AND ((@docenterno IS NULL  OR d.DocEnterno LIKE N'%' + @docenterno + '%')
AND (@docdocno IS NULL  OR d.DocDocno LIKE N'%' +@docdocno + '%')
AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,','))))

END;

