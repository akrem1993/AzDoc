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
-- Author:  musayev nurlan,ehmedov rufin
-- Create date: 14.05.2019
-- Description: emeliyyatin loglanmasi
-- =============================================
CREATE PROCEDURE [dbo].[LogDocumentOperation]
@docId int,
@ExecutorId int,
@SenderWorkPlaceId int,
@ReceiverWorkPlaceId int,
@DocTypeId int=null,
@OperationTypeId int,
@DirectionTypeId int=null,
@OperationStatusId int,
@OperationStatusDate datetime,
@OperationNote nvarchar(max)
AS
DECLARE
@docType int
BEGIN
 DECLARE @date datetime=dbo.SYSDATETIME(),@docFileId int;

 SELECT @docFileId=df.FileId
 FROM dbo.DOCS_FILE df 
 WHERE 
 df.FileDocId=@docId 
 AND df.FileIsMain=1
 AND df.IsDeleted=0
 AND df.IsReject=0;

SELECT @docType=d.DocDoctypeId FROM dbo.DOCS d WHERE d.DocId=@docId;

 INSERT dbo.DocOperationsLog
 (
     --OperationId - column value is auto-generated
     DocId,
     ExecutorId,
     SenderWorkPlaceId,
     ReceiverWorkPlaceId,
     DocTypeId,
     OperationTypeId,
     DirectionTypeId,
     OperationDate,
     OperationStatus,
     OperationStatusDate,
     OperationNote,
  OperationFileId
 )
 VALUES
 (
     -- OperationId - int
     @DocId, -- DocId - int
     @ExecutorId, -- ExecutorId - int
     @SenderWorkPlaceId, -- SenderWorkPlaceId - int
     @ReceiverWorkPlaceId, -- ReceiverWorkPlaceId - int
     @docType, -- DocTypeId - int
     @OperationTypeId, -- OperationTypeId - int
     @DirectionTypeId, -- DirectionTypeId - int
     @date, -- OperationDate - datetime
     @OperationStatusId, -- OperationStatus - int
     @OperationStatusDate, -- OperationStatusDate - datetime
     @OperationNote, -- OperationNote - nvarchar,
  @docFileId
 )
END

