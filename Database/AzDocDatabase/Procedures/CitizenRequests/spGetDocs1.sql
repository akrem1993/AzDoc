-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 30.09.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [citizenrequests].[spGetDocs1]  @workPlaceId INT, 
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
										                      @formid nvarchar(max)=NULL,
									    @taskto NVARCHAR(MAX) = NULL,
										@citizeninfo NVARCHAR(MAX) = NULL,
										@signer NVARCHAR(MAX) = NULL,
										@docdescription NVARCHAR(MAX) = NULL,
										@whomadressed NVARCHAR(MAX) = NULL,
										@appaddress NVARCHAR(MAX) = NULL,
										@docauthorinfo NVARCHAR(MAX) = NULL,
										@createrpersonnelname nvarchar(max)=null
								
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


DECLARE @sql nvarchar(max)
IF EXISTS(SELECT vr.OperationId FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=2) 
BEGIN
SET @sql='SELECT 
        d.DocId , 
        d.DirectionInsertedDate , 
        d.ExecutorReadStatus
        FROM citizenrequests.CitizenRequestsDocs d
        WHERE 1=1 
        and (d.ExecutorWorkplaceId =@workPlaceId  OR d.ExecutorOrganizationId=@DepartmentOrganization)
        AND d.DocPeriodId = @periodId'

		if(len(@docenterno)>0) SET @sql=@sql+' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
		if(len(@docdocno)>0) SET @sql=@sql+' and d.DocDocno LIKE N''%'+@docdocno+'%''';
		if(@docenterdate IS NOT null) SET @sql=@sql+' and d.DocEnterdate =@docenterdate';
		if(len(@docdocumentstatusid)>0) SET @sql=@sql+' and d.DocDocumentstatusId in (select [value] from string_split('''+@docdocumentstatusid+''','',''))';
		if(len(@docTopicTypeId)>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docTopicTypeId+''','',''))';
		if(len(@docformid )>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docformid+''','',''))';
		if(len(@formid )>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
		if(len(@citizeninfo )>0) SET @sql=@sql+' and d.CitizenInfo LIKE N''%'+@citizeninfo+'%''';		
		if(len(@signer)>0) SET @sql=@sql+' and d.Signer LIKE N''%'+@signer+'%'' ';
		if(len(@docdescription)>0) SET @sql=@sql+' and d.DocDescription LIKE N''%'+@docdescription+'%''';		
		if(len(@whomadressed )>0) SET @sql=@sql+' and d.WhomAdressed LIKE N''%'+@whomadressed+'%''';
		if(len(@appaddress)>0) SET @sql=@sql+' and d.AppAddress LIKE N''%'+@appaddress+'%'' ';
		if(len(@docauthorinfo)>0) SET @sql=@sql+' and d.DocAuthorInfo LIKE N''%'+@docauthorinfo+'%'' ';
		if(len(@createrpersonnelname )>0) SET @sql=@sql+' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

		EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docenterdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docenterdate

--SELECT 
--     d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
--FROM 
--    citizenrequests.CitizenRequestsDocs d
--where
--    --d.DocOrganizationId=@DepartmentOrganization
--    (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
--    AND d.DocPeriodId = @periodId
--    --filter
--    AND ((@docenterno IS NULL OR d.DocEnterno LIKE N'%'+ @docenterno + '%')
--    AND (@docdocno IS NULL OR d.DocDocno LIKE N'%'+ @docdocno + '%')
--    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
--    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
--    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
--    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,',')))
--	 --   AND (@taskto IS NULL OR d.TaskTo LIKE '%'+ @taskto + '%')
--		AND (@citizeninfo IS NULL OR d.CitizenInfo LIKE N'%'+ @citizeninfo + '%')
--		AND (@signer IS NULL OR d.Signer LIKE N'%'+ @signer + '%')
--		AND (@docdescription IS NULL OR d.DocDescription LIKE N'%'+ @docdescription + '%')
--		AND (@whomadressed IS NULL OR d.WhomAdressed LIKE N'%'+ @whomadressed + '%')
--		AND (@appaddress IS NULL OR d.AppAddress LIKE '%'+ @appaddress + '%')
--		AND (@docauthorinfo IS NULL OR d.DocAuthorInfo LIKE N'%'+ @docauthorinfo + '%')
--		AND (@createrpersonnelname IS NULL OR d.CreaterPersonnelName LIKE '%'+ @createrpersonnelname + '%')
		
--		)
		
return;
end;
SET @sql='SELECT 
        d.DocId , 
        d.DirectionInsertedDate , 
        d.ExecutorReadStatus
        FROM citizenrequests.CitizenRequestsDocs d
        WHERE 1=1 
        and (d.ExecutorWorkplaceId =@workPlaceId)
        AND d.DocPeriodId = @periodId'

		if(len(@docenterno)>0) SET @sql=@sql+' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
		if(len(@docdocno)>0) SET @sql=@sql+' and d.DocDocno LIKE N''%'+@docdocno+'%''';
		if(@docenterdate IS NOT null) SET @sql=@sql+' and d.DocEnterdate =@docenterdate';
		if(len(@docdocumentstatusid)>0) SET @sql=@sql+' and d.DocDocumentstatusId in (select [value] from string_split('''+@docdocumentstatusid+''','',''))';
		if(len(@docTopicTypeId)>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docTopicTypeId+''','',''))';
		if(len(@docformid )>0) SET @sql=@sql+' and d.DocTopicType in (select [value] from string_split('''+@docformid+''','',''))';
		if(len(@formid )>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
		if(len(@citizeninfo )>0) SET @sql=@sql+' and d.CitizenInfo LIKE N''%'+@citizeninfo+'%''';		
		if(len(@signer)>0) SET @sql=@sql+' and d.Signer LIKE N''%'+@signer+'%'' ';
		if(len(@docdescription)>0) SET @sql=@sql+' and d.DocDescription LIKE N''%'+@docdescription+'%''';		
		if(len(@whomadressed )>0) SET @sql=@sql+' and d.WhomAdressed LIKE N''%'+@whomadressed+'%''';
		if(len(@appaddress)>0) SET @sql=@sql+' and d.AppAddress LIKE N''%'+@appaddress+'%'' ';
		if(len(@docauthorinfo)>0) SET @sql=@sql+' and d.DocAuthorInfo LIKE N''%'+@docauthorinfo+'%'' ';
		if(len(@createrpersonnelname )>0) SET @sql=@sql+' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

		EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docenterdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docenterdate

--SELECT 
--    d.DocId,d.DirectionInsertedDate,d.ExecutorReadStatus
--FROM 
--    citizenrequests.CitizenRequestsDocs d
--where
--    d.ExecutorWorkplaceId =@workPlaceId
--    AND d.DocPeriodId = @periodId
----filter
--    AND ((@docenterno IS NULL OR d.DocEnterno LIKE N'%'+ @docenterno + '%')
--    AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
--    AND (@docenterdate IS NULL OR d.DocEnterdate = @docenterdate)
--    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
--    AND (@docTopicTypeId IS NULL or d.DocTopicType in (select [value] from string_split(@docTopicTypeId,',')))
--    AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--    AND (@formid IS NULL or d.DocForm in (select [value] from string_split(@formid,',')))
--	 --AND (@taskto IS NULL OR d.TaskTo LIKE '%'+ @taskto + '%')
--		AND (@citizeninfo IS NULL OR d.CitizenInfo LIKE N'%'+ @citizeninfo + '%')
--		AND (@signer IS NULL OR d.Signer LIKE '%'+ @signer + '%')
--		AND (@docdescription IS NULL OR d.DocDescription LIKE N'%'+ @docdescription + '%')
--		AND (@whomadressed IS NULL OR d.WhomAdressed LIKE N'%'+ @whomadressed + '%')
--		AND (@appaddress IS NULL OR d.AppAddress LIKE '%'+ @appaddress + '%')
--		AND (@docauthorinfo IS NULL OR d.DocAuthorInfo LIKE N'%'+ @docauthorinfo + '%')
--		AND (@createrpersonnelname IS NULL OR d.CreaterPersonnelName LIKE N'%'+ @createrpersonnelname + '%')

--		)



END

