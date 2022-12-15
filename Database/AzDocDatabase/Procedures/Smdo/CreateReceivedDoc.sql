-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 12.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [smdo].[CreateReceivedDoc]
@docGuid nvarchar(max),
@workPlaceId int=null,
@docDescription nvarchar(max)=null,
@filePath nvarchar(max)=null
AS
DECLARE @docCount int
BEGIN

SELECT @docCount=count(0)+1 FROM smdo.SmdoDocs sd WHERE sd.IsReceived=1

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
    null, -- DocCreator - int
    @docGuid, -- DocMsgGuid - nvarchar
    @filePath, -- DocFilePath - nvarchar
    4, -- DocStatus - int
    0, -- DocAckStatus - tinyint
    23, -- DocSigner - int
    N'Qisa məzmun', -- DocDescription - nvarchar
    N'Письмо', -- DocKind - nvarchar
    1 -- IsReceived - bit
)

END

