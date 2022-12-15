/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/


/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE  	 PROCEDURE [serviceletters].[spGetDocs1] @workPlaceId INT, 
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
										  @signer NVARCHAR(50)  = NULL, 
										  @sendto NVARCHAR(50)  = NULL, 
										  @docdescription NVARCHAR(50)  = NULL,
										  @createrpersonnelname nvarchar(max)=null

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

DECLARE @sql nvarchar(max);

IF EXISTS(SELECT vr.* FROM VW_ROLES vr WHERE vr.WorkplaceId=@workPlaceId AND vr.RightTypeId=1 AND vr.RightId=32 AND vr.OperationParameter=18) 
BEGIN 
  
SET @sql=' SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)';


if(len(@docenterno)>0) SET @sql+=' and d.DocEnterno LIKE N''%''+@docenterno+''%'' ';
if(len(@docdocno)>0) SET @sql+=' and d.DocDocno LIKE N''%''+@docdocno+''%'' ';
if(@docenterdate IS NOT null) SET @sql+=' and d.DocEnterdate = @docenterdate';
if(len(@docdocumentstatusid)>0) SET @sql+=' and d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,'',''))';
if(len(@signer)>0) SET @sql+=' and d.Signer LIKE N''%''+@signer+''%'' ';
if(len(@sendto)>0) SET @sql+=' and d.SendTo LIKE N''%''+@sendto+''%'' ';
if(len(@docdescription)>0) SET @sql+=' and d.DocDescription LIKE N''%''+@docdescription+''%'' ';
if(len(@createrpersonnelname)>0) SET @sql+=' and d.CreaterPersonnelName LIKE N''%''+@createrpersonnelname+''%'' ';

EXEC sp_executesql @sql,N'@workplaceId int,
@periodId int,
@DepartmentOrganization int,
@docenterdate datetime,
@docdocno nvarchar(50),
@docenterno nvarchar(50),
@docdocumentstatusid nvarchar(max),
@signer nvarchar(50),
@sendto nvarchar(50),
@docdescription nvarchar(50),
@createrpersonnelname nvarchar(max)',
@workplaceId,
@periodid,
@DepartmentOrganization,
@docenterdate,
@docdocno,
@docenterno,
@docdocumentstatusid,
@signer,
@sendto,
@docdescription,
@createrpersonnelname


--return;


--  SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
--    FROM 
--    serviceletters.ServiceLettersDocs d
--    where
--    d.DocPeriodId = @periodId
--    AND (d.ExecutorWorkplaceId =@workPlaceId OR d.ExecutorOrganizationId=@DepartmentOrganization)
--    --filter=>
--    AND ((@docenterno IS NULL OR d.DocEnterno LIKE N'%'+ @docenterno + '%')
--    AND (@docdocno IS NULL OR d.DocDocno LIKE N'%'+ @docdocno + '%')
--    AND (@docenterdate IS NULL  OR d.DocEnterdate = @docenterdate)
--    AND (@docdocumentstatusid IS NULL or d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,',')))
--	AND (@signer IS NULL OR d.Signer LIKE N'%'+ @signer + '%')
--	AND (@sendto IS NULL OR d.SendTo LIKE N'%'+ @sendto + '%')
--	AND (@docdescription IS NULL OR d.DocDescription LIKE N'%'+ @docdescription + '%')
--	AND (@createrpersonnelname IS NULL OR d.CreaterPersonnelName LIKE N'%'+ @createrpersonnelname + '%')
--	)

return;
END

SET @sql=' SELECT d.DocId ,d.DirectionInsertedDate,d.ExecutorReadStatus
    FROM 
    serviceletters.ServiceLettersDocs d
    where
    d.DocPeriodId = @periodId
    AND d.ExecutorWorkplaceId =@workPlaceId';


if(len(@docenterno)>0) SET @sql+=' and d.DocEnterno LIKE N''%''+@docenterno+''%'' ';
if(len(@docdocno)>0) SET @sql+=' and d.DocDocno LIKE N''%''+@docdocno+''%'' ';
if(@docenterdate IS NOT null) SET @sql+=' and d.DocEnterdate = @docenterdate';
if(len(@docdocumentstatusid)>0) SET @sql+=' and d.DocDocumentstatusId in (select [value] from string_split(@docdocumentstatusid,'',''))';
if(len(@signer)>0) SET @sql+=' and d.Signer LIKE N''%''+@signer+''%'' ';
if(len(@sendto)>0) SET @sql+=' and d.SendTo LIKE N''%''+@sendto+''%'' ';
if(len(@docdescription)>0) SET @sql+=' and d.DocDescription LIKE N''%''+@docdescription+''%'' ';
if(len(@createrpersonnelname)>0) SET @sql+=' and d.CreaterPersonnelName LIKE N''%''+@createrpersonnelname+''%'' ';

EXEC sp_executesql @sql,N'@workplaceId int,
@periodId int,
@DepartmentOrganization int,
@docenterdate datetime,
@docdocno nvarchar(50),
@docenterno nvarchar(50),
@docdocumentstatusid nvarchar(max),
@signer nvarchar(50),
@sendto nvarchar(50),
@docdescription nvarchar(50),
@createrpersonnelname nvarchar(max)',
@workplaceId,
@periodid,
@DepartmentOrganization,
@docenterdate,
@docdocno,
@docenterno,
@docdocumentstatusid,
@signer,
@sendto,
@docdescription,
@createrpersonnelname


END;

