/*
Migrated by Kamran A-eff 23.08.2019
*/


/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spGetDocs] @workPlaceId INT, 
                                              @periodId    INT = NULL, 
                                              @docTypeId   INT, 
                                              @pageIndex   INT = 1, 
                                              @pageSize    INT = 20, 
                                              @totalCount  INT OUT,
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
        IF(@periodId IS NULL) SELECT @periodId = MAX(p.PeriodId) FROM DOC_PERIOD p;

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



IF EXISTS(SELECT vr.* FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=2) 
BEGIN

SELECT 
doc.*
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    citizenrequests.CitizenRequestsDocs d
    where
    d.DocOrganizationId=@DepartmentOrganization
    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
    AND d.DocPeriodId = @periodId
    --filter
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,','))))
) AS allDocs
OUTER APPLY
(SELECT 
 top(1) d.*
 FROM 
 citizenrequests.CitizenRequestsDocs d
 where
 d.DocId=allDocs.DocId) AS doc
 ORDER BY 
 doc.DirectionInsertedDate DESC,
 doc.ExecutorReadStatus asc
 OFFSET @pageSize * (@pageIndex - 1)
 ROWS FETCH NEXT @pageSize ROWS ONLY;


SELECT 
@totalCount=count(allDocs.DocId)
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    citizenrequests.CitizenRequestsDocs d
    where
    d.DocOrganizationId=@DepartmentOrganization
    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
    AND d.DocPeriodId = @periodId
    --filter
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,','))))
) AS allDocs

return;
end;

SELECT 
doc.*
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    citizenrequests.CitizenRequestsDocs d
    where
    d.ExecutorWorkplaceId =@workPlaceId
    AND d.DocPeriodId = @periodId
    --filter
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,','))))
) AS allDocs
OUTER APPLY
(SELECT 
 top(1) d.*
 FROM 
 citizenrequests.CitizenRequestsDocs d
 where
 d.DocId=allDocs.DocId) AS doc
 ORDER BY 
 doc.DirectionInsertedDate DESC,
 doc.ExecutorReadStatus asc
 OFFSET @pageSize * (@pageIndex - 1)
 ROWS FETCH NEXT @pageSize ROWS ONLY;


SELECT 
@totalCount = COUNT(allDocs.DocId)
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    citizenrequests.CitizenRequestsDocs d
    where
    d.ExecutorWorkplaceId =@workPlaceId
    AND d.DocPeriodId = @periodId
    --filter
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,','))))
) AS allDocs


END;

