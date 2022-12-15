/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  Rufin Ahmadov
-- Create date: 01.08.2019
-- Description: Imzalanmis fayllar haqqinda melumatlari yadda saxlayir
-- =============================================
CREATE PROCEDURE [dbo].[AddSignedFilesInfo] @docId           INT, 
                                           @workPlaceId     INT, 
                                           @userId          INT, 
                                           @signatureTypeId INT, 
                                           @eDocFilePath    NVARCHAR(MAX), 
                                           @signatureNote   NVARCHAR(MAX)=NULL, 
                                           @result          INT OUT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @fileInfoId INT, 
    @fileId INT, 
    @personnelId INT;

        SELECT @fileId = df.FileId, 
               @fileInfoId = df.FileInfoId
        FROM dbo.DOCS_FILE df
        WHERE df.FileDocId = @docId
              AND df.FileIsMain = 1
              AND df.IsDeleted = 0;

        SELECT @personnelId = du.UserPersonnelId
        FROM dbo.DC_USER du
        WHERE du.UserId = @userId;

  INSERT INTO dbo.DOCS_FILESIGN
  (
   FileInfoId, 
   SignatureDate, 
   SignatureWorkplaceId, 
   SignaturePersonnelId, 
   SignatureTypeId, 
   EdocPath, 
   FileId, 
   SignatureNote
  )
  VALUES
  (
   @fileInfoId, -- FileInfoId - int
   dbo.SYSDATETIME(), -- SignatureDate - datetime
   @workPlaceId, -- SignatureWorkplaceId - int
   @personnelId, -- SignaturePersonnelId - int
   @signatureTypeId, -- SignatureTypeId - int
   @eDocFilePath, -- EdocPath - nvarchar
   @fileId, -- FileId - int
   @signatureNote -- SignatureNote - nvarchar
  );

        SET @result = 1;
    END;

