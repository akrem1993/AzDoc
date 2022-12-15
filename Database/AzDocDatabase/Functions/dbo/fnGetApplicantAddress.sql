CREATE FUNCTION [dbo].[fnGetApplicantAddress](@docId int) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
 DECLARE @result nvarchar(MAX)

 DECLARE @Address nvarchar(MAX)
 DECLARE @Region nvarchar(MAX)

 SELECT TOP 1 @Address = da.AppAddress1,  @Region = dbo.fnGetRegion(da.AppRegion1Id)
 FROM DOCS_APPLICATION  da
 WHERE AppDocId=@docId AND ISNULL(AppRepresenterId,1)=1

 SELECT @result = @Address

 RETURN @result
END

