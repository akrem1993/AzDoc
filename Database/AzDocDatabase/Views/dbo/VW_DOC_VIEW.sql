
CREATE VIEW [dbo].[VW_DOC_VIEW]
AS
     SELECT VizaConfirmed, 
            DirectionDate, 
            dir.DirectionId, 
            dbo.fnGetPersonnelbyWorkPlaceId(dir.DirectionWorkplaceId, 106) AS PersonFrom,
            CASE
                WHEN exc.DirectionTypeId = 4
                THEN NULL
                ELSE dbo.fnGetPersonnelbyWorkPlaceId(exc.ExecutorWorkplaceId, 106)
            END AS PersonTo,
            CASE
                WHEN dir.DirectionTypeId = 4
                THEN N'Yeni sənəd'
                WHEN dir.DirectionTypeId = 3
                THEN N'Viza üçün'
                WHEN dir.DirectionTypeId = 8
                THEN N'İmza üçün'
                WHEN dir.DirectionTypeId = 9
                THEN N'Çap etmək üçün'
                WHEN dir.DirectionTypeId = 10
                THEN N'Göndərilmək üçün'
                WHEN dir.DirectionTypeId = 2
                     AND docs.DocDoctypeId = 12
                THEN dir_type.DirectionTypeName
                WHEN(dir.DirectionTypeId = 2
                     AND docs.DocDoctypeId != 12)
                    OR dir.DirectionTypeId = 17
                THEN send_status.SendStatusName
                WHEN dir.DirectionTypeId IN(17, 1)
                THEN send_status.SendStatusName
                WHEN dir.DirectionTypeId = 13
                     OR dir.DirectionTypeId = 14
                     OR dir.DirectionTypeId = 19
                THEN N'Redaktə üçün'
                WHEN dir.DirectionTypeId = 15
                THEN dir_type.DirectionTypeName
                WHEN dir.DirectionTypeId = 18
                THEN send_status.SendStatusName
                ELSE dir_type.DirectionTypeName
            END AS ExecutorMain,
            CASE
                WHEN dir.DirectionTypeId = 4
                     AND VizaConfirmed = 3
                THEN N''
                WHEN dir.DirectionTypeId = 4
                     AND VizaConfirmed = 0
                THEN N''
                WHEN dir.DirectionTypeId = 3
                     AND VizaConfirmed = 0
                THEN N'Vizadadır'
                WHEN dir.DirectionTypeId = 3
                     AND VizaConfirmed = 1
                THEN N'Təsdiq edilib'
                WHEN dir.DirectionTypeId = 3
                     AND VizaConfirmed = 2
                THEN N'İmtina edilib'
                WHEN dir.DirectionTypeId = 19
                THEN N'Geri qaytarılıb'
                WHEN dir.DirectionTypeId = 15
                     AND VizaConfirmed = 0
                THEN N'Təsdiqdədir'
                WHEN dir.DirectionTypeId = 15
                     AND VizaConfirmed = 1
                THEN N'Təsdiqlənib'
                WHEN dir.DirectionTypeId = 15
                     AND VizaConfirmed = 2
                THEN N'İmtina edilib'
                WHEN(dir.DirectionTypeId = 13
                     OR dir.DirectionTypeId = 14)
                    --and EXISTS(SELECT * from DOCS_FILE files LEFT JOIN DOCS_FILEINFO filesinfo ON files.FileInfoId = filesinfo.FileInfoId where files.FileDocId=@docId and FileInfoParentId=DOCS_FILE.FileInfoId) 
                    AND exc.ExecutorReadStatus = 1
                THEN N'Redaktə edilib'
                WHEN dir.DirectionTypeId = 8
                     AND DOCS_FILE.SignatureStatusId = 1
                THEN N'İmzadadır'
                WHEN dir.DirectionTypeId = 8
                     --AND DOCS_FILE.SignatureStatusId = 2
                     AND 1 =
     (
         SELECT COUNT(0)
         FROM dbo.DOCS_FILE df
         WHERE df.FileDocId = SESSION_CONTEXT(N'docId')
               AND df.SignatureStatusId = 2
               AND df.IsReject = 0
			   AND df.FileVisaStatus=2
     )
                THEN N'İmzalanıb'
                WHEN dir.DirectionTypeId = 8
                     AND DOCS_FILE.SignatureStatusId = 3
                THEN N'İmtina edilib'
                WHEN dir.DirectionTypeId = 9
                     AND docs.DocDocumentStatusId IN(20, 27)
                THEN N'Çap edildi'
                WHEN dir.DirectionTypeId = 10
                     AND docs.DocDocumentStatusId IN(20)
                THEN N'Göndərildi'
                WHEN dir.DirectionTypeId = 2
                THEN N'Göndərildi'
            END AS STATUS,
            CASE
                WHEN dir.DirectionTypeId IN(3, 15)
                     AND VizaConfirmed = 1
                THEN VizaReplyDate
                WHEN dir.DirectionTypeId IN(3, 15)
                     AND VizaConfirmed = 2
                THEN VizaReplyDate
                WHEN(dir.DirectionTypeId = 13
                     OR dir.DirectionTypeId = 14)
                THEN VizaReplyDate--and EXISTS(SELECT * from DOCS_FILE files LEFT JOIN DOCS_FILEINFO filesinfo ON files.FileInfoId = filesinfo.FileInfoId where files.FileDocId=@docId and FileInfoParentId=DOCS_FILE.FileInfoId)       THEN DocUpdatedByDate                             
                WHEN dir.DirectionTypeId = 8
                     AND 1 =
     (
         SELECT COUNT(0)
         FROM dbo.DOCS_FILE df
         WHERE df.FileDocId = SESSION_CONTEXT(N'docId')
               AND df.SignatureStatusId = 2
               AND df.IsReject = 0
			  AND df.FileVisaStatus=2
     )
                THEN (SELECT df.SignatureDate
         FROM dbo.DOCS_FILE df
         WHERE df.FileDocId = SESSION_CONTEXT(N'docId')
               AND df.SignatureStatusId = 2
               AND df.IsReject = 0
			    AND df.FileVisaStatus=2)
                WHEN dir.DirectionTypeId = 8
                     AND DOCS_FILE.SignatureStatusId = 3
                THEN SignatureDate
                WHEN dir.DirectionTypeId = 2
                THEN dir.DirectionDate
                WHEN dir.DirectionTypeId = 19
                THEN dir.DirectionDate
            END AS StatusDate,
            CASE
                WHEN dir.DirectionTypeId = 8
                THEN DOCS_FILE.SignatureNote
                WHEN dir.DirectionTypeId IN(3, 15)
                THEN DOCS_VIZA.VizaNotes
                ELSE DOC_DIRECTION_TEMPLATE.Template
            END ExecutorResolutionNote,
            CASE
                WHEN exc.ExecutionstatusId IS NULL
                THEN exc.SendStatusId
                ELSE 0
            END AS SendStatusId
     FROM DOCS_DIRECTIONS AS dir
          LEFT JOIN dbo.docs ON dir.DirectionDocId = docs.Docid
          LEFT JOIN DOCS_EXECUTOR AS exc ON dir.DirectionId = exc.ExecutorDirectionId
          LEFT JOIN DOCS_VIZA ON DOCS_VIZA.VizaId = dir.DirectionVizaId
          LEFT JOIN DOCS_FILE ON docs_viza.VizaFileId = docs_file.FileId
          LEFT JOIN DOC_DIRECTION_TEMPLATE ON dir.DirectionTemplateId = DOC_DIRECTION_TEMPLATE.DirTemplateId
          LEFT JOIN DOC_DIRECTIONTYPE AS dir_type ON dir_type.DirectionTypeId = dir.DirectionTypeId
          LEFT JOIN DOC_SENDSTATUS AS send_status ON send_status.SendStatusId = exc.SendStatusId
     WHERE dir.DirectionDocId = SESSION_CONTEXT(N'docId')
           AND ISNULL(dir.DirectionConfirmed, 1) = 1
           AND ISNULL(dir.DirectionSendStatus, 0) <> 0
           AND dir.DirectionTypeId NOT IN(5)
          AND exc.ExecutorId NOT IN
     (
         SELECT ISNULL(dol.ExecutorId, 0)
         FROM dbo.DocOperationsLog dol
         WHERE dol.DocId = SESSION_CONTEXT(N'docId')
     );

