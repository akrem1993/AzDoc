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
-- Author:  <Abdullayeva Gular>
-- Create date: <6/23/2019>
-- Description: <Get Authors for Direction>
-- =============================================
CREATE PROCEDURE [resolution].[GetExecutors]
@docId int=null,
@directionId int=null




AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 declare @confirmstatus int ,@sendstatus int,@returnedvalue int,@workplaceId int,@positiongroupId int,@directionIdEx int,@executorOrgId int,@senderOrgId int,@executorDirectionType int; 
 SELECT @directionIdEx=de.ExecutorDirectionId,@executorOrgId=ExecutorOrganizationId FROM dbo.DOCS_EXECUTOR de  WHERE de.ExecutorDocId=@docId AND de.ExecutorWorkplaceId=-( @directionId)
 select  @senderOrgId=ExecutorOrganizationId from DOCS_EXECUTOR where ExecutorDocId=@docId and DirectionTypeId=3
 SELECT @positiongroupId=ddp.PositionGroupId FROM dbo.DC_WORKPLACE dw join dbo.DC_DEPARTMENT_POSITION ddp
 ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId WHERE dw.WorkplaceId=-(@directionId)
 SELECT @executorDirectionType=DirectionTypeId FROM dbo.DOCS_EXECUTOR de WHERE de.ExecutorDocId=@docId AND  de.ExecutorWorkplaceId=-(@directionId)

  IF(@directionId=(@workplaceID))
 BEGIN 
 IF EXISTS(SELECT  ISNULL(SendStatusId,0) FROM dbo.DOCS_EXECUTOR de where (ExecutorDocId=@docId AND de.ExecutorMain=1) OR de.ExecutorDocId=@docId )
 begin
 select @sendstatus=ISNULL(SendStatusId,0) from  DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorWorkplaceId=-(@directionId)  
 and DirectionTypeId =1
 END
 ELSE BEGIN select @sendstatus=1 end
 END
  ELSE
  BEGIN
  select @sendstatus=ISNULL(SendStatusId,0) from  DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorWorkplaceId=-(@directionId)  
 and DirectionTypeId =1
   END 

   ---SECOND VERSİON
 --   IF EXISTS(SELECT  ISNULL(SendStatusId,0) FROM dbo.DOCS_EXECUTOR de where (ExecutorDocId=@docId AND de.ExecutorMain=1) AND @executorDirectionType!=18)
 --BEGIN
 --select @sendstatus= case WHEN -@directionId IN
 --(SELECT ExecutorWorkplaceId FROM dbo.DOCS_EXECUTOR de WHERE de.ExecutorDocId=@docId AND de.DirectionTypeId IN (12,11,17,18))
 --then
 -- ( select ISNULL(SendStatusId,0) from  DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorWorkplaceId=-(@directionId)  
 --and (DirectionTypeId  in (1) ))
 --else
 --0 end
 --END
 --ELSE BEGIN 
 --select @sendstatus= CASE WHEN (@positiongroupId NOT  in (1,2,33) AND (@senderOrgId=@executorOrgId)) THEN 3
 --   ELSE 1 end
 -- END


IF EXISTS( SELECT de.ExecutorDocId FROM dbo.DOCS_EXECUTOR de where ExecutorDocId=@docId AND de.ExecutorDirectionId=@directionId AND de.ExecutionstatusId=1)
BEGIN Select @returnedvalue = ISNULL(de.ExecutionstatusId,0) FROM dbo.DOCS_EXECUTOR de where ExecutorDocId=@docId AND de.ExecutorDirectionId=@directionId AND de.ExecutionstatusId=1 END
select @confirmstatus=case when (DirectionWorkplaceId =(-@directionId) or DirectionCreatorWorkplaceId=-(@directionId)) then 0 else ISNULL(DirectionConfirmed,0) end from DOCS_DIRECTIONS  dd
join Docs_Executor de on dd.DirectionId=de.ExecutorDirectionId where DirectionDocId=@docId and de.DirectionTypeId=12 
  

 if(@directionId<0)
  begin
    select DocPlannedDate,
  @returnedvalue AS DocExecutionStatus,
    @confirmstatus as DocDocumentstatusId,
    @sendstatus as DocSendStatus, 
 case when DocExecutionStatusId=3 then CONVERT(int,DocExecutionStatusId) else DirectionControlStatus end DocControlStatusId,--3 nezaret ucun
 	     CASE WHEN  DocExecutionStatusId IS NULL THEN 0 ELSE DocExecutionStatusId END DocExecutionStatusId,
    dd.DirectionTypeId
    from DOCS  d
    join DOCS_DIRECTIONS dd on  dd.DirectionDocID=d.DocId where DocId=@docId

    order by DirectionId desc
  end 
 else
  begin 
       select dbo.sysdatetime() as DirectionDate, DirectionId,
       DirectionWorkplaceId,
       0 DirectionControlStatus,
     case when DocExecutionStatusId=3 then CONVERT(int,DocExecutionStatusId) else DirectionControlStatus end DocControlStatusId,--3 nezaret ucun
       case when @directionId<0 then DocPlannedDate else DirectionPlanneddate end as DocPlannedDate,
	 	CASE WHEN  DocExecutionStatusId IS NULL THEN 0 ELSE DocExecutionStatusId END DocExecutionStatusId,
       dd.DirectionTypeId 
       from DOCS dc
       join  DOCS_DIRECTIONS dd on dd.DirectionDocId=dc.DocId 
       left join DC_WORKPLACE dw on dw.WorkplaceId=dd.DirectionWorkplaceId
       where  (@docId is null or  DocId=@docId) or  (DirectionId=@directionId )
    order by DirectionId desc
     end




 

END

