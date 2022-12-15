/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationPost] @docId       INT, 
                                                               @docTypeId   INT, 
                                                               @workPlaceId INT, 
                                                               @note        NVARCHAR(MAX) = NULL, 
                                                               @result      INT OUTPUT
AS
  BEGIN 
    SET nocount ON; 

    DECLARE @currentExecutorId      INT, 
            @mailerworkplaceId      INT, 
            @currentDirectionId     INT, 
            @signerindex            NVARCHAR(25)=NULL, 
            @departmentindex        NVARCHAR(10)=NULL, 
          --@docIndex               NVARCHAR(20)=NULL, 
            @docEnterno             NVARCHAR(20)=NULL, 
            @organizationIndex      INT, 
            @date                   DATE= dbo.Sysdatetime(), 
            @directionId            INT, 
            @confirmWorkPlaceId     INT= 0, 
            @executorFullName       NVARCHAR(max), 
            @executorOrganizationId INT, 
            @executorDepartmentId   INT, 
            @vizaId                 INT, 
            @fileId                 INT,
   @signerWorkplaceId      INT;
    
    DECLARE @signatureExecutorId INT; 

    --SELECT @docIndex = ( Count(0) + 1 ) 
    --FROM   dbo.docs d 
    --WHERE  d.docdoctypeid = @docTypeId; 

    SELECT @organizationIndex = Ltrim(Rtrim(o.organizationindex)) 
    FROM   dbo.dc_organization o 
    WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
                               FROM   dbo.dc_workplace wp 
                               WHERE  wp.workplaceid = @workPlaceId); 
		
    SELECT @departmentindex = Ltrim(Rtrim(departmentindex)) 
    FROM   dc_workplace 
           JOIN dc_department 
             ON dc_department.departmentid = dc_workplace.workplacedepartmentid 
    WHERE  workplaceid = dbo.Fngetdepartmentchiefinviza(@workPlaceId) 


    SELECT @mailerworkplaceId = w.workplaceid 
    FROM   dc_workplace w 
           JOIN [dbo].[dc_workplace_role] wr 
             ON wr.workplaceid = w.workplaceid 
    WHERE  roleid = 243 
           AND w.workplaceorganizationid = @organizationIndex 


    SELECT @signatureExecutorId = de.executorid 
    FROM   dbo.docs_executor de 
    WHERE  de.executordocid = @docId 
           AND de.executorworkplaceid = @workPlaceId 
           AND de.executorreadstatus = 0 
           AND de.directiontypeid = 10; 
 SELECT  @signerWorkplaceId=ExecutorWorkplaceId--imzalayan wexsin workplaceid-si
    FROM   dbo.docs_executor de 
    WHERE  de.executordocid = @docId 
           AND de.directiontypeid = 8; 


    UPDATE dbo.docs_executor 
    SET    executorreadstatus = 1, 
           executorcontrolstatus = 1 
    WHERE  executorid = @signatureExecutorId; 

    UPDATE dbo.docoperationslog 
    SET    dbo.docoperationslog.operationstatus = 12, 
           dbo.docoperationslog.operationstatusdate = dbo.Sysdatetime(), 
           dbo.docoperationslog.operationnote = @note 
    WHERE  dbo.docoperationslog.docid = @docId 
           AND receiverworkplaceid = @workPlaceId
		   and dbo.docoperationslog.OperationTypeId=9;
		    UPDATE dbo.DOCS
          SET --DocEnterno=@docEnterno,
             -- DocEnterdate = SYSDATETIME(), 
              DocDocumentstatusId = 20, --İmzalanib
              DocDocumentOldStatusId = 27
        WHERE DocId = @docId;

    DECLARE @relatedDocCount INT= 0; 

    SELECT @relatedDocCount = Count(0) 
    FROM   dbo.docs_related dr 
    WHERE  dr.relateddocid = @docId 
           AND dr.relatedtypeid = 2; 

    WHILE( @relatedDocCount > 0 ) 
      BEGIN 
          DECLARE @workplaceCountAnswer INT, 
                  @relatedDocumentId    INT; 

          SELECT @workplaceCountAnswer = Count(0) 
          FROM   dbo.docs_executor de 
          WHERE  de.executordocid IN (SELECT dr.relateddocumentid 
                                      FROM   dbo.docs_related dr 
                                      WHERE  dr.relateddocid = @docId AND dr.RelatedTypeId=2) 
                 AND de.sendstatusid = 1 
                 AND de.executorreadstatus = 0; 

          SELECT @relatedDocumentId = s.relateddocumentid 
          FROM   (SELECT dr.relateddocumentid, 
                         Row_number() 
                           OVER( 
                             ORDER BY dr.relateddocumentid) AS rownumber 
                  FROM   dbo.docs_related dr 
                  WHERE  dr.relateddocid = @docId 
                         AND dr.relatedtypeid = 2) s 
          WHERE  s.rownumber = @relatedDocCount; 
		  IF(
                                (
                                    SELECT COUNT(0)
                                    FROM dbo.DOCS d
                                    WHERE d.DocId = @relatedDocumentId
                                          AND d.DocDoctypeId IN(1, 2)
                                ) = 0)
								BEGIN


								  IF NOT EXISTS---SHAHRIYAR DEYIWIKLIK
                                        (
                                            SELECT *
                                            FROM dbo.DOCS_EXECUTOR de
                                            WHERE de.ExecutorDocId IN
                                            (
                                                SELECT dr.RelatedDocumentId
                                                FROM dbo.DOCS_RELATED dr
                                                WHERE dr.RelatedDocId = @docId
                                                      AND dr.RelatedTypeId = 2
                                            )
                                                  AND de.SendStatusId = 1
                                                  AND de.ExecutorReadStatus = 0
                                                  AND de.DirectionTypeId = 1
                                        )
                                            BEGIN

          UPDATE dbo.docoperationslog 
          SET    operationstatus = 14,-- int 
                 operationstatusdate = dbo.Sysdatetime() 
          WHERE  dbo.docoperationslog.docid = @relatedDocumentId 
                 AND receiverworkplaceid = (SELECT dol.receiverworkplaceid 
                                            FROM   dbo.docoperationslog dol 
                                            WHERE 
                     dol.docid = @relatedDocumentId 
                     AND dol.executorid = 
                         (SELECT distinct de.executortopid 
                          FROM   dbo.docs_executor de JOIN  dbo.docs_directions dd  ON  de.executordirectionid  = dd.directionid 
                          WHERE  de.executordocid =@relatedDocumentId 
						  AND de.executorworkplaceid = 
                                           (SELECT de.executorworkplaceid 
                                            FROM   dbo.docs_executor de 
                                            WHERE  de.executordocid = 
                                                   @docId 
                                                   AND de.directiontypeid 
                                                       = 4 
                                           ))); 


         IF exists(SELECT * FROM dbo.DOCS_EXECUTORINFO deu WHERE deu.InfoDocId=@relatedDocumentId )--DEYIWIKLIK SHAHRIYAR
												BEGIN
													UPDATE dbo.DOCS_EXECUTORINFO
													SET													    
													    dbo.DOCS_EXECUTORINFO.DocumentStatusId = 12 -- int
														WHERE dbo.DOCS_EXECUTORINFO.InfoDocId=@relatedDocumentId AND dbo.DOCS_EXECUTORINFO.ExecutorId=(SELECT de.ExecutorTopId
                                                        FROM dbo.DOCS_EXECUTOR de
                                                             JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
                                                        WHERE de.ExecutorDocId = @relatedDocumentId
                                                              AND de.ExecutorWorkplaceId =
                                                        (
                                                            SELECT de.ExecutorWorkplaceId
                                                            FROM dbo.DOCS_EXECUTOR de
                                                            WHERE de.ExecutorDocId = @docId
                                                                  AND de.DirectionTypeId = 4
                                                        )
                                                         )
														 AND dbo.DOCS_EXECUTORINFO.RelatedDocId=@relatedDocumentId
													    

												end
										   End;
										   end

          IF( @workplaceCountAnswer = 0 ) 
            BEGIN 
                UPDATE dbo.docs 
                SET    docdocumentstatusid = 12, 
                       docdocumentoldstatusid = 1 
                WHERE  docid = @relatedDocumentId;
				
				 UPDATE dbo.DOCS_EXECUTOR
										SET
										 
										    dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1, -- bit										   
										    dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1 -- bit
											WHERE dbo.DOCS_EXECUTOR.ExecutorDocId=@relatedDocumentId;
            END; 

          SET @relatedDocCount-=1; 
      END; 
   
    --INSERT INTO DocOperationsLog (DocId,ExecutorId,SenderWorkPlaceId,ReceiverWorkPlaceId,DocTypeId,OperationTypeId,DirectionTypeId,OperationDate,OperationStatus)
    --Select TaskDocId,@currentExecutorId,@signerWorkplaceId,WhomAddressId,@docTypeId,3/*Melumat ucun*/,2/*Melumat ucun*/,GETDATE(),null from DOC_TASK where TaskDocId=@docId
  EXEC outgoingdoc.spOperationWhomAddress 
                             @docId = @docId, 
                             @docTypeId = @docTypeId, 
                             @workPlaceId =  @signerWorkplaceId, 
                             @result = @result OUT;
                        SET @result = @result;
    SET @result = 16; 
END;

