/*
Migrated by Kamran A-eff 23.08.2019
*/

CREATE   PROCEDURE [outgoingdoc].[spGetDocs1]
@workPlaceId int,
@periodId int=null,
@docTypeId int,
@pageIndex int=1,
@pageSize int=20,
@totalCount int out,
 ---for searching
                                          @docenterno         NVARCHAR(50)  = NULL, 
                                          @docdocno           NVARCHAR(50)  = NULL,
										   @docdate       DATETIME      = NULL,  
                                         -- @docenterdate       DATETIME      = NULL, 
                                          @documentstatusname NVARCHAR(MAX) = NULL,										  
										  @docformid nvarchar(max)=NULL,
										  @formid nvarchar(max)=NULL,		
										  @whomadressedcompany  NVARCHAR(MAX) = NULL,
										  @whomadressed  NVARCHAR(MAX) = NULL,
										  @docdescription  NVARCHAR(MAX) = NULL,
										  @signer  NVARCHAR(MAX) = NULL,
										  @createrpersonnelname nvarchar(max)=null

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

DECLARE @sql nvarchar(max);

IF EXISTS(SELECT top(1) 0 FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=12) 
BEGIN

SET @sql=' SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
    FROM 
    outgoingdoc.OutgoingDocs d
    where
      (d.ExecutorWorkplaceId=@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
   and d.DocPeriodId=@periodId ';

	if(len(@docenterno)>0) SET @sql+=' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
	if(len(@docdocno)>0) SET @sql+=' and d.DocDocno LIKE N''%'+@docdocno+'%'' ';
	if(@docdate IS NOT null) SET @sql+=' and d.DocEnterdate = ' + @docdate +'';
	if(len(@docformid)>0) SET @sql=@sql+' and d.DocReceivedFormId in (select [value] from string_split('''+@docformid+''','',''))';
	if(len(@formid)>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
	if(len(@whomadressedcompany)>0) SET @sql+=' and d.WhomAdressedCompany = ' + @whomadressedcompany+'';
	if(len(@whomadressed)>0) SET @sql+=' and d.WhomAdressed LIKE N''%'+@whomadressed+'%'' ';
	if(len(@documentstatusname)>0) SET @sql=@sql+' and d.DocDocumentstatusName in (select [value] from string_split('''+@documentstatusname+''','',''))';
	if(len(@signer)>0) SET @sql+=' and d.Signer LIKE N''%'+@signer+'%'' ';	
	if(len(@docdescription)>0) SET @sql+=' and d.DocDescription LIKE N''%'+@docdescription+'%'' ';
	if(len(@createrpersonnelname)>0) SET @sql+=' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

	EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docdate



--   SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
--   FROM outgoingdoc.OutgoingDocs d 
--   WHERE 
--   --d.DocOrganizationId=@DepartmentOrganization
--   (d.ExecutorWorkplaceId=@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
--   and d.DocPeriodId=@periodId
----filter
--   AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
--   AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
--   AND (@docdate IS NULL OR d.DocEnterdate = @docdate)
--	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))
--	  AND (@whomadressedcompany IS NULL OR d.WhomAdressedCompany LIKE '%'+ @whomadressedcompany + '%')
--	   AND (@whomadressed IS NULL OR d.WhomAdressed LIKE '%'+ @whomadressed + '%')
--	    AND (@docdescription IS NULL OR d.DocDescription LIKE '%'+ @docdescription + '%')
--	    AND (@documentstatusname IS NULL OR d.DocumentstatusName LIKE @documentstatusname + N'%')
--		 AND (@signer IS NULL OR d.Signer LIKE '%'+ @signer + '%')
--		 AND (@createrpersonnelname IS NULL OR d.CreaterPersonnelName LIKE '%'+ @createrpersonnelname + '%')
		-- ) 
	   
return;
END;
SET @sql=' SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
    FROM 
    outgoingdoc.OutgoingDocs d
    where
    d.DocPeriodId = @periodId
    AND d.ExecutorWorkplaceId =@workPlaceId ';

	if(len(@docenterno)>0) SET @sql+=' and d.DocEnterno LIKE N''%'+@docenterno+'%'' ';
	if(len(@docdocno)>0) SET @sql+=' and d.DocDocno LIKE N''%'+@docdocno+'%'' ';
	if(@docdate IS NOT null) SET @sql+=' and d.DocEnterdate = ' + @docdate +'';
	if(len(@docformid)>0) SET @sql=@sql+' and d.DocReceivedFormId in (select [value] from string_split('''+@docformid+''','',''))';
	if(len(@formid)>0) SET @sql=@sql+' and d.DocFormId in (select [value] from string_split('''+@formid+''','',''))';
	if(len(@whomadressedcompany)>0) SET @sql+=' and d.WhomAdressedCompany = ' + @whomadressedcompany+'';
	if(len(@whomadressed)>0) SET @sql+=' and d.WhomAdressed LIKE N''%'+@whomadressed+'%''';
	if(len(@documentstatusname)>0) SET @sql=@sql+' and d.DocDocumentstatusName in (select [value] from string_split('''+@documentstatusname+''','',''))';
	if(len(@signer)>0) SET @sql+=' and d.Signer LIKE N''%'+@signer+'%'' ';	
	if(len(@docdescription)>0) SET @sql+=' and d.DocDescription LIKE N''%'+@docdescription+'%'' ';
	if(len(@createrpersonnelname)>0) SET @sql+=' and d.CreaterPersonnelName LIKE N''%'+@createrpersonnelname+'%''';

	EXEC sp_executesql @sql,N'@workplaceId int,@periodId int,@DepartmentOrganization int,@docdate datetime',@workplaceId,@periodid,@DepartmentOrganization,@docdate

--   SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
--   FROM outgoingdoc.OutgoingDocs d 
--   WHERE 
--   d.ExecutorWorkplaceId=@workPlaceId 
--   and d.DocPeriodId=@periodId
----filter
--   AND ((@docenterno IS NULL OR d.DocEnterno LIKE '%'+ @docenterno + '%')
--   AND (@docdocno IS NULL OR d.DocDocno LIKE '%'+ @docdocno + '%')
--   AND (@docdate IS NULL OR d.DocEnterdate = @docdate)
--	 AND (@docformid IS NULL or d.DocReceivedFormId in (select [value] from string_split(@docformid,',')))
--	 AND (@formid IS NULL or d.DocFormId in (select [value] from string_split(@formid,',')))
--	 AND (@whomadressedcompany IS NULL OR d.WhomAdressedCompany LIKE '%'+ @whomadressedcompany + '%')
--	   AND (@whomadressed IS NULL OR d.WhomAdressed LIKE '%'+ @whomadressed + '%')
--	    AND (@docdescription IS NULL OR d.DocDescription LIKE '%'+ @docdescription + '%')
--	    AND (@documentstatusname IS NULL OR d.DocumentstatusName LIKE @documentstatusname + N'%')
--		 AND (@signer IS NULL OR d.Signer LIKE '%'+ @signer + '%')
--		 AND (@createrpersonnelname IS NULL OR d.CreaterPersonnelName LIKE '%'+ @createrpersonnelname + '%')

--		) 
end

