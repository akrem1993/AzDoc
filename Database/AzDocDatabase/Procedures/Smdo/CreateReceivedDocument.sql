-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 12.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [smdo].[CreateReceivedDocument]
@docGuid nvarchar(max),
@docDescription nvarchar(max)=null,
@relatedDoc int,
@sign nvarchar(max),
@attachName nvarchar(max),
--@attachGuid nvarchar(max),
@docId int OUTPUT
AS
DECLARE @docCount int,@docCreator int=0
BEGIN

BEGIN TRANSACTION 
  
begin try

SELECT @docCount=count(0) FROM smdo.SmdoDocs sd WHERE sd.IsReceived=1 AND sd.DocAckStatus=0

SELECT @docCreator= sd.DocCreator FROM smdo.SmdoDocs sd WHERE sd.DocId=@relatedDoc;

INSERT smdo.SmdoDocs
(
    --DocId - column value is auto-generated
    AzDocId,
    DocEnterNo,
    DocEnterDate,
    DocCreator,
    DocMsgGuid,
    DocFilePath,
    DocStatus,
    DocAckStatus,
    DocSigner,
    DocDescription,
    DocKind,
    IsReceived
)
VALUES
(
    -- DocId - int
    0, -- AzDocId - int
    N'BEL-AZ'+cast(@docCount AS nvarchar(50)), -- DocEnterNo - nvarchar
    dbo.SYSDATETIME(), -- DocEnterDate - datetime
    @docCreator, -- DocCreator - int
    @docGuid, -- DocMsgGuid - nvarchar
    null, -- DocFilePath - nvarchar
    4, -- DocStatus - int
    0, -- DocAckStatus - tinyint
    23, -- DocSigner - int
    @docDescription, -- DocDescription - nvarchar
    N'Письмо', -- DocKind - nvarchar
    1 -- IsReceived - bit
)

SET @docId=SCOPE_IDENTITY();

INSERT smdo.RelatedDoc
(
    --id - column value is auto-generated
    DocId,
    RelatedDocId
)
VALUES
(
    -- id - int
    @docId, -- DocId - int
    @relatedDoc -- RelatedDocId - int
)

INSERT smdo.ReceivedDocDetails
(
    --Id - column value is auto-generated
    DocId,
    SignP7S,
    AttachName,
    AttachPath
)
VALUES
(
    -- Id - int
    @docId, -- DocId - int
    @sign, -- SignP7S - nvarchar
    @attachName, -- AttachName - nvarchar
    null

)

COMMIT TRANSACTION	
END TRY
BEGIN CATCH
DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
                   @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();

            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

END

