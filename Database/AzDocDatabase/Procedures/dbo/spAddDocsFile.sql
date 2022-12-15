/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddDocsFile]
@isReject bit, 
@isDeleted bit, 
@fileDocId int, 
@fileIsMain bit,
@fileInfoId int, 
@fileVisaStatus tinyint, 
@signatureStatusId tinyint, 
@fileCurrentVisaGroup tinyint, 
@parentId int,
@result int OUTPUT

WITH EXEC AS CALLER
AS
begin try
  declare @newFileId int;


INSERT INTO dbo.DOCS_FILE
(
  FileDocId, 
  FileInfoId, 
  [FileName], 
  FileVisaStatus, 
  SignatureStatusId, 
  FileCurrentVisaGroup, 
  FileIsMain, 
  SignatureNote, 
  IsDeleted, 
  IsReject, 
  SignatureWorkplaceId, 
  SignatureDate) 
VALUES (@fileDocId, @fileInfoId, NULL, @fileVisaStatus, @signatureStatusId, @fileCurrentVisaGroup, @fileIsMain, NULL, @isDeleted, @isReject, NULL, NULL)
set @newFileId = scope_identity();

if(@parentId<>-1)
BEGIN

  exec dbo.spChangeOldViza
            @fileInfoId=@parentId,
            @newFileId=@newFileId,
            @docId=@fileDocId;
end
else
begin  

  declare @Viza table(VizaId int  null);
      
  insert into @Viza
  select top(1) v.VizaId
  from DOCS_VIZA v 
  where v.VizaDocId = @fileDocId and v.VizaAgreementTypeId=2
  order by v.VizaId;
  
  if exists(select * from @Viza)
  begin
    update docs_viza SET   
      VizaFileId = @newFileId -- int
    WHERE VizaId = (select VizaId from @Viza) -- int
  end;
end;

set @result=1
end try
begin catch
  insert into debugTable(text)
  values(error_message());
end catch;

