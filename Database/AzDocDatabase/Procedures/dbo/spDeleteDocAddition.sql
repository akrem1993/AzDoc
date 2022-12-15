/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spDeleteDocAddition]
@docId int, 
@result int OUTPUT

WITH EXEC AS CALLER
AS
DELETE FROM dbo.DOCS_ADDITION 
WHERE  DocumentId = @docId;
set @result=1;

