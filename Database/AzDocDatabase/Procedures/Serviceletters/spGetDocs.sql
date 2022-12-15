/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/


/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spGetDocs] @workPlaceId INT, 
                                             @periodId    INT = NULL, 
                                             @docTypeId   INT, 
                                             @pageIndex   INT = 1, 
                                             @pageSize    INT = 20, 
                                             @totalCount  INT OUT,
											  ---for searching
                                          @docenterno         NVARCHAR(50)  = NULL, 
                                          @docdocno           NVARCHAR(50)  = NULL, 
                                          @docenterdate       DATETIME      = NULL, 
                                          @docdocumentstatusid NVARCHAR(MAX) = NULL
AS
DECLARE @DocType int=18
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

IF EXISTS(SELECT vr.* FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=18) 
BEGIN 
	 SELECT 
doc.*
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND d.DocOrganizationId=@DepartmentOrganization
    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
    --filter=>
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL  OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,','))))
) AS allDocs
OUTER APPLY
(SELECT 
 top(1) d.*
 FROM 
 serviceletters.ServiceLettersDocs d
 where
 d.DocId=allDocs.DocId) AS doc
ORDER BY 
doc.DirectionInsertedDate DESC,
doc.ExecutorReadStatus asc
OFFSET @pageSize * (@pageIndex - 1)
ROWS FETCH NEXT @pageSize ROWS ONLY;


SELECT @totalCount = COUNT(allDocs.DocId)
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND d.DocOrganizationId=@DepartmentOrganization
    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
    --filter=>
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL  OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,','))))
) AS allDocs


return;
END

SELECT 
doc.*
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND d.ExecutorWorkplaceId =@workPlaceId
    --filter=>
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL  OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,','))))
) AS allDocs
OUTER APPLY
(SELECT 
 top(1) d.*
 FROM 
 serviceletters.ServiceLettersDocs d
 where
 d.DocId=allDocs.DocId) AS doc
ORDER BY 
doc.DirectionInsertedDate DESC,
doc.ExecutorReadStatus asc
OFFSET @pageSize * (@pageIndex - 1)
ROWS FETCH NEXT @pageSize ROWS ONLY;

SELECT @totalCount = COUNT(allDocs.DocId)
FROM 
(   SELECT 
    DISTINCT d.DocId 
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND d.ExecutorWorkplaceId =@workPlaceId
    --filter=>
    AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
    AND (@docenterdate IS NULL  OR d.DocEnterdate = @docenterdate)
    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,','))))
) AS allDocs

END;

