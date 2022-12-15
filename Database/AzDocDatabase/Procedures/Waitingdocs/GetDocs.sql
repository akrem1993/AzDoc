
CREATE PROCEDURE [WaitingDocs].[GetDocs] @workPlaceId          INT, 
                                  @periodId             INT           = NULL, 
                                  @sendStatusId         INT           = NULL, 
                                  @docTypeId            INT, 
                                  @pageIndex            INT           = 1, 
                                  @pageSize             INT           = 20, 
                                  @totalCount           INT OUT
                            
AS
     SET NOCOUNT ON;
     SET ANSI_NULLS OFF;
    BEGIN
       SELECT d.DocId, 
                      d.DocDoctypeId, 
                      d.DocEnterno, 
                      d.DocEnterdate, 
                      d.DocDocno, 
                      d.DocDocdate, 
                      d.DocPlannedDate,					 
                      (SELECT FullName FROM dbo.DOCS_ADDRESSINFO da WHERE da.AdrDocId=d.DocId AND da.AdrTypeId=1) Signer, 
                      stuff((select ''+do.OrganizationName+'' from dbo.DC_ORGANIZATION do 
							WHERE do.OrganizationId IN (SELECT da.AdrOrganizationId from dbo.DOCS_ADDRESSINFO da WHERE da.AdrDocId=d.DocId
							AND da.AdrTypeId=3 AND da.AdrAuthorId IS NOT null)
							for xml path('')),1,1,'') DocAuthorInfo, --Hardan daxil olub 
                      stuff(( SELECT da.AuthorName+''+ da.AuthorSurname+''+ ISNULL(da.AuthorLastname,'')+'' FROM dbo.DOC_AUTHOR da  WHERE da.AuthorId IN (SELECT da2.AdrAuthorId FROM dbo.DOCS_ADDRESSINFO da2 WHERE da2.AdrDocId=d.DocId AND da2.AdrTypeId=3 AND da2.AdrAuthorId IS NOT null )
							for xml path('')),1,1,'') WhomFromInfo, --Kimdən daxil olub
               
                     stuff((SELECT ds.SendStatusName + ': ' +
                       (
                           SELECT dbo.fnGetPersonnelbyWorkPlaceId(de.ExecutorWorkplaceId, 106)
                       ) + ' ; '
                       FROM WaitingDocs.DOCS_EXECUTOR de
                            LEFT JOIN dbo.DOC_SENDSTATUS ds ON de.SendStatusId = ds.SendStatusId
                       WHERE de.ExecutorDocId = d.DocId
                             AND de.SendStatusId IN(1, 2, 3, 4)
                       ORDER BY de.SendStatusId for xml path('')),1,1,'')  SendTo, -- icracilar      
					''  ExecuteRule,--????, 
                    drf.ReceivedFormName, 
                   d.DocDescription, 
                   ds.DocumentstatusName,
                    '' CreaterPersonnelName,
                  CONVERT(BIT, 1) ExecutorControlStatus 
     --               1  SendStatusId 
	                     --  dr.DirectionInsertedDate
               FROM WaitingDocs.DOCS d 
                   LEFT JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
                   LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
                   --LEFT JOIN dbo.DOC_DIRECTIONTYPE dd ON dr.DirectionTypeId = dd.DirectionTypeId
                   -- LEFT JOIN dbo.DOC_SENDSTATUS ds2 ON e.SendStatusId = ds2.SendStatusId
            --   WHERE e.ExecutorWorkplaceId = 49
			WHERE d.RecoveryDate IS null

		

		
            

           
    END;

