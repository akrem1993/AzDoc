
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE   PROCEDURE [orgrequests].[spGetDocs1] @workPlaceId        INT, 
                                             @periodId           INT           = NULL, 
                                             @docTypeId          INT, 
                                             @pageIndex          INT           = 1, 
                                             @pageSize           INT           = 20, 
                                             @totalCount         INT OUT,
                                             ---for searching

                                             @docenterno         NVARCHAR(50)  = NULL, 
                                             @docdocno           NVARCHAR(50)  = NULL, 
                                             @docenterdate       DATETIME      = NULL, 
											 @docdate       DATETIME      = NULL, 
                                             @docdocumentstatusid NVARCHAR(MAX) = NULL,
										     @docTopicTypeId     nvarchar(MAX) = NULL,
										     @docformid nvarchar(max)=NULL,
										     @formid nvarchar(max)=NULL,
										     @taskto NVARCHAR(MAX) = NULL,
										     @docauthorinfo NVARCHAR(MAX) = NULL,
										     @signer NVARCHAR(MAX) = NULL,
										     @docdescription NVARCHAR(MAX) = NULL,
										     @whomadressed NVARCHAR(MAX) = NULL,
										     @createrpersonnelname nvarchar(max)=null

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


DECLARE @sql nvarchar(max)

IF EXISTS(SELECT vr.OperationId FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=1) 
BEGIN

SET @sql='SELECT 
        d.DocId , 
        d.DirectionInsertedDate , 
        d.ExecutorReadStatus
        FROM orgrequests.OrgRequestsDocs d
        WHERE 1=1 
        and (d.ExecutorWorkplaceId =@workPlaceId  OR d.ExecutorOrganizationId=@DepartmentOrganization)
        AND d.DocPeriodId = @periodId'

if(len(@docenterno)>0) SET @sql=@sql+' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
if(len(@docdocno)>0) SET @sql=@sql+' and d.DocDocno LIKE N''%'+@docdocno+'%''';
if(@docenterdate IS NOT null) SET @sql=@sql+' and d.DocEnterdate =@docenterdate';
if(@docdate IS NOT null) SET @sql=@sql+' and d.DocDate=@docdate';--Resid
if(len(@docdocumentstatusid)>0) SET @sql=@sql+' and d.DocDocumentstatusId in (select [value] from string_split('''+@docdocumentstatusid+''','',''))';
if(len(@docTopicTypeId)>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docTopicTypeId+''','',''))';
if(len(@docformid )>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docformid+''','',''))';
if(len(@formid )>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
if(len(@docauthorinfo )>0) SET @sql=@sql+' and d.DocAuthorInfo LIKE N''%'+@docauthorinfo+'%''';
if(len(@signer)>0) SET @sql=@sql+' and d.Signer LIKE N''%'+@signer+'%'' ';
if(len(@docdescription)>0) SET @sql=@sql+' and d.DocDescription LIKE N''%'+@docdescription+'%''';
if(len(@whomadressed )>0) SET @sql=@sql+' and d.WhomAdressed LIKE N''%'+@whomadressed+'%''';
if(len(@createrpersonnelname )>0) SET @sql=@sql+' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docenterdate datetime,@docdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docenterdate,@docdate


--    SELECT 
--        d.DocId , 
--        d.DirectionInsertedDate , 
--        d.ExecutorReadStatus
--    FROM orgrequests.OrgRequestsDocs d
--    WHERE
--        --d.DocOrganizationId=@DepartmentOrganization
--        (d.ExecutorWorkplaceId = @workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
--        AND d.DocPeriodId = @periodId
----filter
--        AND ((@docenterno IS NULL  OR d.DocEnterno LIKE '%' +@docenterno + '%')
--        AND (@docdocno IS NULL  OR d.DocDocno LIKE '%' + @docdocno + '%')
--        AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
--        AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
--        AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
--        AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--        AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))
--	    --AND (@taskto IS NULL OR (case when @taskto is not null then d.TaskTo else '' end LIKE '%'+ @taskto + '%'))
--		AND (@docauthorinfo IS NULL OR d.DocAuthorInfo LIKE '%'+ @docauthorinfo + '%')
--	    AND (@signer IS NULL OR d.Signer LIKE '%'+ @signer + '%')
--		AND (@docdescription IS NULL OR d.DocDescription LIKE '%'+ @docdescription + '%')
--		AND (@whomadressed IS NULL OR d.WhomAdressed LIKE '%'+ @whomadressed + '%')
--		)

return;
end;

SET @sql='SELECT 
        d.DocId , 
        d.DirectionInsertedDate , 
        d.ExecutorReadStatus
        FROM orgrequests.OrgRequestsDocs d
        WHERE 1=1 
        and (d.ExecutorWorkplaceId =@workPlaceId)
        AND d.DocPeriodId = @periodId'

if(len(@docenterno)>0) SET @sql=@sql+' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
if(len(@docdocno)>0) SET @sql=@sql+' and d.DocDocno LIKE N''%'+@docdocno+'%''';
if(@docenterdate IS NOT null) SET @sql=@sql+' and d.DocEnterdate =@docenterdate';
if(@docdate IS NOT null) SET @sql=@sql+' and d.DocDate=@docdate';--Resid
if(len(@docdocumentstatusid)>0) SET @sql=@sql+' and d.DocDocumentstatusId in (select [value] from string_split('''+@docdocumentstatusid+''','',''))';
if(len(@docTopicTypeId)>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docTopicTypeId+''','',''))';
if(len(@docformid )>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docformid+''','',''))';
if(len(@formid )>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
if(len(@docauthorinfo )>0) SET @sql=@sql+' and d.DocAuthorInfo LIKE N''%'+@docauthorinfo+'%''';
if(len(@signer)>0) SET @sql=@sql+' and d.Signer LIKE N''%'+@signer+'%'' ';
if(len(@docdescription)>0) SET @sql=@sql+' and d.DocDescription LIKE N''%'+@docdescription+'%''';
if(len(@whomadressed )>0) SET @sql=@sql+' and d.WhomAdressed LIKE N''%'+@whomadressed+'%''';
if(len(@createrpersonnelname )>0) SET @sql=@sql+' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docenterdate datetime,@docdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docenterdate,@docdate

--    SELECT 
--        d.DocId , 
--        d.DirectionInsertedDate, 
--        d.ExecutorReadStatus
--    FROM orgrequests.OrgRequestsDocs d
--    WHERE
--        d.ExecutorWorkplaceId = @workPlaceId
--        AND d.DocPeriodId = @periodId
----filter
--        AND ((@docenterno IS NULL  OR d.DocEnterno LIKE '%' +@docenterno + '%')
--        AND (@docdocno IS NULL  OR d.DocDocno LIKE '%' + @docdocno + '%')
--        AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
--        AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
--        AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
--        AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--        AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))
--		--AND (@taskto IS NULL OR (case when @taskto is not null then d.TaskTo else '' end LIKE '%'+ @taskto + '%'))
--		AND (@docauthorinfo IS NULL OR d.DocAuthorInfo LIKE '%'+ @docauthorinfo + '%')
--		AND (@signer IS NULL OR d.Signer LIKE '%'+ @signer + '%')
--		AND (@docdescription IS NULL OR d.DocDescription LIKE '%'+ @docdescription + '%')
--		AND (@whomadressed IS NULL OR d.WhomAdressed LIKE '%'+ @whomadressed + '%')
--		)

END;

