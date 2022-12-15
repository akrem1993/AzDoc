CREATE FUNCTION [dbo].[fnGetRegion](@RegionId int)
RETURNS NVARCHAR(250)
AS
BEGIN
 DECLARE @Result NVARCHAR(250)='';

 SELECT @Result = RegionName 
 FROM dbo.DC_REGION
 WHERE RegionId = @RegionId;
 
 RETURN  @Result;
END

