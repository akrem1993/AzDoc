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
-- Author:  Rufin Ahmadov
-- Create date: 17.04.2019
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spChangeOldViza]
@fileInfoId int,
@newFileId int,
@docId int
WITH EXEC AS CALLER
AS
begin
  begin try
    begin transaction
    
      declare @oldFileId int;
      select @oldFileId = FileId from DOCS_FILE where FileInfoId=@fileInfoId
    
      declare @Viza table(VizaId int null, VizaOrderIndex int null, VizaFileId int null, RowNumber int null);
      
      insert into @Viza(VizaId , VizaOrderIndex , VizaFileId, RowNumber)
      select v.VizaId, v.VizaOrderindex, v.VizaFileId ,ROW_NUMBER() over (order by v.VizaOrderindex desc)
      from DOCS_VIZA v 
      where v.VizaDocId = @docId 
   and v.VizaFileId = @oldFileId 
      order by v.VizaOrderindex;
      
      if exists(select * from @Viza)
      begin
        declare @vizaCount int;
        select @vizaCount = count(0) from @Viza
        
        declare @vizaId int;
        
        while(@vizaCount>0)
        begin
          select @vizaId=VizaId from @Viza where RowNumber=@vizaCount
        
          update DOCS_VIZA SET
             VizaFileId = @newFileId
            --,VizaSenddate = dbo.sysdatetime()
            --,VizaConfirmed = 0
          WHERE VizaId = @vizaId

          set @vizaCount-=1;
        end;
      end;
    commit transaction
  end try
  begin catch
    rollback transaction
  end catch;
end;

