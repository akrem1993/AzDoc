/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spFileInfoUpdate] 
@page int, 
@copy int,
@fileInfoId int,
@result int OUTPUT

WITH EXEC AS CALLER
AS
UPDATE dbo.DOCS_FILEINFO
SET 
FileInfoPageCount = @page , 
FileInfoCopiesCount = @copy
WHERE FileInfoId = @fileInfoId;

set @result=1;

