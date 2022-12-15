-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [smdo].[GetDtsChecks]
@docId int
AS
BEGIN
	
SELECT dc.Id, 
       dc.DocId, 
       dc.CheckName AS name, 
       dc.CheckStatus AS status, 
       CASE when dc.Indicator=1 THEN '+' ELSE '-' end AS indicator, 
       dc.CheckDescription AS description
FROM smdo.DtsChecks dc
WHERE dc.DocId = @docId ORDER BY dc.Id;

END

