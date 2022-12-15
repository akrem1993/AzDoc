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
-- Create date: 20.02.2019
-- Description: Feedback ucun file elave edilmesi
-- =============================================
CREATE PROCEDURE [dbo].[spAddFeedBackFile] 
@messageId int,
@fileGuid nvarchar(max),
@fileWorkPlace int,
@fileInfoCapacity BIGINT,
@fileInfoName nvarchar(max),
@fileExtension nvarchar(10),
@fileInfoPath nvarchar(max)
AS
declare 
@date datetime=dbo.sysdatetime(),
@fileId int
BEGIN
 Insert into [dbo].[DOCS_FILEINFO](FileInfoGuId,
        FileInfoWorkplaceId,
        FileInfoCapacity,
        FileInfoName,
        FileInfoExtention,
        FileInfoInsertdate,
        FileInfoVersion,
        FileInfoPath)
      values(@fileGuid,
        @fileWorkPlace,
        @fileInfoCapacity,
        @fileInfoName,
        @fileExtension,
        @date,
        1,
        @fileInfoPath);
      select @fileId=SCOPE_IDENTITY();
    
 Insert into [dbo].[DC_REQUESTFILES_TEST](FileId,MessageId,InsertDate,Type,Status)
       values(@fileId,@messageId,@date,1,1);

       
END;

