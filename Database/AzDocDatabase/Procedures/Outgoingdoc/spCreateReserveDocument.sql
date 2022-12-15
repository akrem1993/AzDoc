/*
Migrated by Kamran A-eff 23.08.2019
*/



CREATE PROCEDURE [outgoingdoc].[spCreateReserveDocument] 
@operationType       INT, 
@workPlaceId         INT= NULL, 
@departmentId INT=NULL,
@docTypeId           INT= NULL, 
@docDeleted          INT= NULL, 
@documentStatusId    INT= NULL, 
@signatoryPersonId   INT= NULL,     
@shortContent        NVARCHAR(MAX) = NULL,  
@docEnterDate        DATE= NULL, --@docDocDate
@formTypeId          INT = NULL,  
@rowId               INT = NULL,                                             
--@taskId              INT= NULL, 
@docId               INT= NULL OUTPUT, 
@result              INT OUTPUT
AS
BEGIN try 
    BEGIN 
        SET nocount ON; 
    	SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on

        DECLARE @date                      DATE= dbo.Sysdatetime(), 
                @organizationId            INT, 
                @periodId                  INT, 
                @orgId                     INT, 
                @docEnterno                NVARCHAR(30)= NULL, 
                @docIndex                  INT, 
                @documentOldStatus         INT, 
                @signerindex               NVARCHAR(25)= NULL, 
                @answerCount               INT= 0, 
                @executorFullName          NVARCHAR(max)=NULL, 
                @departmentOrganization    INT=NULL, 
                @departmentTopDepartmentId INT=NULL, 
                @departmentIdExecutor      INT=NULL, 
                @departmentSectionId       INT=NULL, 
                @departmentSubSectionId    INT=NULL, 
                @organizationIndex         INT=NULL, 
                @mailerworkplaceId         INT=NULL, 
                @printerworkplaceId        INT=NULL, 
                @depWorkplaceId            INT=NULL, 
				@departmentIndex           INT=NULL,
                @directionId               INT=NULL; 

        --Period    
        SELECT @periodId = dp.periodid 
        FROM   doc_period dp 
        WHERE  dp.perioddate1 <= @date 
               AND dp.perioddate2 >= @date; 

        -- Organization Id    
        SELECT @orgId = (SELECT dbo.Fnpropertybyworkplaceid(@workPlaceId, 12)); 

        --1  
        --SELECT @docIndex = ( Count(0) + 1 ) 
        --FROM   dbo.docs d with(tablockx,holdlock)
        --WHERE  d.docdoctypeid = @docTypeId; 
		    SELECT @docIndex = ( Count(0) + 1 ) 
    FROM   dbo.VW_DOC_INFO  d with(tablockx,holdlock)
    WHERE  d.docdoctypeid = @docTypeId 
	AND d.DocPeriodId=@periodId
           AND docenterno IS NOT NULL; 

        SELECT @documentOldStatus = d.DocDocumentstatusId 
        FROM  dbo.docs d 
        WHERE  d.docid = @docId 

        SELECT @signerindex = dpg.positiongrouplevel 
        FROM   dbo.dc_department_position ddp 
               LEFT JOIN dbo.dc_position_group dpg 
                      ON ddp.positiongroupid = dpg.positiongroupid 
               LEFT JOIN dbo.dc_workplace dw 
                      ON ddp.departmentpositionid = 
                         dw.workplacedepartmentpositionid 
        WHERE  dw.workplaceid = @signatoryPersonId; --2imza eden wexsin indexi   

      IF EXISTS ( SELECT dd.DepartmentId
                             FROM 
                                    dbo.dc_department dd WHERE dd.departmentid = 
                             @departmentId
                                    )
									BEGIN
									select @departmentIndex=dd.departmentindex
                             FROM 
                                    dbo.dc_department dd WHERE dd.departmentid =  @departmentId 
                                      END ELSE
									BEGIN
									select @departmentIndex=do.OrganizationIndex
                             FROM 
                                    dbo.DC_ORGANIZATION do  WHERE do.OrganizationId =@departmentId 
							  END 
        SELECT @docEnterno = CONVERT(NVARCHAR(max), ( SELECT 
                             Trim(do.organizationindex) FROM 
                                    dbo.dc_organization do WHERE 
                             do.organizationid = 
                             @orgId )) 
                                    + '-' 
                             + CONVERT(NVARCHAR, @signerindex) + '-' 
                             + CONVERT(NVARCHAR(max), @departmentIndex) 
                             + '/' + CONVERT(NVARCHAR, @docIndex) + '-' 
                             + (SELECT Format(dbo.Sysdatetime(), 'yy')); 

        EXEC [dbo].[Spcreatedocument] 
          @docTypeId=@docTypeId,--senedin tipi  
          @docDeleted=@docDeleted,--  
          @workPlaceId=@workPlaceId, 
          @docId=@docId out, 
          @result = @result out; 

        UPDATE dbo.docs 
        SET    docdocdate = @docEnterDate, 
               --docreceivedformid = @sendFormId,   
               -- docformid = @typeOfDocumentId,   
               docenterno = @docEnterno ,
               docdocumentstatusid = 36 --reserve sened 
        -- docdescription = @shortContent,   
        -- docdeleted = @docDeleted,   
        -- docdeletedbydate = Sysdatetime(),   
        -- docdocumentoldstatusid = (SELECT d.docdocumentstatusid   
        --  FROM   docs d   
        -- WHERE  d.docid = @docId)   
        WHERE  docid = @docId 

        INSERT INTO dbo.docs_addressinfo 
                    (adrdocid, 
                     adrtypeid, 
                     adrorganizationid, 
                     adrauthorid, 
                     adrauthordepartmentname, 
                     adrpersonid, 
                     adrpositionid, 
                     adrundercontrol, 
                     adrundercontroldays, 
                     fullname, 
                     adrsendstatusid) 
        VALUES      (@docId, 
                     1, 
                     CONVERT(INT, (SELECT 
                     [dbo].[Fngetpersonneldetailsbyworkplaceid](20, 
                     3))), 
                     NULL, 
                     CONVERT(NVARCHAR(max), (SELECT 
        [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 
        2))) 
        , 
        @signatoryPersonId, 
        NULL, 
        0, 
        0, 
        CONVERT(NVARCHAR(max), (SELECT 
        [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 
        1))) 
        , 
        NULL) 
		insert into debugTable values('adresinfo',dbo.SYSDATETIME())
        --------------------------------------------Imza eden wexsde gorunmesi---------------------------------------- 
        SELECT @departmentOrganization = d.departmentorganization, 
               @departmentTopDepartmentId = d.departmenttopdepartmentid, 
               @departmentIdExecutor = d.departmentid, 
               @departmentSectionId = d.departmentsectionid, 
               @departmentSubSectionId = d.departmentsubsectionid 
        FROM   dbo.dc_workplace w 
               JOIN dbo.dc_department_position dp 
                 ON w.workplacedepartmentpositionid = dp.departmentpositionid 
               JOIN dbo.dc_department d 
                 ON dp.departmentid = d.departmentid 
        WHERE  w.workplaceid = @signatoryPersonId--imza eden wexs 
        SELECT @directionId = directionid 
        FROM   dbo.docs_directions 
        WHERE  directiondocid = @docId 

        SELECT @executorFullName = (SELECT CONVERT(NVARCHAR(max), 
               (SELECT 
               [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 1)))); 

        INSERT INTO dbo.docs_executor 
                    (executordirectionid, 
                     executordocid, 
                     executorworkplaceid, 
                     executorfullname, 
                     executormain, 
                     directiontypeid, 
                     executororganizationid, 
                     executortopdepartment, 
                     executordepartment, 
                     executorsection, 
                     executorsubsection, 
                     executorreadstatus,
					 executorstatus) 
        VALUES      ( @directionId, 
                      @docId, 
                      @signatoryPersonId, 
                      @executorFullName, 
                      0, 
                      8, 
                      @departmentOrganization, 
                      @departmentTopDepartmentId, 
                      @departmentIdExecutor, 
                      @departmentSectionId, 
                      @departmentSubSectionId, 
                      0,
					  1 ); 
	insert into debugTable values('signatory',dbo.SYSDATETIME())
        ---------------------------------------------------------------------------------------------------------------- 
        ---------------------------------------------POCHT eden wexsde gorunmesi---------------------------------------- 
        SELECT @organizationIndex = Ltrim(Rtrim(o.organizationindex)) 
        FROM   dbo.dc_organization o 
        WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
                                   FROM   dbo.dc_workplace wp 
                                   WHERE  wp.workplaceid = @workPlaceId); 

        SELECT @mailerworkplaceId = w.workplaceid 
        FROM   dbo.dc_workplace w 
               JOIN [dbo].[dc_workplace_role] wr 
                 ON wr.workplaceid = w.workplaceid 
        WHERE  roleid = 243 
               AND w.workplaceorganizationid = @organizationIndex 

        SELECT @departmentOrganization = d.departmentorganization, 
               @departmentTopDepartmentId = d.departmenttopdepartmentid, 
               @departmentIdExecutor = d.departmentid, 
               @departmentSectionId = d.departmentsectionid, 
               @departmentSubSectionId = d.departmentsubsectionid 
        FROM   dbo.dc_workplace w 
               JOIN dbo.dc_department_position dp 
                 ON w.workplacedepartmentpositionid = dp.departmentpositionid 
               JOIN dbo.dc_department d 
                 ON dp.departmentid = d.departmentid 
        WHERE  w.workplaceid = @mailerworkplaceId--imza eden wexs 
        SELECT @directionId = directionid 
        FROM   dbo.docs_directions 
        WHERE  directiondocid = @docId 

        SELECT @executorFullName = (SELECT CONVERT(NVARCHAR(max), 
               (SELECT 
               [dbo].[Fngetpersonneldetailsbyworkplaceid](@mailerworkplaceId, 1)))); 

        INSERT INTO dbo.docs_executor 
                    (executordirectionid, 
                     executordocid, 
                     executorworkplaceid, 
                     executorfullname, 
                     executormain, 
                     directiontypeid, 
                     executororganizationid, 
                     executortopdepartment, 
                     executordepartment, 
                     executorsection, 
                     executorsubsection, 
                     executorreadstatus,
					 executorstatus) 
        VALUES      ( @directionId, 
                      @docId, 
                      @mailerworkplaceId, 
                      @executorFullName, 
                      0, 
                      10, 
                      @departmentOrganization, 
                      @departmentTopDepartmentId, 
                      @departmentIdExecutor, 
                      @departmentSectionId, 
                      @departmentSubSectionId, 
                      0,
					  1 ); 
insert into debugTable values('@mailerworkplaceId',dbo.SYSDATETIME())
        ---------------------------------------------------------------------------------------------------------------- 
        ---------------------------------------------CHAP eden wexsde gorunmesi---------------------------------------- 
        SELECT @organizationIndex = Ltrim(Rtrim(o.organizationindex)) 
        FROM   dbo.dc_organization o 
        WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
                                   FROM   dbo.dc_workplace wp 
                                   WHERE  wp.workplaceid = @workPlaceId); 

        SELECT @printerworkplaceId = w.workplaceid 
        FROM   dbo.dc_workplace w 
               JOIN [dbo].[dc_workplace_role] wr 
                 ON wr.workplaceid = w.workplaceid 
        WHERE  roleid = 245 
               AND w.workplaceorganizationid = 1; 

        SELECT @departmentOrganization = d.departmentorganization, 
               @departmentTopDepartmentId = d.departmenttopdepartmentid, 
               @departmentIdExecutor = d.departmentid, 
               @departmentSectionId = d.departmentsectionid, 
               @departmentSubSectionId = d.departmentsubsectionid 
        FROM   dbo.dc_workplace w 
               JOIN dbo.dc_department_position dp 
                 ON w.workplacedepartmentpositionid = dp.departmentpositionid 
               JOIN dbo.dc_department d 
                 ON dp.departmentid = d.departmentid 
        WHERE  w.workplaceid = @printerworkplaceId--imza eden wexs 
        SELECT @directionId = directionid 
        FROM   dbo.docs_directions 
        WHERE  directiondocid = @docId 

        SELECT @executorFullName = (SELECT CONVERT(NVARCHAR(max), (SELECT 
    [dbo].[Fngetpersonneldetailsbyworkplaceid](@printerworkplaceId, 1)))); 

        INSERT INTO dbo.docs_executor 
                    (executordirectionid, 
                     executordocid, 
                     executorworkplaceid, 
                     executorfullname, 
                     executormain, 
                     directiontypeid, 
                     executororganizationid, 
                     executortopdepartment, 
                     executordepartment, 
                     executorsection, 
                     executorsubsection, 
                     executorreadstatus,
					 executorstatus) 
        VALUES      ( @directionId, 
                      @docId, 
                      @printerworkplaceId, 
                      @executorFullName, 
                      0, 
                      9, 
                      @departmentOrganization, 
                      @departmentTopDepartmentId, 
                      @departmentIdExecutor, 
                      @departmentSectionId, 
                      @departmentSubSectionId, 
                      0 ,
					  1); 
					  insert into debugTable values('@@printerworkplaceId',dbo.SYSDATETIME())
        ---------------------------------------------------------------------------------------------------------------- 
        ---------------------------------------------Şöbə müdirində gorunmesi---------------------------------------- 
        SELECT @depWorkplaceId = w.workplaceid 
        FROM   dbo.dc_department d 
               JOIN dbo.dc_department_position dp 
                 ON d.departmentid = dp.departmentid 
               JOIN dbo.dc_workplace w 
                 ON w.workplacedepartmentpositionid = dp.departmentpositionid 
        WHERE  dp.positiongroupid IN ( 17, 26 ) 
               --(17=SectionChief,26=SectorChief)  
               AND dp.departmentid = @departmentId 
        ORDER  BY dp.positiongroupid DESC; 

        SELECT @departmentOrganization = d.departmentorganization, 
               @departmentTopDepartmentId = d.departmenttopdepartmentid, 
               @departmentIdExecutor = d.departmentid, 
               @departmentSectionId = d.departmentsectionid, 
               @departmentSubSectionId = d.departmentsubsectionid 
        FROM   dbo.dc_workplace w 
               JOIN dbo.dc_department_position dp 
                 ON w.workplacedepartmentpositionid = dp.departmentpositionid 
               JOIN dbo.dc_department d 
                 ON dp.departmentid = d.departmentid 
        WHERE  w.workplaceid = @depWorkplaceId--imza eden wexs 
        SELECT @directionId = directionid 
        FROM   dbo.docs_directions 
        WHERE  directiondocid = @docId 

        SELECT @executorFullName = (SELECT CONVERT(NVARCHAR(max), (SELECT 
[dbo].[Fngetpersonneldetailsbyworkplaceid](@depWorkplaceId, 1)))); 

INSERT INTO dbo.docs_executor 
     (executordirectionid, 
      executordocid, 
      executorworkplaceid, 
      executorfullname, 
      executormain, 
      directiontypeid, 
      executororganizationid, 
      executortopdepartment, 
      executordepartment, 
      executorsection, 
      executorsubsection, 
      executorreadstatus,
	 ExecutorStatus) 
VALUES      ( @directionId, 
       @docId, 
       @depWorkplaceId, 
       @executorFullName, 
       0, 
       4, 
       @departmentOrganization, 
       @departmentTopDepartmentId, 
       @departmentIdExecutor, 
       @departmentSectionId, 
       @departmentSubSectionId, 
       0 ,
	   1); 
	     insert into debugTable values('@@@depWorkplaceId',dbo.SYSDATETIME())
---------------------------------------------------------------------------------------------------------------- 
SET @docId = Scope_identity(); 

IF @@ERROR = 0 
BEGIN 
SET @result = 1; -- 1 IS FOR SUCCESSFULLY EXECUTED    
END; 
ELSE 
BEGIN 
SET @result = 0; -- 0 WHEN AN ERROR HAS OCCURED    
END; 
END; 
END try 

BEGIN catch 
    INSERT INTO dbo.debugtable 
                ( 
    --id - column value is auto-generated   
    [text], 
                 insertdate) 
    VALUES      ( 
    -- id - int   
    '[outgoingdoc].[spDocsOperation]' 
    + Error_message(),-- text - nvarchar   
    dbo.Sysdatetime() -- insertDate - datetime   
    ) 
END catch 

