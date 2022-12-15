/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationSend]
@docId int,
@workPlaceId int,
@result int output 
AS
DECLARE 
 @directionVizaId int=null,
 @docInsertedWorkPlaceId int,
 @executorId int,
 @directionId int,
  @directionWorkPlaceId int;
BEGIN

 select @docInsertedWorkPlaceId=d.DocInsertedById from dbo.DOCS d where d.DocId=@docId and d.DocDeleted=0

 if @docInsertedWorkPlaceId is not null
 begin
  --==================HEAD=================================================>
      update dbo.DOCS 
   set DocDocumentstatusId=28, --Vizadadir
   DocDocumentOldStatusId=31   
    where DocId=@docId;


   SELECT 
   @executorId=e.ExecutorId,
      @directionWorkPlaceId=dr.DirectionWorkplaceId,
   @directionVizaId=dr.DirectionVizaId
   from 
   dbo.DOCS_EXECUTOR e 
   join 
   dbo.DOCS_DIRECTIONS dr on e.ExecutorDirectionId=dr.DirectionId
   where 
   e.ExecutorDocId=@docId 
   and e.ExecutorWorkplaceId=@workPlaceId 
   and e.DirectionTypeId=13 
   and e.ExecutorReadStatus=0;
    --<===============HEAD====================================================


   IF @executorId is not null--===========eger sened redakte ucun gelibse==================
   BEGIN
    UPDATE dbo.DocOperationsLog
    SET
    OperationStatus = 11, --redakte edilib
    OperationStatusDate = dbo.SYSDATETIME(),
    OperationNote = null
    where 
    DocId=@docId
    AND ExecutorId=@executorId

        EXEC outgoingdoc.spSendVizaToNextGroup
                 @docId=@docId,
                 @workPlaceId=@workPlaceId,
				 @result=@result out; 
   END
   ELSE --====================sened shobe ya sektor mudirine gedir===========================
   BEGIN
            --DECLARE @chiefWorkPLaceId int=dbo.fnGetDepartmentChiefInViza(@docId);
   DECLARE @chiefWorkPLaceId int=dbo.fnGetDepartmentChief(@workPlaceId);

            IF @workPlaceId=@chiefWorkPLaceId AND @docInsertedWorkPlaceId=@workPlaceId--eger senedi yaradan shobe mudiri olarsa oz adindan gedir vizaya
            BEGIN 

            DECLARE @singerWorkPlaceId int;

            SELECT @singerWorkPlaceId=da.AdrPersonId 
            FROM dbo.DOCS_ADDRESSINFO da 
            WHERE da.AdrDocId = @docId AND da.AdrTypeId=1;

            DECLARE @statusDate datetime = dbo.sysdatetime();

     --       IF ((SELECT count(dr.RelatedDocumentId) FROM dbo.DOCS_RELATED dr WHERE dr.RelatedTypeId=2 AND dr.RelatedDocId=@docId)>0 AND @workPlaceId!=@singerWorkPlaceId) -- Rufin razilasma sxemi ucun
     --       BEGIN         

     --        IF EXISTS(SELECT dv.VizaId FROM dbo.DOCS_VIZA dv 
     --                WHERE 
     --                       dv.VizaDocId = @docId 
     --               AND dv.VizaWorkPlaceId = @workPlaceId 
     --              AND dv.VizaFromWorkflow = 1 
				 --  AND dv.IsDeleted=0
     --              AND dv.VizaConfirmed=0)
     --        BEGIN -- eger senedi yaradan sohbe muduru evvelceden vizaya elave olunubsa ve senedi gonder vurursa sened novbeti vizalara getsin deye s.mudurunun vizasini tesdiq edirik
                  
				 --EXEC dbo.LogDocumentOperation
     --              @docId = @docId,
     --              @ExecutorId = @executorId,
     --              @SenderWorkPlaceId = @workPlaceId,
     --              @ReceiverWorkPlaceId = @workPlaceId,
     --              @DocTypeId = 12,
     --              @OperationTypeId = 7,
     --              @DirectionTypeId = 3,
     --              @OperationStatusId = 3,
     --              @OperationStatusDate = @statusDate,
     --              @OperationNote = null;

				 -- UPDATE dbo.DOCS_VIZA
     --             SET dbo.DOCS_VIZA.VizaConfirmed = 1,
     --              dbo.DOCS_VIZA.VizaReplyDate =dbo.sysdatetime()
     --             WHERE 
     --                       dbo.DOCS_VIZA.VizaDocId=@docId 
     --                AND dbo.DOCS_VIZA.VizaWorkPlaceId = @workPlaceId 
     --                AND dbo.DOCS_VIZA.VizaFromWorkflow = 1
     --                AND dbo.DOCS_VIZA.VizaConfirmed=0
     --        END;
     --       END;   
					IF EXISTS(SELECT dv.VizaId
					  FROM dbo.DOCS_VIZA dv
					  WHERE dv.VizaDocId = @docId
					  	  AND dv.VizaWorkPlaceId = @workPlaceId
					  	  AND dv.VizaFromWorkflow = 1
						  AND dv.IsDeleted=0
					  	  AND dv.VizaConfirmed = 0)  
            BEGIN 
                   UPDATE dbo.DOCS_VIZA
                              SET dbo.DOCS_VIZA.VizaConfirmed = 1,
                               dbo.DOCS_VIZA.VizaReplyDate =dbo.sysdatetime()
                              WHERE 
                                        dbo.DOCS_VIZA.VizaDocId=@docId 
                                 AND dbo.DOCS_VIZA.VizaWorkPlaceId = @workPlaceId 
                                 AND dbo.DOCS_VIZA.VizaFromWorkflow = 1
                                 AND dbo.DOCS_VIZA.VizaConfirmed=0

                        EXEC dbo.LogDocumentOperation
                                           @docId = @docId,
                                           @ExecutorId = @executorId,
                                           @SenderWorkPlaceId = @workPlaceId,
                                           @ReceiverWorkPlaceId = @workPlaceId,
                                           @DocTypeId = 12,
                                           @OperationTypeId = 7,
                                           @DirectionTypeId = 3,
                                           @OperationStatusId = 3,
                                           @OperationStatusDate = @statusDate,
                                           @OperationNote = null;
            END;
                EXEC outgoingdoc.spSendVizaToNextGroup
                                     @docId=@docId,
                                     @workPlaceId=@workPlaceId;       
   
            END
            ELSE 
            BEGIN
               EXEC outgoingdoc.SendVizaToChief
                            @docId=@docId,
                            @workPlaceId=@workPlaceId
            END 
   END--====================================================================================
   

--================================END================================>   
   update dbo.DOCS_EXECUTOR  
   set 
   ExecutorReadStatus=1
   where 
   ExecutorDocId=@docId 
   and ExecutorWorkplaceId=@workPlaceId 
   and DirectionTypeId!=8/*rəhbər şəxs özü özünə göndərdikdə imzalaya bilməsi üçün*/
--<================================END===============================  
   set @result=1;
 end 
end;

