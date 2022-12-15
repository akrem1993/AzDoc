/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spDeleteDoc]
@docId int, 
@result int OUTPUT

WITH EXEC AS CALLER
AS
--DELETE FROM dbo.DOCS 
--WHERE DocId = @docId;
set @result=1

