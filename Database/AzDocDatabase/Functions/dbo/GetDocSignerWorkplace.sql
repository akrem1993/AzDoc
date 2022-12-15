-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 27.09.2019
-- Description:	Senedin imza eden shexsi tapmaq
-- =============================================
CREATE FUNCTION [dbo].[GetDocSignerWorkplace]
(
	@docId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @res int;

SELECT @res=da.AdrPersonId 
FROM dbo.DOCS_ADDRESSINFO da 
WHERE da.AdrDocId=@docId AND da.AdrTypeId=1

IF @res IS NULL SET @res=-1;--THROW 56000,'Func:Sənədin imza edən şəxsi yoxdu',1;

	-- Return the result of the function
RETURN @res;

END

