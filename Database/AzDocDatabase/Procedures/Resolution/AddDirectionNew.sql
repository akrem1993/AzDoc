/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/


-- ============================================= 
-- Author: A.Kamran,A.Gular    
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [resolution].[AddDirectionNew] 
@operationtype               INT,
@directionDate DATETIME=NULL, 
@directionDocId              INT =NULL, 
@directionTypeId             INT =NULL, 
@directionWorkplaceId        INT =NULL, 
@directionInsertedDate       DATETIME=NULL, 
@directionPersonFullName     NVARCHAR(500)=NULL, 
@directionCreatorWorkplaceId INT =NULL,
--@directionPersonId int null, 
--@directionTemplateId int null, 
@directionControlStatus      BIT=NULL, 
@directionPlanneddate        DATETIME=NULL, 
--@directionVizaId int, 
@directionConfirmed          TINYINT =NULL, 
@directionSendStatus         BIT =NULL, 
@directionUnixTime           BIGINT =NULL, 
@directionId                 INT= 0, 
@executorList [dbo].[UDTTDIRECTIONEXECUTOR] readonly 
 
AS 
  BEGIN  
      SET nocount ON; 
   
     declare @mainworkplaceId int; 
          declare @executorTopId int;
   

      IF ( @operationtype = 1 ) --insert    
   
            BEGIN 
            BEGIN try 
          BEGIN TRAN          
    
                    --rollback 
                --return; 
    ---------------------------------------------------------------------
    declare @sendStatusId int 
    select @sendStatusId=isnull(SendStatusId,0),@directionId=case SendStatusId when 15 then ExecutorDirectionId else @directionId end from DOCS_EXECUTOR 
    where ExecutorWorkplaceId=@directionWorkplaceId and ExecutorDocId=@directionDocId;
    if @sendStatusId=15
    begin
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
                             executorstepid, 
                             executionstatusid, 
                             executornote, 
                             executorreadstatus, 
                             executorresolutionnote, 
                             sendstatusid,
        executorTopId,
		ExecutorControlStatus
        ) 
                SELECT @directionId     DirectionId, 
                       @directionDocId  DirectionDocId, 
                       executorworkplaceid, 
                       executorfullname, 
                       CASE sendstatusid 
                         WHEN 1 THEN 1 
                         ELSE 0 
                       END              DirectionSendStatus 
                       /*@directionSendStatus*/ 
                       , 
                       @directionTypeId DirectionTypeId, 
                       executororganizationid, 
                       executortopdepartment, 
                       executordepartment, 
                       executorsection, 
                       executorsubsection, 
                       executorstepid, 
                       executionstatusid, 
                       executornote, 
                       0 ExecutorReadStatus, 
                       executorresolutionnote, 
                       sendstatusid ,
        @executorTopId
		,0
                 FROM   @executorList;

     update DOCS_EXECUTOR set SendStatusId=5 where ExecutorWorkplaceId=@directionWorkplaceId and ExecutorDocId=@directionDocId; 
     update DOCS_DIRECTIONS 
     set DirectionPlanneddate=@directionPlanneddate
     ,DirectionDate=case when @directionDate is null then DirectionDate else @directionDate end 
     where DirectionId=@directionId; 
     goto redirection;
    end
    ---------------------------------------------------------------------

    SELECT @executorTopId=case when de.ExecutorTopId is null then de.ExecutorId else de.ExecutorTopId end FROM dbo.DOCS_EXECUTOR de 
    WHERE de.ExecutorDocId=@directionDocId AND de.ExecutorWorkplaceId=@directionWorkplaceId AND de.SendStatusId=1 AND de.ExecutorReadStatus=0
                INSERT [dbo].[docs_directions] 
                       ([directiondocid], 
                        [directiondate], 
                        [directionworkplaceid], 
                        --[DirectionPersonId],  
                        [directionpersonfullname], 
                        --[DirectionTemplateId], 
                        [directiontypeid], 
                        [directioncontrolstatus], 
                        [directionplanneddate], 
                        [directionplannedday], 
                        [directionexecutionstatusid], 
                        --[DirectionVizaId], 
                        [directionconfirmed], 
                        [directionsendstatus], 
                        [directioncreatorworkplaceid], 
                        [directioninserteddate], 
                        [directionunixtime]) 
                VALUES (@directiondocId, 
                        @directionDate, 
                        @directionWorkplaceId,/* @directionPersonId,*/ 
                        @directionPersonFullName,/* @directionTemplateId,*/ 
                        @directionTypeId, 
                        @directionControlStatus, 
                        @directionPlanneddate, 
                        NULL, 
                        NULL,/* @directionVizaId,*/ 
                        @directionConfirmed, 
                        @directionSendStatus, 
                        @directionCreatorWorkplaceId, 
						dbo.sysdatetime(),-- @directionInsertedDate, 
                        @directionUnixTime) 

                SET @directionId = Scope_identity() 
    
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
                             executorstepid, 
                             executionstatusid, 
                             executornote, 
                             executorreadstatus, 
                             executorresolutionnote, 
                             sendstatusid,
        executorTopId,
		ExecutorControlStatus
        ) 
                SELECT @directionId     DirectionId, 
                       @directionDocId  DirectionDocId, 
                       executorworkplaceid, 
                       executorfullname, 
                       CASE sendstatusid 
                         WHEN 1 THEN 1 
                         ELSE 0 
                       END              DirectionSendStatus 
                       /*@directionSendStatus*/ 
                       , 
                       @directionTypeId DirectionTypeId, 
                       executororganizationid, 
                       executortopdepartment, 
                       executordepartment, 
                       executorsection, 
                       executorsubsection, 
                       executorstepid, 
                       executionstatusid, 
                       executornote, 
                       0                ExecutorReadStatus, 
                       executorresolutionnote, 
                       sendstatusid ,
      @executorTopId,
	  0

                FROM   @executorList 
                UNION 
                SELECT @directionId             DirectionId, 
                       @directionDocId          DirectionDocId, 
                       @directionWorkplaceId    DirectionWorkplaceId, 
                       @directionPersonFullName ExecutorFullName, 
                       0                        DirectionSendStatus, 
                       12                       DirectionTypeId, 
                       NULL                     ExecutorOrganizationId, 
                       NULL                     ExecutorTopDepartment, 
                       NULL                     ExecutorDepartment, 
                       NULL                     ExecutorSection, 
                       NULL                     ExecutorSubsection, 
                       NULL                     ExecutorStepId, 
                       NULL                     ExecutionstatusId, 
                       NULL                     ExecutorNote, 
                       0                        ExecutorReadStatus, 
                       NULL                     ExecutorResolutionNote, 
                       5                        SendStatusId ,
        NULL                     ExecutorTopId,
		0 ExecutorControlStatus
               WHERE  @directionWorkplaceId != @directionCreatorWorkplaceId 
    redirection:--Eli mlmin sildiyi derkanarin yeniden yaradilmasi
     COMMIT 
      END try 

      BEGIN catch 
          IF @@trancount > 0 
            ROLLBACK 

          SELECT Error_message() 
      END catch 
            END 





      IF( @operationtype = 2 )--update directionsendauthor if @directionId>0 
        BEGIN 
     
          
            DECLARE @workplace INT 
            DECLARE @executorId INT 
      SET @executorId=(SELECT executorid 
                             FROM   docs_executor 
                             WHERE  executordirectionid = @directionId 
                                    AND executorworkplaceid = 
                                        @directionWorkplaceId) 
            SET @workplace = (SELECT directionworkplaceid 
                              FROM   docs_directions 
                              WHERE  directionid = @directionId) 
            
            UPDATE [dbo].[docs_directions] 
            SET    directionsendstatus = @directionSendStatus/*@1*/, 
                   directiondate = dbo.SYSDATETIME() ,
				   DirectionTypeId = case when DirectionTypeId=20 then 1 else DirectionTypeId end-- ali mallim imtina etdiyi hal ucun 
            --DirectionConfirmed=case when DirectionWorkplaceId=@directionWorkplaceId then @directionConfirmed/*1*/  else DirectionConfirmed end
            WHERE  directionid = @directionId; 

            UPDATE dbo.docs_executor 
            SET    executorreadstatus = 1,
    ExecutorControlStatus=1--@directionconfirmed end  
            --set ExecutorReadStatus=@directionConfirmed 
            WHERE  executorworkplaceid = @directionCreatorWorkplaceId 
                   AND executordocid = @directionDocId  
        and DirectionTypeId =11  

       --eli
   UPDATE dbo.docs_executor 
            SET    executorreadstatus = 0,
    ExecutorControlStatus=0--@directionconfirmed end  
            --set ExecutorReadStatus=@directionConfirmed 
            WHERE  executorworkplaceid = @workplace 
                   AND executordocid = @directionDocId     

            EXEC dbo.Logdocumentoperation 
              @docId = @directiondocId,  
              @ExecutorId = @executorId, 
              @SenderWorkPlaceId = @directionCreatorWorkplaceId, 
              @ReceiverWorkPlaceId =@workplace, 
              @DocTypeId = 1, 
              @OperationTypeId = 5, 
              @DirectionTypeId = 12, 
              @OperationStatusId = 1, 
              @OperationStatusDate = NULL,--temp 
              @OperationNote = Null 

        END 


      IF( @operationtype = 3 )--update directionconfirm 
        BEGIN 
		declare @directionControl      BIT=NULL;
IF EXISTS (SELECT * FROM dbo.DOCS_EXECUTOR de WHERE  de.ExecutorDocId=@directionDocId AND de.DirectionTypeId=1 AND de.SendStatusId in (1,2))
BEGIN
 update DOCS set DocDocumentstatusId= 1  /*Execution(1)*/ 
 where DocId=@directionDocId
END  ELSE
IF  EXISTS (SELECT * FROM dbo.DOCS_EXECUTOR de WHERE  de.ExecutorDocId=@directionDocId AND de.DirectionTypeId=1 AND de.SendStatusId NOT in (1,2))
BEGIN 
update DOCS set DocDocumentstatusId= 33  /*Execution(1)*/ 
 where DocId=@directionDocId 
 END

          
            UPDATE [dbo].[docs_directions] 
            SET    directionsendstatus = 1/*@1*/,
			  directionconfirmed = 1  ,
                   directiondate = dbo.SYSDATETIME()                 
            WHERE  directionid = @directionId /*1*/  
	select @directionControl=DirectionControlStatus from [dbo].[docs_directions] where DirectionId=@directionId  
	if(@directionControl=1)
	begin update DOCS set DocExecutionStatusId=3 where DocId=@directionDocId end --yalniz Ali mellim tesdig etdiyi halda nezaret qnv-ye duwur
   Update  [dbo].[docs_directions] 
   /*DMSMigrate3- melumat ucun gonderilme */
   set DirectionConfirmed=1 where DirectionDocId=@directionDocId and DirectionWorkplaceId=@directionWorkplaceId and DirectionTypeId=2   
   select @mainworkplaceId=DirectionWorkplaceId from DOCS_DIRECTIONS where DirectionId=@directionId
            --DirectionConfirmed=case when DirectionWorkplaceId=@directionWorkplaceId then @directionConfirmed/*1*/  else DirectionConfirmed
            UPDATE dbo.docs_executor 
            SET    executorreadstatus = 1,
   ExecutorControlStatus=1
            --set ExecutorReadStatus=@directionConfirmed 
            WHERE ( executordirectionid = @directionId 
                   AND executorworkplaceid = @directionWorkplaceId  ) or (ExecutorWorkplaceId=@mainworkplaceId and ExecutorDocId=@directionDocId)

            INSERT INTO dbo.docoperationslog 
                        (docid, 
                         executorid, 
                         senderworkplaceid, 
                         receiverworkplaceid, 
                         doctypeid, 
                         operationtypeid, 
                         directiontypeid, 
                         operationstatus, 
                         operationstatusdate, 
                         operationnote, 
                         operationdate) 
            SELECT @directionDocId, 
                   executorid, 
                   @directionWorkplaceId, 
                   executorworkplaceid, 
                   1, 
                   sendstatusid, 
                   sendstatusid, 
                   1, 
                   NULL, 
                   ExecutorResolutionNote, 
                   dbo.SYSDATETIME() 
            FROM   docs_executor de
   left join DC_WORKPLACE dw on dw.WorkplaceId=de.ExecutorWorkplaceId
  left join [DC_DEPARTMENT_POSITION] dp on dp.DepartmentPositionId=dw.WorkplaceDepartmentPositionId
    left join DC_DEPARTMENT dd on dp.DepartmentId=dd.DepartmentId
    left join DC_POSITION_GROUP dg on dg.PositionGroupId=dp.PositionGroupId
            WHERE  executordirectionid = @directionId 
                   AND executorworkplaceid != @directionWorkplaceId 
      -- order by DepartmentOrganization,dg.PositionGroupId,de.sendstatusid
   order by de.sendstatusid,dg.PositionGroupId
        END 

      IF( @operationtype = 4 )--update directionunconfirm 
        BEGIN 
   update DOCS set DocDocumentstatusId=8/*SendToPerson(8)*/ where DocId=@directionDocId/*DMSMigrate3*/
            UPDATE [dbo].[docs_directions] 
            SET    directionsendstatus = @directionSendStatus/*@1*/, 
                   directiondate = dbo.SYSDATETIME(), 
                   directionconfirmed = @directionConfirmed ,
				   DirectionTypeId=20--dərkənardan imtina
            WHERE  directionid = @directionId /*1*/ 

            --DirectionConfirmed=case when DirectionWorkplaceId=@directionWorkplaceId then @directionConfirmed/*1*/  else DirectionConfirmed
            UPDATE dbo.docs_executor 
            --ExecutorReadStatus=0 
            SET    executorreadstatus = 1 ,
   executorcontrolstatus=1
            WHERE  executordirectionid = @directionId 
                   AND executorworkplaceid = @directionWorkplaceId; 
        UPDATE dbo.docs_executor 
            --ExecutorReadStatus=0 
            SET    executorreadstatus = 0 ,
   executorcontrolstatus=0
            WHERE  ExecutorDocId=(select distinct ExecutorDocId from DOCS_EXECUTOR where   ExecutorDirectionId=@directionId )
                   AND executorworkplaceid = @directionCreatorWorkplaceId; 

            INSERT INTO dbo.docoperationslog 
                        (docid, 
                         executorid, 
                         senderworkplaceid, 
                         receiverworkplaceid, 
                         doctypeid, 
                         operationtypeid, 
                         directiontypeid, 
                         operationstatus, 
                         operationstatusdate, 
                         operationnote, 
                         operationdate) 
            SELECT executordocid, 
                   executorid, 
                   @directionWorkplaceId, 
                   @directionCreatorWorkplaceId, 
                   1, 
                   18,--sendstatusid, 
                   21,--sendstatusid, 
                   1, 
                   NULL, 
                   NULL, 
                   dbo.SYSDATETIME() 
            FROM   docs_executor 
            WHERE  executordirectionid = @directionId 
                   AND executorworkplaceid = @directionWorkplaceId 
       --DirectionTypeId=11
        END 
  END

