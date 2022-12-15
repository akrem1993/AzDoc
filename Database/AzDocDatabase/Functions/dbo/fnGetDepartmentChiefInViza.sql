-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 04.04.2019
-- Description: Senede baglanan vizalarda shobe mudurunun workPlaceni tapir tapir
-- =============================================
CREATE FUNCTION [dbo].[fnGetDepartmentChiefInViza]
(
@docId int
)
RETURNS int
AS
BEGIN
 declare @result int;

 select @result= w.WorkplaceId from DC_WORKPLACE w 
 join DOCS d on w.WorkplaceId=d.DocInsertedById
 join DC_DEPARTMENT_POSITION dp on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
 where 
 d.DocId=@docId
 and dp.PositionGroupId=17;

 if @result is null
 begin
   declare @departmentTopId int,@docWorkPlaceId int,@departmentId int;

   select @docWorkPlaceId=d.DocInsertedById from DOCS d where d.DocId=@docId;
   select @departmentId=w.WorkplaceDepartmentId from DC_WORKPLACE w where w.WorkplaceId=@docWorkPlaceId;
   
   select @result=w.WorkplaceId from 
   DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId
   where  
   dp.PositionGroupId=17 
   and dp.DepartmentId=@departmentId;

   if @result is null
   begin
    select @departmentTopId=d.DepartmentTopId 
    from 
    DC_DEPARTMENT d join DC_WORKPLACE w on w.WorkplaceDepartmentId=d.DepartmentId 
    where w.WorkplaceId=@docWorkPlaceId;

    select @result= w.WorkplaceId 
    from DC_WORKPLACE w 
    join DC_DEPARTMENT_POSITION dp on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
    join DC_DEPARTMENT d on w.WorkplaceDepartmentId=d.DepartmentId
    where 
    d.DepartmentId=@departmentTopId
    and dp.PositionGroupId=17;
   end;
 end

 --select @result=w.WorkplaceId from DC_WORKPLACE w 
 --join DOCS_VIZA v on w.WorkplaceId=v.VizaWorkPlaceId
 --join DC_DEPARTMENT_POSITION dp on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
 --where 
 --v.VizaDocId=@docId
 --and dp.PositionGroupId=17;


 RETURN @result;

END

