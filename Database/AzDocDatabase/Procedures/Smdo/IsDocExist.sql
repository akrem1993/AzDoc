-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[IsDocExist]
@guid nvarchar(max)
AS
BEGIN

IF  EXISTS (SELECT sd.DocId FROM smdo.SmdoDocs sd WHERE sd.DocMsgGuid=@guid)
SELECT Cast(1 AS nvarchar(5))
ELSE
SELECT CAST(0 AS  nvarchar(5))

END

