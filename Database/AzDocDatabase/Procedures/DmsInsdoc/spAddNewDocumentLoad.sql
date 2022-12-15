/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spAddNewDocumentLoad]
@docType int=null,
@workPlaceId int=0,
@formTypeId int=0,
@docId int=null
as
begin
 set nocount on;
 if(@docId is null)
 begin
  if(@formTypeId=0)
  begin
  Declare @orgId int;
  select @orgId=(select [dbo].[fnPropertyByWorkPlaceId](@workPlaceId,12));

   --TypeOfDocument
   select 1 FormTypeId,f.FormId Id,f.FormName Name from DOC_FORM f 
   where f.FormId in ( select t.FormId from dbo.DOC_FORM_DOCTYPE t 
        where t.DocTypeId=@docType and t.FormDocTypeStatus=1)
   and f.FormStatus=1
  union
  SELECT 2 FormTypeId,df.FormId AS Id,df.FormName AS Name FROM dbo.DOC_FORM df WHERE df.FormId BETWEEN 62 AND 69
  union --SignatoryPerson
    SELECT 3 FormTypeId, WP.WorkplaceId AS Id,
     ISNULL(' ' + PE.PersonnelName, '') +     
     ISNULL(' ' + PE.PersonnelSurname, '')+                 
     ISNULL(' ' + PE.PersonnelLastname, '')+               
     ISNULL(' ' + DO.DepartmentPositionName, '') AS Name   
     FROM [dbo].DC_WORKPLACE WP INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId=DU.UserId       
       INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId        
       INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId        
       INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId        
       WHERE PE.PersonnelStatus=1 and  
        ( WP.WorkplaceId IN (select  WR.WorkplaceId from [dbo].DC_WORKPLACE_ROLE WR where 
                     WR.RoleId=240 and WP.WorkplaceOrganizationId=@orgId) or
                     (WP.WorkplaceId IN (23,430,458,431)))   
  union --ConfirmingPerson  
    SELECT 4 FormTypeId, WP.WorkplaceId AS Id,       
     ISNULL(' ' + PE.PersonnelName, '')+             
     ISNULL(' ' + PE.PersonnelSurname, '')+                   
     ISNULL(' ' + PE.PersonnelLastname, '')+                      
     ISNULL(' ' + DO.DepartmentPositionName, '')
     --+ISNULL(' ' +  REPLACE(DP.DepartmentName, N'Rəhbərlik', ' ') , '') 
     AS NAME                         
     FROM DC_WORKPLACE WP INNER JOIN DC_USER DU ON WP.WorkplaceUserId=DU.UserId             
    INNER JOIN DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId             
    INNER JOIN DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId             
    INNER JOIN DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId              
    INNER JOIN DC_WORKPLACE_ROLE DR ON WP.WorkplaceId=DR.WorkplaceId      
    INNER JOIN DC_ORGANIZATION ORG ON WP.WorkplaceOrganizationId=ORG.OrganizationId    
    WHERE  (WP.WorkplaceOrganizationId=@orgId or
       Exists(select * from DC_ORGANIZATION where OrganizationId=@orgId AND WP.WorkplaceOrganizationId=OrganizationTopId) )   
    AND PE.PersonnelStatus=1   
    AND DR.RoleId=240 
    AND DO.PositionGroupId IN (1,2,33,37,38,5,6)
  union --TypeOfAssignment 
    select 6 FormTypeId,s.SendStatusId Id,s.SendStatusName Name from DOC_SENDSTATUS s inner join dbo.DOC_SENDSTATUS_TYPE st 
     on s.SendStatusId=st.SendStatusId 
     where st.DocTypeId=@docType and s.SendStatusStatus=1 and st.SendTypeStatus=1 AND s.SendStatusId NOT in(13)  ---Resid deyisdi 
  
  union --TaskCycle
     select 7 FormTypeId, c.TaskCycleId Id,c.TaskCycleName Name from dbo.DOC_TASK_CYCLE c 
    where c.TaskCycleStatus=1 and c.DocTypeId=@docType
 
  union --WhomAddressed
    SELECT 8 FormTypeId, WP.WorkplaceId AS Id,
     ISNULL(' ' + PE.PersonnelName, '') +     
     ISNULL(' ' + PE.PersonnelSurname, '')+                 
     ISNULL(' ' + PE.PersonnelLastname, '')+               
     ISNULL(' ' + DO.DepartmentPositionName, '') AS Name   
     FROM [dbo].DC_WORKPLACE WP INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId=DU.UserId       
       INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId        
       INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId        
       INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId        
       WHERE PE.PersonnelStatus=1 and  
        (WP.WorkplaceId IN (select  WR.WorkplaceId from [dbo].DC_WORKPLACE_ROLE WR where 
                     WR.RoleId=240 ) or
                     (WP.WorkplaceId IN ((select WP.WorkplaceId from DC_WORKPLACE WP
       where WP.WorkplaceDepartmentPositionId in (select dp.DepartmentPositionId from DC_DEPARTMENT_POSITION dp 
       where dp.PositionGroupId in (1,2,3,33,5,6,7,8,9,10,11,13,14,15,17,18,19)) and WP.WorkplaceOrganizationId=@orgId )))) 
  end
  else if(@formTypeId=5) --RelatedDocument
  begin
   select * from (select d.DocId,d.DocEnterno,
   ( CONCAT(da.AppFirstname,space(1), da.AppSurname,space(1),da.AppLastname) + ' '  + (select [dbo].[fnGetApplicantAddress](da.AppDocId) )) DocumentInfo
   from dbo.DOCS d inner join dbo.DOCS_APPLICATION da on d.DocId=da.AppDocId) sub  where sub.DocumentInfo is not null
  end
 end
 else if(@docId is not null)
 begin
  if(@formTypeId=1)
  begin
   select d.DocId,
     d.DocFormId as TypeOfDocumentId ,
    (select a.AdrPersonId from DOCS_ADDRESSINFO a where a.AdrDocId=@docId and a.AdrTypeId=1) as SignatoryPersonId,
    (select a.AdrPersonId from DOCS_ADDRESSINFO a where a.AdrDocId=@docId and a.AdrTypeId=2) as ConfirmingPersonId,
    d.DocDescription as ShortContent  from dbo.DOCS d where d.DocId=@docId
  end
  else if(@formTypeId=2)
  begin
    SELECT t.TaskId, 
    (SELECT  s.SendStatusName FROM dbo.DOC_SENDSTATUS s where s.SendStatusId=t.TypeOfAssignmentId) TypeOfAssignment, 
    t.TaskNo, t.TaskDecription Task, t.TaskCycleId TaskCycle, t.ExecutionPeriod, t.PeriodOfPerformance, t.OriginalExecutionDate,
     (SELECT  
     ISNULL(' ' + PE.PersonnelName, '') +     
     ISNULL(' ' + PE.PersonnelSurname, '')+                 
     ISNULL(' ' + PE.PersonnelLastname, '')+               
     ISNULL(' ' + DO.DepartmentPositionName, '')+               
     ISNULL(' ' + DP.DepartmentName, '')   
     FROM [dbo].DC_WORKPLACE WP INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId=DU.UserId       
       INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId        
       INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId        
       INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId        
       WHERE PE.PersonnelStatus=1  and WP.WorkplaceId=t.WhomAddressId) WhomAddress
   FROM dbo.DOC_TASK t where  t.TaskDocId=@docId;
  end
    
    else if(@formTypeId=3)
  begin
   --select r.RelatedId DocId,
   --           d.DocEnterno,
   --  ( CONCAT(da.AppFirstname,space(1), da.AppSurname,space(1),da.AppLastname) + ' '  + (select [dbo].[fnGetApplicantAddress](da.AppDocId) )) DocumentInfo
   --    from dbo.DOCS d inner join dbo.DOCS_APPLICATION da on d.DocId=da.AppDocId 
   --        inner join dbo.DOCS_RELATED r on da.AppDocId=r.RelatedDocumentId where r.RelatedDocId = @docId;

                                        SELECT d.DocId, 
                                               d.DocEnterno, 
                                               d.DocEnterdate,
                                               CASE
                                                   WHEN d.DocDoctypeId = 1
                                                        OR d.DocDoctypeId = 2
                                                   THEN(
                                        (
                                            SELECT STUFF(
                                            (
                                                SELECT ' ' + OrganizationName
                                                FROM DC_ORGANIZATION o
                                                WHERE o.OrganizationId IN
                                                (
                                                    SELECT af.AdrOrganizationId
                                                    FROM DOCS_ADDRESSINFO af
                                                    WHERE af.AdrDocId = d.DocId
                                                          AND af.AdrTypeId = 3
                                                          AND af.AdrAuthorId IS NOT NULL
                                                ) FOR XML PATH('')
                                            ), 1, 1, '')
                                        ) + ' , ' +
                                        (
                                            SELECT STUFF(
                                            (
                                                SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
                                                FROM dbo.DOC_AUTHOR a
                                                WHERE a.AuthorId IN
                                                (
                                                    SELECT af.AdrAuthorId
                                                    FROM DOCS_ADDRESSINFO af
                                                    WHERE af.AdrDocId = d.DocId
                                                          AND af.AdrTypeId = 3
                                                          AND af.AdrAuthorId IS NOT NULL
                                                ) FOR XML PATH('')
                                            ), 1, 0, '')
                                        ))
                                                   WHEN d.DocDoctypeId = 18
                                                   THEN
                                        (
                                            SELECT af.FullName
                                            FROM dbo.DOCS_ADDRESSINFO af
                                            WHERE af.AdrDocId = r.RelatedDocumentId
                                                  AND af.AdrTypeId = 1
                                        )
                                               END AS DocumentInfo, 
                                               d.DocDescription
                                        FROM dbo.DOCS d
                                             LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
                                             LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                        WHERE r.RelatedDocId = @docId
                                              AND r.RelatedTypeId = 1;
                                     

  end
  
 end
end

