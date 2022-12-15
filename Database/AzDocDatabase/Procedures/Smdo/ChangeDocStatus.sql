-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 07.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [smdo].[ChangeDocStatus]
@docId int,
@status tinyint
AS
BEGIN
UPDATE smdo.smdodocs SET smdo.smdodocs.DocStatus=@status WHERE smdo.smdodocs.DocId=@docid

END

