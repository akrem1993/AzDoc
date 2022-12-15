












CREATE   VIEW [dbo].[VW_DOC_OLD_LAST]
AS
SELECT vizaconfirmed, 
       directiondate AS DirectionDate, 
       dir.directionid, 
       exc.executorid,
dbo.fnGetPersonnelbyWorkPlaceId(dir.DirectionWorkplaceId,106) AS PersonFrom,
       --CASE
       --    WHEN exc.executormain = 1
       --    THEN(Concat('', [dbo].[FUN_VACATION_CHANGE_PERSON](dir.DirectionWorkplaceId, dir.DirectionDate, dir.directionpersonid), ''))
       --    ELSE [dbo].[FUN_VACATION_CHANGE_PERSON](dir.DirectionWorkplaceId, dir.DirectionDate, dir.directionpersonid)
       --END AS PersonFrom,
       --CASE
       --    WHEN dir.directiontypeid = 4
       --    THEN NULL
       --    ELSE CASE
       --             WHEN exc.executormain = 1
       --             THEN(Concat('', [dbo].[FUN_VACATION_CHANGE_PERSON](exc.ExecutorWorkplaceId, dir.DirectionDate, exc.executorpersonid), ''))
       --             ELSE [dbo].[FUN_VACATION_CHANGE_PERSON](exc.ExecutorWorkplaceId, dir.DirectionDate, exc.executorpersonid)
       --         END
       --END AS PersonTo,
CASE WHEN dir.directiontypeid = 4 THEN NULL
ELSE 
 dbo.fnGetPersonnelbyWorkPlaceId(exc.ExecutorWorkplaceId,106) end AS PersonTo,
       CASE
           WHEN dir.directiontypeid = 4
           THEN N'Yeni sənəd'
           WHEN dir.directiontypeid = 3
           THEN N'Viza üçün'
           WHEN dir.directiontypeid = 8
           THEN N'İmza üçün'
           WHEN dir.directiontypeid = 9
           THEN N'Çap etmək üçün'
           WHEN dir.directiontypeid = 10
           THEN N'Göndərilmək üçün'
           WHEN dir.directiontypeid = 2
           THEN dir_type.directiontypename
           WHEN dir.directiontypeid IN(17, 1)
           THEN send_status.sendstatusname
           WHEN dir.directiontypeid = 13
                OR dir.directiontypeid = 14
           THEN N'Redaktə üçün'
           WHEN dir.directiontypeid = 15
           THEN dir_type.directiontypename
           ELSE dir_type.directiontypename
       END AS ExecutorMain,
       CASE
           WHEN dir.directiontypeid = 3
                AND vizaconfirmed = 0
           THEN N'Vizadadır'
           WHEN dir.directiontypeid = 3
                AND vizaconfirmed = 1
           THEN N'Təsdiq edilib'
           WHEN dir.directiontypeid = 3
                AND vizaconfirmed = 2
           THEN N'İmtina edilib'
           WHEN dir.directiontypeid = 15
                AND vizaconfirmed = 0
           THEN N'Təsdiqdədir'
           WHEN dir.directiontypeid = 15
                AND vizaconfirmed = 1
           THEN N'Təsdiqlənib'
           WHEN dir.directiontypeid = 15
                AND vizaconfirmed = 2
           THEN N'Təsdiqlənməyib'
           WHEN(dir.directiontypeid = 13
                OR dir.directiontypeid = 14)
               AND EXISTS
(
    SELECT *
    FROM docs_directions d
    WHERE d.directionid > dir.directionid
          AND d.directiondocid = docs.docid
)
           THEN N'Redaktə edilib'
           WHEN dir.directiontypeid = 8
                AND docs_filesign.signatureworkplaceid IS NULL
                AND docs_file.signaturestatusid IS NULL
           THEN N'İmzadadır'
           WHEN dir.directiontypeid = 8
                AND docs_filesign.signatureworkplaceid IS NOT NULL
           THEN N'İmzalanıb'
           WHEN dir.directiontypeid = 8
                AND docs_file.signaturestatusid = 3
           THEN N'İmtina edilib'
           WHEN dir.directiontypeid = 9
                AND docs.docdocumentstatusid IN(20, 27)
           THEN N'Çap edildi'
           WHEN dir.directiontypeid = 10
                AND docs.docdocumentstatusid IN(20)
           THEN N'Göndərildi'
           WHEN dir.directiontypeid IN(17, 1)
                AND i.documentstatusid = 12
           THEN N'İcra olunub'
           WHEN dir.directiontypeid IN(17, 1)
                AND i.documentstatusid <> 12
           THEN N'İcradadır'
       END AS STATUS, 
       docs_file.signaturestatusid,
       CASE
           WHEN dir.directiontypeid IN(3, 15)
                AND vizaconfirmed = 1
           THEN vizareplydate
           WHEN dir.directiontypeid IN(3, 15)
                AND vizaconfirmed = 2
           THEN vizareplydate
           WHEN dir.directiontypeid IN(13, 14, 18)
           THEN
(
    SELECT MIN(directiondate)
    FROM docs_directions d
    WHERE d.directionid > dir.directionid
          AND d.directiondocid = docs.docid
)
           WHEN dir.directiontypeid = 8
                AND docs_filesign.signatureworkplaceid IS NOT NULL
           THEN docs_filesign.signaturedate
           WHEN dir.directiontypeid = 8
                AND docs_file.signaturestatusid = 3
           THEN docs_file.signaturedate
           WHEN dir.directiontypeid = 9
                AND exc.executorworkplaceid = docs.docprintedbyid
                AND docs.docdocumentstatusid IN(20, 27)
           THEN docs.docprinteddate
           WHEN dir.directiontypeid = 10
                AND exc.executorworkplaceid = docs.docsendbyid
                AND docs.docdocumentstatusid IN(20)
           THEN docs.docsenddate
       END AS StatusDate,
       CASE
           WHEN dir.directiontypeid = 8
                AND docs_filesign.signatureworkplaceid IS NOT NULL
           THEN docs_filesign.signaturenote
           WHEN dir.directiontypeid = 8
                AND docs_file.signaturestatusid = 3
           THEN docs_file.signaturenote
           WHEN dir.directiontypeid IN(3, 15)
           THEN docs_viza.vizanotes
           ELSE Concat(exc.executorresolutionnote, doc_direction_template.template)
       END ExecutorResolutionNote, 
       dir.directiontypeid,
exc.SendStatusId,
(CASE
	 WHEN  dir.DirectionTypeId=7   AND dd.ChangeType=2  THEN
			  dd.NewDirectionPlannedDate 
	end) AS NewDirectionPlannedDate,
	(CASE
	 WHEN  dir.DirectionTypeId=7   AND dd.ChangeType=2 AND dd.DirectionChangeStatus=1 THEN
			  N'Təsdiq edilib'
			  WHEN   dir.DirectionTypeId=7 AND dd.ChangeType=2 AND dd.DirectionChangeStatus=0 THEN
			  N'Təsdiqdədir'
			   WHEN   dir.DirectionTypeId=7 AND dd.ChangeType=2 AND dd.DirectionChangeStatus=2 THEN
			  N'İmtina edilib'
	end) AS DirectionChangeStatus,
--(CASE
--	 WHEN exc.SendStatusId=1   AND (SELECT DISTINCT dd.ChangeType FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.ChangeType=2 )=2 THEN
--			  (SELECT DISTINCT dd.NewDirectionPlannedDate FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.ChangeType=2)
--	end) AS NewDirectionPlannedDate,
--	(CASE
--	 WHEN exc.SendStatusId=1  AND (SELECT DISTINCT  dd.ChangeType FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.ChangeType=2 )=2
--	    AND (SELECT DISTINCT dd.DirectionChangeStatus FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.DirectionChangeStatus=1)=1 THEN
--			  N'Təsdiq edilib'
--			  WHEN  exc.SendStatusId=1  AND (SELECT DISTINCT dd.ChangeType FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.ChangeType=2 )=2
--			    AND (SELECT DISTINCT dd.DirectionChangeStatus FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.DirectionChangeStatus=0 )=0 THEN
--			  N'Təsdiqdədir'
--			   WHEN  exc.SendStatusId=1
--			     AND (SELECT DISTINCT dd.ChangeType FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.ChangeType=2 )=2
--				 AND (SELECT DISTINCT dd.DirectionChangeStatus FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.DirectionId=dir.DirectionId and dd.DirectionChangeStatus=2 )=2  THEN
--			  N'İmtina edilib'
--	end) AS DirectionChangeStatus,
	dbo.docs.DocId
FROM docs_directions AS dir
     LEFT JOIN docs ON dir.directiondocid = docs.docid
     LEFT JOIN docs_executor AS exc ON dir.directionid = exc.executordirectionid
     LEFT JOIN docs_viza ON docs_viza.vizaid = dir.directionvizaid
     LEFT JOIN docs_file ON docs_file.fileid = dbo.Get_sign_file(exc.executorid)
     LEFT JOIN docs_filesign ON docs_file.fileid = docs_filesign.fileid
                                AND (signaturetypeid = 20
                                     OR signaturetypeid = 21)
     LEFT JOIN doc_direction_template ON dir.directiontemplateid = doc_direction_template.dirtemplateid
     LEFT JOIN doc_directiontype AS dir_type ON dir_type.directiontypeid = dir.directiontypeid
     LEFT JOIN doc_sendstatus AS send_status ON send_status.sendstatusid = exc.sendstatusid
     LEFT JOIN docs_executorinfo i ON exc.executorid = i.executorid
	 LEFT JOIN dbo.DOCS_DIRECTIONCHANGE dd ON dir.DirectionId = dd.DirectionId 
WHERE dir.directiondocid = dbo.docs.DocId
      AND (dir.directionconfirmed = 1
           OR dir.directionconfirmed = 2)
      AND dir.directiontypeid NOT IN(5)

