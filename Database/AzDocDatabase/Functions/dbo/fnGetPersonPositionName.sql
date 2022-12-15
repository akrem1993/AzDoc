-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 27.02.2019
-- Description: Workplace nomresine gore islediyi vezifeni almaq
-- =============================================
CREATE FUNCTION [dbo].[fnGetPersonPositionName]
(
@workPlaceId int
)
RETURNS nvarchar(max)
AS
BEGIN
 Declare @result nvarchar(max);
 SELECT @result=p.DepartmentPositionName 
 FROM dbo.DC_DEPARTMENT_POSITION p join  
 DC_WORKPLACE w on p.DepartmentPositionId=w.WorkplaceDepartmentPositionId 
 where w.WorkplaceId=@workPlaceId

 RETURN @result;

END

