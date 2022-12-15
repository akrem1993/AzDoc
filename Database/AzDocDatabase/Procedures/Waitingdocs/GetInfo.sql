CREATE PROCEDURE [WaitingDocs].[GetInfo] 
@docNo          nvarchar(max) 
                         
                            
AS
    BEGIN
       SELECT d.DocId, 
                      d.DocDoctypeId, 
					  dt.DocTypeName DocType,
                      d.DocEnterno, 
                      d.DocEnterdate, 
                      d.DocDocno, 
                      d.DocDocdate, 
                      d.DocPlannedDate
               FROM dbo.DOCS d 
			   JOIN dbo.DOC_TYPE dt ON dt.DocTypeId=d.DocDoctypeId 
			  where d.DocEnterNo=@docNo  or DocDocNo=@docNo
			  --and d.RecoveryDate IS null
                   --LEFT JOIN WaitingDocs.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
                   -- LEFT JOIN WaitingDocs.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
                   -- LEFT JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
                  -- LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
                   --LEFT JOIN dbo.DOC_DIRECTIONTYPE dd ON dr.DirectionTypeId = dd.DirectionTypeId
                   -- LEFT JOIN dbo.DOC_SENDSTATUS ds2 ON e.SendStatusId = ds2.SendStatusId
            --   WHERE e.ExecutorWorkplaceId = 49
    END;