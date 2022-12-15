/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spChangeFileInfo]
@fileInfoCapacity bigint=0, 
@fileInfoExtention varchar(10), 
@fileInfoGuId nvarchar(max), 
@fileInfoInsertdate datetime, 
@fileInfoName nvarchar(500), 
@fileInfoPath nvarchar(max), 
@fileInfoVersion tinyint, 
@fileInfoWorkplaceId int, 
@fileInfoParentId int, 
@fileInfoAttachmentCount int=NULL,
@fileInfoCopiesCount int=NULL, 
@fileInfoPageCount int=NULL, 
@fileInfoId int output,
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
VALUES (@fileInfoWorkplaceId, @fileInfoParentId, @fileInfoVersion, NULL, @fileInfoCapacity, @fileInfoExtention, @fileInfoInsertdate, @fileInfoPath, @fileInfoName, @fileInfoGuId, NULL, NULL, NULL, @fileInfoAttachmentCount, @fileInfoCopiesCount, @fileInfoPageCount)
set @fileInfoId = Scope_identity();
set @result=1

