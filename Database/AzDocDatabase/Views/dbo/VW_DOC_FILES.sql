
CREATE VIEW [dbo].[VW_DOC_FILES] AS 
SELECT  DF.FileId, 
		DF.FileDocId, 
		FI.FileInfoId,
		      CASE WHEN DF.FileIsMain=1 THEN DF.FileVisaStatus 
			  ELSE null END FileVisaStatus, 
		DF.SignatureStatusId, 
		DF.FileCurrentVisaGroup, 
		FI.FileInfoName, 
		FI.FileInfoParentId, 
		FI.FileInfoInsertdate, 
		FI.FileInfoVersion, 
		dbo.GET_PERSON(1, FI.FileInfoWorkplaceId) AS PersonFullName, 
		DV.VizaConfirmed, 
		DF.FileIsMain, 
		dbo.GET_MAIN_EXECUTOR_WORKPLACEID(DF.FileDocId) AS MainExecutorsWorkplaceId, 
		FI.FileInfoWorkplaceId AS InsertedUserWorkplaceId,
		dbo.DOCS.DocInsertedById ,
		dbo.DOCS.DocDoctypeId,
		FI.FileInfoAttachmentCount,
		FI.FileInfoCopiesCount,
		FI.FileInfoPageCount,
		0 as DirectionConfirmed,DV.VizaId
FROM dbo.DOCS_FILE  AS DF 
		INNER JOIN dbo.DOCS_FILEINFO AS FI ON DF.FileInfoId = FI.FileInfoId 
		LEFT OUTER JOIN dbo.DOCS ON DF.FileDocId = dbo.DOCS.DocId 
		LEFT OUTER JOIN dbo.DOCS_VIZA AS DV ON DF.FileId = DV.VizaFileId  AND (DV.VizaWorkPlaceId = dbo.GET_SESSION(2)  AND DBO.GET_LAST_VIZA(DV.VizaId,DV.VizaFileId,dbo.GET_SESSION(2))=DV.VizaId)
		      --LEFT OUTER JOIN  dbo.DOCS_DIRECTIONS dir ON DV.VizaId = dir.DirectionVizaId 
Where (DF.IsDeleted=0 or df.IsDeleted is null) 
		AND NOT EXISTS(select FileInfoParentId from DOCS_FILEINFO where FileInfoParentId = FI.FileInfoId) 
		and (DF.IsReject=0 or DF.IsReject is null)

