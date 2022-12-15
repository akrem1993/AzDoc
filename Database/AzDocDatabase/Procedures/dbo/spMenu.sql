/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  Kamran A-eff
-- Create date: 2019-22-01
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spMenu]
 @userId int,
 @kind bit=0 /*0: for menu
               1: for permission*/
AS
BEGIN

;with permissionByUserId as (
--user esasli permission
 select MenuId,Show,[Add],[Edit],[Remove],[FullControl] 
 from AC_PERMISSION with(nolock) where UserId=@userId
),
permissionByGroupId as (
--group esasli permission
select MenuId,NULLIF(Show,-1) Show,NULLIF([Add],-1) [Add],NULLIF([Edit],-1) [Edit],NULLIF([Remove],-1) [Remove] ,NULLIF([FullControl],-1) [FullControl] 
from (
 select MenuId,min(case when Show IS NULL then -1 else Show end) Show,min(case when [Add] IS NULL then -1 else [Add] end) [Add],min(case when [Edit] IS NULL then -1 else [Edit] end) [Edit]
 ,min(case when [Remove] IS NULL then -1 else [Remove] end) [Remove],min(case when [FullControl] IS NULL then -1 else [FullControl] end) [FullControl]
 from AC_PERMISSION p with(nolock) 
 join [dbo].[AC_UserGroupCollection] g on p.GroupId=g.GroupId
 where g.UserId=@userId
 group by MenuId
)d
),
complexPermission as (
select 
isnull(u.MenuId,g.MenuId) MenuId
,case when u.Show=0 then 0 --user uzre icaze mehdudlasdirilib
when u.Show=1 or g.Show=1 then 1 --user ve ya qrup uzre icaze verilib
when g.Show=0 then 0 --grup uzre icaze mehdudlasdirilib
else null end Show
,case when u.[Add]=0 then 0 when u.[Add]=1 or g.[Add]=1 then 1 when g.[Add]=0 then 0 else null end [Add]
,case when u.[Edit]=0 then 0 when u.[Edit]=1 or g.[Edit]=1 then 1 when g.[Edit]=0 then 0 else null end [Edit]
,case when u.[Remove]=0 then 0 when u.[Remove]=1 or g.[Remove]=1 then 1 when g.[Remove]=0 then 0 else null end [Remove]
,case when u.[FullControl]=0 then 0 when u.[FullControl]=1 or g.[FullControl]=1 then 1 when g.[FullControl]=0 then 0 else null end [FullControl]
from permissionByUserId u
full outer join permissionByGroupId g on u.MenuId=g.MenuId
),
permittedMenu as (
   select Id,ParentId,0 [Level],ForAllUser ,Show,[Add],[Edit],[Remove],[FullControl]
   from [dbo].[AC_Menu] m  with(nolock)
   left join complexPermission t on t.MenuId=m.Id
   where (@kind=0 and Show=1/*( or m.ActionName is null)*/) or @kind=1--m.ActionName IS NOT NULL  
)
,cteMenu as (
   select Id,ParentId,0 [Level]    
   from permittedMenu  
   union all   
   select m.Id,m.ParentId, cm.[Level] +1 [Level]
   from cteMenu cm
   join [dbo].[AC_Menu] m with(nolock) on m.Id=cm.ParentId and m.ActionName IS  NULL
)

,
summary as (select distinct 
 m.[Id]
,m.[ParentId]
,m.[IconClass]
,m.[Caption]
,ct.[Name] ControllerName
,m.[ActionName]
,DocTypeId RequestUrl
--,FORMATMESSAGE('/{0}/Documents/%i?t=%i',isnull(DocTypeId,-1),1) RequestUrl
--,m.[ForAllUser]
,cast(case when isnull(p.ForAllUser,0)=1 and isnull(Show,1)!=0 then 1 else  isnull(Show,0) end as bit)     [Show] 
,cast(isnull([Add],0) as bit)    [Add] 
,cast(isnull([Edit],0) as bit)   [Edit] 
,cast(isnull([Remove],0) as bit) [Remove] 
,cast(isnull([FullControl],0) as bit) [FullControl] 
,OrderNo
from cteMenu c
join [dbo].[AC_Menu] m with(nolock) on c.Id=m.Id
left join permittedMenu p on  m.Id=p.Id
left join [dbo].[AC_CONTROLLER] ct with(nolock) on m.ControllerId=ct.Id)
select * from summary
order by ISNULL(OrderNo,0) desc
--where (@kind=0 and (c.show=1 or m.ActionName is null)) or @kind=1

END

