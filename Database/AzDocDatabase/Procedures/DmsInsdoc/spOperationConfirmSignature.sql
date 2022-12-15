/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spOperationConfirmSignature]
@docId int,
@docTypeId int,
@workPlaceId int,
@note nvarchar(max)=null,
@result int output 
as
begin
    set nocount on;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on

    declare
 @docIndex nvarchar(20)=null,
 @organizationIndex int,
 @docEnterno nvarchar(20)=null,
 @date date=dbo.SYSDATETIME(),
 @directionId int,
 @confirmWorkPlaceId int=0,
 @executorFullName nvarchar(max),
 @executorOrganizationId int,
 @executorDepartmentId int,
 @vizaId int,
 @fileId int,
  @taskDocNo nvarchar(max),
  @taskCount int,
  @taskId int,
  @taskTypeOfAssignment int,
@docStatus int,
 @periodId INT;
 
 SELECT @periodId = dp.PeriodId
        FROM DOC_PERIOD dp
        WHERE dp.PeriodDate1 <= @date
              AND dp.PeriodDate2 >= @date;
SELECT @docStatus=d.DocDocumentstatusId FROM dbo.DOCS d WHERE d.DocId=@docId;

if(@docStatus<>30) return;

 select @docIndex=(
SELECT df.FormIndex FROM dbo.DOC_FORM df WHERE df.FormId=(
  SELECT d.DocFormId FROM dbo.DOCS d WHERE d.DocId=@docId));
   
  SELECT
   @organizationIndex=o.OrganizationIndex 
   from dbo.DC_ORGANIZATION o 
   where o.OrganizationId=(select wp.WorkplaceOrganizationId from dbo.DC_WORKPLACE wp where wp.WorkplaceId=@workPlaceId)

  select @docEnterno = (select @docIndex) + '-'+
       CONVERT(nvarchar(max), @organizationIndex) + '/' + 
       CONVERT(varchar(max), (select d.DocEnternop2 from dbo.VW_DOC_INFO d where d.DocId=@docId AND d.DocPeriodId=@periodId)) + '-' + 
       (SELECT  FORMAT(@date, 'yy'))
              
     
    DECLARE @signatureExecutorId int;

 SELECT @signatureExecutorId=de.ExecutorId FROM dbo.DOCS_EXECUTOR de 
 WHERE 
 de.ExecutorDocId=@docId 
 AND de.ExecutorWorkplaceId=@workPlaceId 
 AND de.ExecutorReadStatus=0
 AND de.DirectionTypeId=8;

 update dbo.DOCS_EXECUTOR 
 set 
 ExecutorReadStatus=1 
 where 
 ExecutorId =@signatureExecutorId;

 update dbo.DocOperationsLog 
 set 
 dbo.DocOperationsLog.OperationStatus=9,
 dbo.DocOperationsLog.OperationStatusDate=dbo.SYSDATETIME(),
 dbo.DocOperationsLog.OperationNote=@note
 where 
 dbo.DocOperationsLog.DocId=@docId
 and ExecutorId =@signatureExecutorId;

   update dbo.DOCS 
  set DocEnterno=@docEnterno,
  DocEnterdate=dbo.SYSDATETIME(),
  DocDocumentstatusId=16, --İmzalanib
  DocDocumentOldStatusId=30
  where DocId=@docId;
  
  update dbo.DOCS_DIRECTIONS 
   set DirectionSendStatus=1
   where DirectionDocId=@docId and DirectionTypeId=8;
       
    update dbo.DOCS_FILE 
   set SignatureStatusId=2,
   SignatureDate=dbo.SYSDATETIME()
    where 
    FileDocId=@docId 
    and FileIsMain=1
    and IsDeleted=0
    and IsReject=0;
    
    select @taskCount=count(0) from dbo.DOC_TASK t with(tablockx,holdlock) where t.TaskDocId=@docId ;
    while(@taskCount>0)
    begin
      select @taskId=max(Task.TaskId),@taskTypeOfAssignment=max(Task.TaskNo) from ( select top (select @taskCount) * from dbo.DOC_TASK t where t.TaskDocId=@docId AND t.TaskDocNo IS NULL) Task;
      select @organizationIndex=o.OrganizationIndex from dbo.DC_ORGANIZATION o 
    where o.OrganizationId=(select wp.WorkplaceOrganizationId from dbo.DC_WORKPLACE wp
           where wp.WorkplaceId= (select t.WhomAddressId from dbo.DOC_TASK t where t.TaskId=@taskId))
      select @taskDocNo=(select @docIndex) + '-' + 
                        CONVERT(nvarchar(max), @organizationIndex) + '/' + 
                        CONVERT(varchar(max), (select count(0) + 1 from dbo.DOCS d with(tablockx,holdlock) where d.DocDoctypeId=@docTypeId)) + '-' +
                        (SELECT  FORMAT(@date, 'yy')+'/'+Convert(nvarchar(max),@taskTypeOfAssignment));
     
    
       update dbo.DOC_TASK SET
        TaskDocNo=@taskDocNo
        where TaskDocId=@docId and TaskId=@taskId;
       set @taskCount-=1;
    end 

     
  

  select @confirmWorkPlaceId=a.AdrPersonId from DOCS_ADDRESSINFO a where a.AdrDocId=@docId and a.AdrTypeId=2; --Tesdiq eden shexs
  if(@confirmWorkPlaceId=0) -- Təsdiq edən şəxs yoxdu
  begin  
        EXEC dms_insdoc.spOperationTask 
          @docId = @docId,
          @docTypeId = @docTypeId,
          @workPlaceId = @workPlaceId,
          @result = @result out;
          set @result=@result;
  end
  else --Təsdiq edən şəxs var.. Onda təsdiq edən şəxsə getsin
  begin
          EXEC dms_insdoc.spSendToConfirmedPerson 
                  @docId = @docId,
                  @docTypeId = @docTypeId,
                  @workPlaceId = @workPlaceId,
                  @confirmWorkPlaceId = @confirmWorkPlaceId,
                  @result = @result out;
  end
  set @result=7;
end

