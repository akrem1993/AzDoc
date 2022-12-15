

CREATE viEW [smdo].[GetSmdoDocs]
AS
SELECT sd.DocId, 
       sd.DocEnterNo, 
       sd.DocEnterDate, 
       dbo.fnGetPersonnelbyWorkPlaceId( sd.DocCreator,106) AS Creator, 
       sd.DocMsgGuid, 
       sd.DocFilePath, 
       sds.StatusName, 
       sd.DocAckStatus, 
       dbo.fnGetPersonnelbyWorkPlaceId(sd.DocSigner,106) AS Signer, 
       sd.DocDescription AS Note, 
       sd.DocKind, 
       sd.IsReceived,
sd.DocStatus,
N'Письмо' AS Kind
FROM smdo.SmdoDocs sd
JOIN smdo.SmdoDocStatus sds ON sd.DocStatus=sds.StatusId
where sd.DocAckStatus=0

