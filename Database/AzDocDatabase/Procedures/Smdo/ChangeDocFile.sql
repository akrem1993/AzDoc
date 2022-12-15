-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[ChangeDocFile]
@docGuid nvarchar(max),
@fileName nvarchar(max)
AS
BEGIN

UPDATE smdo.smdodocs SET smdo.smdodocs.DocFilePath=@fileName WHERE smdo.smdodocs.DocMsgGuid=@docGuid

END

