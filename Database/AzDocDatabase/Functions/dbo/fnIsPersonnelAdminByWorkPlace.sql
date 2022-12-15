-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 06.02.2019
-- Description: WorkplaceId;ye gore admin olub olmamagini teyin edir
-- =============================================
CREATE FUNCTION [dbo].[fnIsPersonnelAdminByWorkPlace] 
(
@workPlaceId int
)
RETURNS bit
AS
BEGIN
 DECLARE @Result bit;
 select @Result= CAST(count(Id) as bit)  from DC_WORKPLACE_ROLE r  where r.RoleId=230 and r.WorkplaceId=@workPlaceId;
 
 RETURN @Result;
END

