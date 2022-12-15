-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[SetDvcBase64]
@docId int,
@dvcBase64 nvarchar(max)
AS
BEGIN

UPDATE smdo.receiveddocdetails SET DvcBase64=@dvcBase64 WHERE smdo.receiveddocdetails.DocId=@docId

END

