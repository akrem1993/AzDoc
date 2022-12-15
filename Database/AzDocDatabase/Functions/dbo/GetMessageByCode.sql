/*
Migrated by Kamran A-eff 07.09.2019
*/

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
-- Author:  Ibrahimov Resid
-- Create date: 23.05.2019
-- Description: daxil edilən koda uyğun olaraq messajın getirilməsi
-- =============================================
CREATE FUNCTION [dbo].[GetMessageByCode](@code int)
RETURNS Nvarchar(Max)
AS
BEGIN  
DECLARE @message Nvarchar(Max);

  select 
  @message=m.MessageAz 
  from dbo.DC_Messages m 
   where 
   m.Id=@code and m.IsDeleted=0;

   RETURN @message
END

