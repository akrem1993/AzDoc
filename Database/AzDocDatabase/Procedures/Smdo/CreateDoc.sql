-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 07.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [smdo].[CreateDoc]
@docGuid nvarchar(max),
@workPlaceId int,
@docDescription nvarchar(max),
@filePath nvarchar(max)=null,
@isReceived bit=0,
@outDocId int OUTPUT
AS
DECLARE @docCount int
BEGIN

SELECT @docCount=count(0) FROM smdo.SmdoDocs sd WHERE sd.IsReceived=0 AND sd.DocAckStatus=0

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
    N'AZ-BEL'+cast(@docCount AS nvarchar(50)), -- DocEnterNo - nvarchar
    dbo.SYSDATETIME(), -- DocEnterDate - datetime
    @workPlaceId,--@workPlaceId, -- DocCreator - int
    @docGuid, -- DocMsgGuid - nvarchar
    @filePath, -- DocFilePath - nvarchar
    1, -- DocStatus - int
    0, -- DocAckStatus - tinyint
    23, -- DocSigner - int
    @docDescription, -- DocDescription - nvarchar
    N'Письмо', -- DocKind - nvarchar
    @isReceived -- IsReceived - bit
)

SET @outDocId=SCOPE_IDENTITY()

END

