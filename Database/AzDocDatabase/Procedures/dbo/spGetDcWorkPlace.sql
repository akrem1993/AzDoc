/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDcWorkPlace]
@workPlaceUserId int=null,
@result int output
as
set NOCOUNT on;
    if exists(select * from dbo.DC_WORKPLACE w where w.WorkplaceUserId=@workPlaceUserId)
      begin
          select w.*,(o.OrganizationName + ' ' + d.DepartmentName + ' ' + dp.DepartmentPositionName + '; ' + p.PersonnelName + ' ' + p.PersonnelSurname) WorkplaceName 
            from 
            dbo.DC_WORKPLACE w  inner join dbo.DC_ORGANIZATION o on w.WorkplaceOrganizationId=o.OrganizationId
            inner join DC_DEPARTMENT d on w.WorkplaceDepartmentId=d.DepartmentId
            inner join DC_DEPARTMENT_POSITION dp on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId
            inner join dbo.DC_USER u on w.WorkplaceUserId=u.UserId
            inner join dbo.DC_PERSONNEL p on u.UserPersonnelId=p.PersonnelId
            where w.WorkplaceUserId=@workPlaceUserId;
         
          set @result=1;
      end
      else
      begin
         set @result=-1;
      end

