/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationVisaAccept]
@docId int,
@docTypeId int,
@workPlaceId int,
@note nvarchar(max)=null,
@result int output 
as
BEGIN
    set nocount on;
 declare 
 @vizaCount int=0,
 @vizaOrderIndex int=0,
 @vizaConfirmedCount int=0,
 @confirmWorkPlaceId int=0,
 @vizaId int,
  @documentStatusId int,
  @executorId int,
  @directionType int;

 select @documentStatusId=d.DocDocumentstatusId from dbo.DOCS d where d.DocId=@docId;

 if exists(select v.VizaId 
            from dbo.DOCS_VIZA v 
            where 
            v.VizaDocId=@docId
            and v.VizaWorkPlaceId=@workPlaceId 
            and v.IsDeleted=0)
  begin      
   --select @vizaCount=count(0) from dbo.DOCS_VIZA v where v.VizaDocId=@docId  AND v.IsDeleted=0;
     
   --if(@vizaCount>1)
   --begin
    select 
        @vizaOrderIndex=v.VizaOrderindex 
        from dbo.DOCS_VIZA v 
        where v.VizaDocId=@docId 
        and v.VizaWorkPlaceId=@workPlaceId
        AND v.IsDeleted=0;
          
    if exists(select v.VizaId from dbo.DOCS_VIZA v where 
                                            v.VizaDocId=@docId 
                                            AND (v.VizaOrderindex=@vizaOrderIndex or v.VizaOrderindex is null)
                                            and v.VizaConfirmed=0 
                                            and v.IsDeleted=0)
    BEGIN

     SELECT 
          @executorId=de.ExecutorId,
          @directionType=de.DirectionTypeId 
          FROM dbo.DOCS_EXECUTOR de
     WHERE 
     de.ExecutorDocId=@docId
     and de.ExecutorReadStatus=0
     AND de.ExecutorWorkplaceId=@workPlaceId;

     update dbo.DOCS_VIZA 
     set VizaConfirmed=1,
     VizaReplyDate=dbo.SYSDATETIME()
     where 
     VizaDocId=@docId 
     and VizaWorkPlaceId=@workPlaceId
     and IsDeleted=0;

     update dbo.DOCS_EXECUTOR 
     set ExecutorReadStatus=1
     where ExecutorId=@executorId;

     UPDATE dbo.DocOperationsLog
     SET
         dbo.DocOperationsLog.OperationStatus = CASE WHEN @directionType=3 THEN 3 ELSE 6 end, -- int
         dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
         dbo.DocOperationsLog.OperationNote = @note -- nvarchar
     where 
     dbo.DocOperationsLog.DocId=@docId
     AND dbo.DocOperationsLog.ExecutorId=@executorId;

     select 
          @vizaConfirmedCount=COUNT(0) 
          from dbo.DOCS_VIZA v 
          where 
          v.VizaDocId=@docId
     and v.VizaOrderindex=@vizaOrderIndex
     and v.VizaConfirmed=0 
          and v.IsDeleted=0;
     

     if(@vizaConfirmedCount=0)--eger oz qrupunda testiq edecek shexs qalmayibsa 0 olur
     BEGIN
            
         if exists(select * from dbo.DOCS_VIZA v --novbeti qrupda kimse varsa
                        where 
                        v.VizaDocId=@docId 
                        and v.VizaWorkPlaceId<>@workPlaceId 
                        and v.VizaOrderindex>@vizaOrderIndex 
                        and v.IsDeleted=0)
         begin
          EXEC [outgoingdoc].[spSendVizaToNextGroup]
                              @workPlaceId=@workPlaceId,
                              @docId=@docId;
         end
         else------novbeti qrup yoxdusa
         begin
           if(@documentStatusId=28) --Əgər senedin statusu vizadadirsa,sened gedir imza eden shexse
           BEGIN
                  EXEC [outgoingdoc].spOperationSigner 
                  @docId = @docId,
                  @docTypeId = @docTypeId;
           END
            
           IF (@documentStatusId=16)--sened testiqlenibse gedir tapsiriqlara
           BEGIN
            EXEC outgoingdoc.spOperationTask 
             @docId = @docId,
             @docTypeId = @docTypeId,
             @workPlaceId = @workPlaceId,
             @result = @result out;
             set @result=@result;
           END
         END----------------------------------------------------------------------------------------
         END     
    end
    set @result=5;

   
   end
 set @result=5;
end

