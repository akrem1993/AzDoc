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
-- Author:   Musayev Nurlan
-- Create date:  07.03.2019
-- Description:  Senedin faylini silmek
-- =============================================
CREATE PROCEDURE [dbo].[spDeleteDocFile]
@fileInfoId int,
@result int output
AS
declare @fileInfoParentId int,@fileId int
BEGIN
    
 select @fileId=f.FileInfoId,@fileInfoParentId=f.FileInfoParentId from DOCS_FILEINFO f where FileInfoId=@fileInfoId;

 if (@fileId is not null)
 begin 
  declare @docId int,@docTypeId int
  declare @viewFilesId table (FileId int)
  declare @NonRejectedFiled table (FileId int)
  declare @viewDocVizas TABLE(VizaId int);
  declare @viewDocDirections TABLE(DirectionId int);

  select @docId=f.FileDocId from DOCS_FILE f where FileInfoId=@fileId;
  --select @docTypeId=DocDoctypeId from DOCS where --is joined with docs_file
  --if docAuthorization(can edit) set @result=1;

  Insert into @viewFilesId(FileId) values (@fileId);
   while (@fileInfoParentId) is not null
   begin
    Insert into @viewFilesId(FileId) values (@fileInfoParentId);
    select @fileInfoParentId= f.FileInfoParentId from DOCS_FILEINFO f where f.FileInfoId=@fileInfoParentId;
   end;

  Insert into @NonRejectedFiled(FileId) select FileId from DOCS_FILE where FileInfoId in (select FileId from @viewFilesId) 
                       and (IsReject is null or IsReject=0);
  Insert into @viewDocVizas select VizaId from DOCS_VIZA where VizaFileId in (select v.FileId from @NonRejectedFiled v) 
                    and VizaDocId=@docId and VizaAgreementTypeId=1;
  Insert into @viewDocDirections select d.DirectionId from DOCS_DIRECTIONS d where DirectionVizaId in (select v.VizaId from @viewDocVizas v) 
                               and DirectionTypeId=3;
  Update DOCS_FILE set IsDeleted=1 where FileId in (select v.FileId from @NonRejectedFiled v);
  Update DOCS_VIZA set IsDeleted=1 where VizaId in (select VizaId from @viewDocVizas);
  --if exists(select DirectionId from @viewDocDirections)
  --begin
  -- Delete from DOCS_DIRECTIONCHANGE where DirectionId in( select DirectionId from @viewDocDirections);
  -- Delete from DOCS_EXECUTOR where ExecutorDirectionId in ( select DirectionId from @viewDocDirections);
  -- Delete from DOCS_DIRECTIONS where DirectionId in ( select DirectionId from @viewDocDirections);
  --end;

  set @result=1;
 end;


END

