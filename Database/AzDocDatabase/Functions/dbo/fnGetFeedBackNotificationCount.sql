-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 01.03.2019
-- Description: <Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFeedBackNotificationCount]
(
@workPlaceId int
)
RETURNS int
AS
BEGIN
 DECLARE @result int,@userIsHelper bit;
 select @userIsHelper=[dbo].[fnIsPersonnHelperByWorkPlace](@workPlaceId);

 -- Add the T-SQL statements to compute the return value here
 SELECT @result=count(*) from DC_REQUEST_TEST where RequestStatus=case when @userIsHelper=1 then 3 else 5 end;

 RETURN @result;

END

