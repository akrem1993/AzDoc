-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 25.02.2019
-- Description: WorkplaceId;ye gore komekci olub olmamagini teyin edir
-- =============================================
CREATE FUNCTION  [dbo].[fnIsPersonnHelperByWorkPlace] 
(
@workPlaceId int
)
RETURNS bit
AS
BEGIN
 DECLARE @Result bit;
 select @Result= CAST(count(Id) as bit)  from DC_WORKPLACE_ROLE r  where r.RoleId=236 and r.WorkplaceId=@workPlaceId;
 
 RETURN @Result;
END

