/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddFileInfo]
@fileInfoCapacity bigint, 
@fileInfoExtention varchar(5), 
@fileInfoGuId nvarchar(60), 
@fileInfoInsertdate datetime, 
@fileInfoName nvarchar(300), 
@fileInfoPath nvarchar(200), 
@fileInfoVersion tinyint, 
@fileInfoWorkplaceId int, 
@fileInfoId int OUTPUT,
@result int OUTPUT

WITH EXEC AS CALLER
AS
INSERT INTO dbo.DOCS_FILEINFO
(
      FileInfoWorkplaceId, 
      FileInfoParentId, 
      FileInfoVersion, 
      FileInfoType, 
      FileInfoCapacity, 
      FileInfoExtention, 
      FileInfoInsertdate, 
      FileInfoPath, 
      FileInfoName, 
      FileInfoGuId, 
      FileInfoStatus, 
      FileInfoBinary, 
      FileInfoContent, 
      FileInfoAttachmentCount, 
      FileInfoCopiesCount, 
      FileInfoPageCount) 
VALUES (@fileInfoWorkplaceId, NULL, @fileInfoVersion, NULL, @fileInfoCapacity, @fileInfoExtention, @fileInfoInsertdate, @fileInfoPath, @fileInfoName, @fileInfoGuId, NULL, NULL, NULL, NULL, NULL, NULL)
set @fileInfoId = SCOPE_IDENTITY();
INSERT dbo.debugTable
(
    --id - column value is auto-generated
    [text]
)
VALUES
(
    -- id - int
    N'file added'-- insertDate - datetime
)
 
set @result=1;

