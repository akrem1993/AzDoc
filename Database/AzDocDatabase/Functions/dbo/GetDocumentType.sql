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
-- Author:  Musayev Nurlan
-- Create date: 29.06.2019
-- Description: senedin novunu getirir
-- =============================================
CREATE FUNCTION [dbo].[GetDocumentType] 
(
@docId int
)
RETURNS int
AS
BEGIN
DECLARE @result int;

  SELECT @result=d.DocDoctypeId FROM dbo.DOCS d WHERE d.DocId=@docId;      

 RETURN @result;

END

