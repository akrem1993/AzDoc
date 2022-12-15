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
-- Create date: 06.03.2019
-- Description: Fayli esas sened fayli kimi teyin edir
-- =============================================
CREATE PROCEDURE [dbo].[spSetFileAsMain]
@fileInfoId int,
@result int output
AS
declare @fileDocId int,@fileId int;
BEGIN
  select @fileDocId=FileDocId,@fileId=FileId from DOCS_FILE 
              where 
              FileId=(select f.FileId from DOCS_FILE f where f.FileInfoId= @fileInfoId);

  if @fileDocId is not null
  begin
 declare @viewDocFile TABLE(FileId int);

 Insert into @viewDocFile(FileId) 
 select v.FileId from VW_DOC_FILES v 
 where 
 v.FileDocId=@fileDocId 
 and v.FileId<>@fileId;

 Update DOCS_FILE 
 set FileIsMain=0 
 where 
 FileId in (select v.FileId from @viewDocFile v);
   
 declare @viewDocVizas TABLE(VizaId int);

 INSERT into @viewDocVizas(VizaId) 
 select v.VizaId from DOCS_VIZA v 
 where 
 v.VizaFileId in (select FileId from @viewDocFile) 
 and v.VizaAgreementTypeId=1 
 and v.IsDeleted=0;

 Update DOCS_VIZA 
 set VizaFileId=@fileId 
 where 
 VizaId in (select VizaId from @viewDocVizas);


 Update DOCS_FILE 
 set FileIsMain=1 
 where 
 FileId=@fileId;

 set @result=1;
  end;

END

