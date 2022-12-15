/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationConfirmSignature] @docId       INT, 
                                                            @docTypeId   INT, 
                                                            @workPlaceId INT, 
                                                            @note        NVARCHAR(MAX) = NULL, 
                                                            @result      INT OUTPUT
AS
BEGIN 
    SET nocount ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on

    DECLARE @currentExecutorId      INT, 
            @printerworkplaceId     INT, 
            @currentDirectionId     INT, 
            @signerindex            NVARCHAR(25)= NULL, 
            @departmentindex        NVARCHAR(10)= NULL, 
            @docIndex               NVARCHAR(20)= NULL, 
            @docEnterno             NVARCHAR(20)= NULL, 
            @organizationIndex      INT, 
            @date                   DATE= dbo.Sysdatetime(), 
            @directionId            INT, 
            @confirmWorkPlaceId     INT= 0, 
            @executorFullName       NVARCHAR(max), 
            @executorOrganizationId INT, 
            @executorDepartmentId   INT, 
            @vizaId                 INT, 
            @fileId                 INT, 
            @organizationId         INT, 
            @departmentId           INT, 
            @departmentTopId        INT,
			@docEnterNop2 int;
    DECLARE @signatureExecutorId INT, 
	@organizationIdSigner INT,
	@organizationIdCreator INT,
	@organizationIndexCreator INT,
            @creatorworkplaceId  INT,
			 @periodId       INT, @docStatus int,@docCount int; 

SELECT @docStatus=d.DocDocumentstatusId FROM dbo.DOCS d WHERE d.DocId=@docId;

if(@docStatus<>30) return;

    SELECT @creatorworkplaceId = DocInsertedById 
    FROM   dbo.DOCS 
    WHERE  docid = @docId 

   SELECT @organizationIndexCreator = Ltrim(Rtrim(o.organizationindex)) , @organizationIdCreator=o.OrganizationId--hazirliyanin
    FROM   dbo.dc_organization o 
    WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
                               FROM   dbo.dc_workplace wp 
                               WHERE  wp.workplaceid = @creatorworkplaceId); 


    SELECT @organizationIndex = Ltrim(Rtrim(o.organizationindex)) , @organizationIdSigner=o.OrganizationId
    FROM   dbo.dc_organization o 
    WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
                               FROM   dbo.dc_workplace wp 
                               WHERE  wp.workplaceid = @workPlaceId); 

     SELECT @organizationId = workplaceorganizationid            
    FROM   dbo.dc_workplace dw 
    WHERE  dw.workplaceid = @workplaceId; 
    


      
	  SELECT 
           @departmentId = dw.workplacedepartmentid 
    FROM   dbo.dc_workplace dw 
    WHERE  dw.workplaceid = @creatorworkplaceId;     

	 SELECT @periodId = dp.periodid 
        FROM   dbo.doc_period dp 
        WHERE  dp.perioddate1 <= @date 
               AND dp.perioddate2 >= @date; 
		

  if(@organizationId=1)   
   BEGIN
     SELECT @signerindex = CASE WHEN ddp.PositionGroupId=37 THEN ddp.DepartmentPositionIndex 
	WHEN ddp.PositionGroupId=17 AND ddp.DepartmentPositionIndex is not null and ddp.DepartmentPositionIndex!=''  THEN ddp.DepartmentPositionIndex   ELSE dpg.PositionGroupLevel end
    FROM   dbo.dc_department_position ddp 
           LEFT JOIN dbo.dc_position_group dpg 
                  ON ddp.positiongroupid = dpg.positiongroupid 
           LEFT JOIN dbo.dc_workplace dw 
                  ON ddp.departmentpositionid = dw.workplacedepartmentpositionid 
    WHERE  dw.workplaceid = @workPlaceId; 
 
   END
   ELSE
   BEGIN 
     SELECT @signerindex = ddp.DepartmentPositionIndex 
    FROM   dbo.dc_department_position ddp 
           LEFT JOIN dbo.dc_position_group dpg 
                  ON ddp.positiongroupid = dpg.positiongroupid 
           LEFT JOIN dbo.dc_workplace dw 
                  ON ddp.departmentpositionid = dw.workplacedepartmentpositionid 
    WHERE  dw.workplaceid = @workPlaceId; 
   END



		     SELECT @docIndex= (max( Convert(int, s.rowOrder) )+1) FROM (		
			
			SELECT  msdb.dbo.[fnRegexReplace](d.DocEnterno,'.*/(\d+)-\d+','$1') AS rowOrder,d.DocOrganizationId
			 FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK) WHERE d.DocDoctypeId=@docTypeId 
			AND d.DocEnterno IS NOT NULL AND d.DocOrganizationId= case when @organizationIndex=1 THEN d.DocOrganizationId ELSE  @organizationIdCreator end and  (d.DocEnternop1=cast(@organizationIndex AS varchar(15)) OR d.DocEnternop1 IS null) AND d.DocPeriodId = @periodId
			AND ((@periodId=3 and year(d.DocEnterdate)<>2018) OR @periodId<>3)) s

    SELECT  @printerworkplaceId= w.workplaceid 
    FROM   dc_workplace w 
           JOIN [dbo].[dc_workplace_role] wr 
             ON wr.workplaceid = w.workplaceid 
    WHERE  roleid = 245 
           AND w.workplaceorganizationid = @organizationIdSigner; 


if(@organizationIndexCreator=@organizationIndex)	
begin 
    --SELECT @docEnterno = CONVERT(NVARCHAR(max), ( SELECT 
    --                     Trim(do.organizationindex) FROM 
    --                            dbo.dc_organization do WHERE do.organizationid = 
    --                            @organizationId )) 
    --                     + '-' + CONVERT(NVARCHAR(max),@signerindex) + '-' 
    --                     + CONVERT(NVARCHAR(max), (SELECT Trim(dd.DepartmentIndex) 
    --                     FROM  dbo.dc_department dd WHERE dd.departmentid = @departmentId 
    --                            )) 
    --                     + '/' +  CONVERT(NVARCHAR(max),@docIndex) + '-' + Format(dbo.Sysdatetime(), 'yy'); 

	
	SELECT @docEnterno = CONVERT(NVARCHAR(max), ( SELECT 
            Trim(do.organizationindex) FROM 
                dbo.dc_organization do WHERE do.organizationid = 
                @organizationId )) 
            + '-' + CONVERT(NVARCHAR(max),@signerindex) + '-' 
			+ CASE WHEN ((SELECT dd.DepartmentTopId FROM dbo.DC_DEPARTMENT dd WHERE dd.DepartmentId=@departmentId)!=1085)--BTRIB rehberlik
			THEN 						 
			CONVERT(NVARCHAR(max), (SELECT Trim(dd.DepartmentIndex) 
            FROM  dbo.dc_department dd WHERE dd.departmentid = (SELECT dd.DepartmentTopId FROM dbo.DC_DEPARTMENT dd WHERE dd.DepartmentId=@departmentId)))
			+ '/'+ CONVERT(NVARCHAR(max), (SELECT Trim(dd.DepartmentIndex) 
            FROM  dbo.dc_department dd WHERE dd.departmentid = @departmentId  ))
			ELSE
            CONVERT(NVARCHAR(max), (SELECT Trim(dd.DepartmentIndex) 
            FROM  dbo.dc_department dd WHERE dd.departmentid = @departmentId 
                )) 
				end
            + '/' +  CONVERT(NVARCHAR(max),@docIndex) + '-' + Format(dbo.Sysdatetime(), 'yy'); 

 END
 ELSE BEGIN
 SELECT @docEnterno = CONVERT(NVARCHAR(max), ( SELECT 
                         Trim(do.organizationindex) FROM 
                                dbo.dc_organization do WHERE do.organizationid = 
                                @organizationId )) 
                         + '-' + CONVERT(NVARCHAR(max),@signerindex) + '-' 
                         + CONVERT(NVARCHAR(max), (SELECT 
                         Trim(do.organizationindex) FROM 
                                dbo.dc_organization do WHERE do.organizationid = 
                                @organizationIdCreator  )) 
                         + '/' +  CONVERT(NVARCHAR(max),@docIndex) + '-' + Format(dbo.Sysdatetime(), 'yy'); 

 
  END
   --SELECT  @docEnterNo1=msdb.dbo.[fnRegexReplace](@docEnterno,'.*/(\d+)-\d+','$1') ;

    SELECT @signatureExecutorId = de.executorid 
    FROM   dbo.docs_executor de 
    WHERE  de.executordocid = @docId 
           AND de.executorworkplaceid = @workPlaceId 
           AND de.executorreadstatus = 0 
           AND de.directiontypeid = 8; 
    insert into debugTable values('xaric olan ',dbo.Sysdatetime())
    UPDATE dbo.docs_executor 
    SET    executorreadstatus = 1 
    WHERE  executorid = @signatureExecutorId; 
	  
    UPDATE dbo.docoperationslog 
    SET    dbo.docoperationslog.operationstatus = 9, 
           dbo.docoperationslog.operationstatusdate = dbo.Sysdatetime(), 
           dbo.docoperationslog.operationnote = @note 
    WHERE  dbo.docoperationslog.docid = @docId 
           AND executorid = @signatureExecutorId; 
    insert into debugTable values('xaric olan  enterno ',dbo.Sysdatetime())
    UPDATE dbo.docs 
    SET    docenterno = @docEnterno, 
	dbo.docs.DocEnternop1=(SELECT 
                         Trim(do.organizationindex) FROM 
                                dbo.dc_organization do WHERE do.organizationid = 
                                @organizationId),
           docenterdate = dbo.Sysdatetime(), 
           docdocumentstatusid = 16,--İmzalanib 
           docdocumentoldstatusid = 30 
    WHERE  docid = @docId; 

    UPDATE dbo.docs_directions 
    SET    directionsendstatus = 1 
    WHERE  directiondocid = @docId 
           AND directiontypeid = 8; 

    UPDATE dbo.docs_file 
    SET    signaturestatusid = 2, 
           signaturedate = dbo.Sysdatetime() 
    WHERE  filedocid = @docId 
           AND fileismain = 1 
           AND isdeleted = 0 
           AND isreject = 0; 

    INSERT INTO docs_directions 
                (directioncreatorworkplaceid, 
                 directiondocid, 
                 directiontypeid, 
                 directionworkplaceid, 
                 directioninserteddate, 
                 directiondate, 
                 directionconfirmed, 
                 directionsendstatus) 
    VALUES      (@workPlaceId, 
                 @docId, 
                 9, 
                 @workPlaceId, 
                 dbo.Sysdatetime(), 
                 dbo.Sysdatetime(), 
                 1, 
                 1 ); 

    SET @currentDirectionId = Scope_identity(); 

    INSERT INTO dbo.docs_executor 
                (executordirectionid, 
                 executordocid, 
                 executorworkplaceid, 
                 executorfullname, 
                 executormain, 
                 directiontypeid, 
                 executorreadstatus,
				 SendStatusId) 
    VALUES      (@currentDirectionId, 
                 @docId, 
                 @printerworkplaceId, 
                 dbo.Fngetpersonnelbyworkplaceid(@printerworkplaceId, 106), 
                 0, 
                 9, 
                 0,
				 11 ); 

    SET @currentExecutorId = Scope_identity(); 

    EXEC dbo.Logdocumentoperation 
      @docId = @docId, 
      @ExecutorId = @currentExecutorId, 
      @SenderWorkPlaceId = @workPlaceId, 
      @ReceiverWorkPlaceId = @printerworkplaceId, 
      @DocTypeId = 12, 
      @OperationTypeId = 11, 
      @DirectionTypeId = 9, 
      @OperationStatusId = 1, 
      @OperationStatusDate = NULL, 
      @OperationNote = NULL; 

    SET @result = 7; 
END;

