/*
Migrated by Kamran A-eff 07.09.2019
*/

/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE VIEW [dbo].[VW_DOCS_VIZA]
 AS
 SELECT 
 DV.VizaId,
 DV.VizaDocId,
 
 DV.VizaFileId,
 DV.VizaOrderindex,
 DBO.GET_PERSON(1,VizaWorkPlaceId) AS PersonFullName,
 DV.VizaConfirmed,
 DV.VizaSenderWorkPlaceId,
 DF.FileCurrentVisaGroup,
 dv.VizaNotes,
 DV.VizaSenddate,
 DV.VizaAgreementTypeId,
 DV.VizaFromWorkflow
FROM DOCS_VIZA DV INNER JOIN
VW_DOC_FILES DF ON DV.VizaFileId=DF.FileId
where (DV.IsDeleted is null or DV.IsDeleted=0)

