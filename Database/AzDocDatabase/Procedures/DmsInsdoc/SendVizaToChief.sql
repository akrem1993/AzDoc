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
-- Create date: 20.05.2019
-- Description: Vizani shobe ya sektor mudirine teyin edilmesi
-- =============================================
CREATE PROCEDURE [dms_insdoc].[SendVizaToChief]
@docId int,
@workPlaceId int
AS
DECLARE
    @receiverWorkPlaceId int,
    @chiefVizaId int,
    @directionId int,
    @executorId int;
BEGIN
SET NOCOUNT ON;

SELECT 
@chiefVizaId=dv.VizaId,
@receiverWorkPlaceId=dv.VizaWorkPlaceId 
FROM dbo.DOCS_VIZA dv
WHERE
dv.VizaDocId=@docId
and dv.VizaSenderWorkPlaceId=@workPlaceId
and VizaFromWorkflow=1
and IsDeleted=0;

IF @chiefVizaId IS NULL 
 THROW 51000, 'Şöbə və ya sektor müdirinin vizası tapılmadı', 1;

update dbo.DOCS_VIZA
set 
VizaSenddate=dbo.SYSDATETIME()
where 
VizaId=@chiefVizaId;

Insert into DOCS_DIRECTIONS(
              DirectionCreatorWorkplaceId,
              DirectionDocId,
              DirectionTypeId,
              DirectionWorkplaceId,
              DirectionInsertedDate,
              DirectionDate,
              DirectionVizaId,
              DirectionConfirmed,
              DirectionSendStatus
              ) 
         values
             (
              @workPlaceId,
              @docId,
              3,
              @receiverWorkPlaceId,
              dbo.SYSDATETIME(),
              dbo.SYSDATETIME(),
              @chiefVizaId,
              1,
              1
             )
       set @directionId=SCOPE_IDENTITY();

        Insert into DOCS_EXECUTOR(DirectionTypeId,
               ExecutorDocId,
               ExecutorMain,
               ExecutorWorkplaceId,
               ExecutorFullName,
               SendStatusId,
               ExecutorDirectionId) 
         values 
               (3,
               @docId,
               0,
               @receiverWorkPlaceId,
               dbo.fnGetPersonnelbyWorkPlaceId(@receiverWorkPlaceId,106),
               7,
               @directionId) 
         SET @executorId=SCOPE_IDENTITY();


        EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @receiverWorkPlaceId,
          @DocTypeId = 3,
          @OperationTypeId = 7,
          @DirectionTypeId = 3,
          @OperationStatusId = 2,
          @OperationStatusDate = null,
          @OperationNote = null
END

