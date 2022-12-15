/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddExecutorChiefs]
@fileId int, 
@vizaDocId int,
@relatedDocId int=null,
@signerWorkPlaceId int = null,
@docTypeId int,
@workPlaceId int ,
@result int output
WITH EXEC AS CALLER
AS

BEGIN TRY
	declare @VizaPositionGroup table(PositionGroupId int , NextPositionGroupId int)
if(NOT EXISTS(select * from docs_viza v where v.VizaFileId=@fileId and v.VizaDocId=@vizaDocId and v.VizaFromWorkflow=1))
  begin      
    insert into 
      @VizaPositionGroup(PositionGroupId, NextPositionGroupId) 
    select s.PositionGroupId, s.NextPositionGroupId 
    from dm_step s 
    where s.DirectionTypeId=16 and s.DocTypeId = @docTypeId 
    order by s.StepOrderIndex asc
      
    declare @orderIndex int = 1;
    declare @chiefId int;
    declare @Chief table(Id int, DepartmentId int, Name nvarchar(500), PositionGroupLevel int,RowNumber int);
    
    declare @workPlaceDepartmentId int;
    declare @workPlaceTopDepartmentId int;
    
    select @workPlaceDepartmentId=d.DepartmentId,
        @workPlaceTopDepartmentId=d.DepartmentTopId 
      from DC_DEPARTMENT d 
      join DC_WORKPLACE w on d.DepartmentId=w.WorkplaceDepartmentId 
      where w.WorkplaceId=@workPlaceId;
    
      declare @count int = 0,
     @positionGroupId int,
     @chiefPositionGroupId int,
     @positionGroupLevel int;
          
   SELECT @positionGroupId=dpg.PositionGroupId,
    @positionGroupLevel = dpg.PositionGroupLevel
   FROM dbo.DC_WORKPLACE dw  
    INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId 
    INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
   WHERE dw.WorkplaceId = @workPlaceId

      begin 
      insert into @Chief(Id,DepartmentId,Name,PositionGroupLevel,RowNumber) -- old insert
              select w.WorkplaceId,
                  dp.DepartmentId,
                  dbo.GET_PERSON( 1, W.WorkplaceId),
                  pg.PositionGroupLevel ,
                    ROW_NUMBER() over (order by w.WorkplaceId)
              from DC_DEPARTMENT_POSITION dp 
    INNER JOIN DC_WORKPLACE w on dp.DepartmentPositionId=w.WorkplaceDepartmentPositionId
    INNER JOIN DC_USER u on u.UserId=w.WorkplaceUserId and u.UserStatus=1
    INNER JOIN DC_POSITION_GROUP pg on pg.PositionGroupId=dp.PositionGroupId
              where dp.DepartmentId in (@workPlaceDepartmentId,@workPlaceTopDepartmentId) 
     and dp.PositionGroupId in (select PositionGroupId from @VizaPositionGroup)  
     AND pg.PositionGroupLevel<=@positionGroupLevel
               order by pg.PositionGroupLevel
          
          
          declare @chiefCount int;
          select @chiefCount=count(0) from @Chief;
          
          declare @vizaSenderWorkPlaceId int = @workPlaceId;

          while(@chiefCount>0)
          begin          
            set @count+=1;            
            declare  @chiefWorkPlaceId int;
            select @chiefWorkPlaceId = Id from @Chief where RowNumber=@chiefCount;            
            declare @oldChief int;
            
            if @chiefCount>1
            begin
              set  @oldChief = @chiefWorkPlaceId;
            END

   SELECT @chiefPositionGroupId=dpg.PositionGroupId FROM dbo.DC_WORKPLACE dw  
    INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId 
    INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
   WHERE dw.WorkplaceId = @chiefWorkPlaceId
            
            if(@chiefWorkPlaceId <> @workPlaceId AND @positionGroupId NOT IN (17) AND @chiefPositionGroupId NOT IN (5)) -- iscinin razilasma sxemi
            BEGIN

    if @count>1
    begin 
      set @vizaSenderWorkPlaceId = @oldChief;
    END;
            
    exec dbo.spVizaAdd
    @isDeleted=0, 
    @vizaDocId = @vizaDocId, 
    @vizaFileId=@fileId, 
    @vizaConfirmed=0, 
    @vizaOrderIndex=@orderIndex, 
    @vizaSendDate=null, 
    @vizaWorkPlaceId=@chiefWorkPlaceId, --55
    @vizaAgreementTypeId=1, 
    @vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
    @vizaFromWorkFlow=1,
    @result = @result out;

		INSERT INTO dbo.debugTable
	(
	    --id - column value is auto-generated
	    [text],
	    insertDate
	)
	VALUES
	(
	    -- id - int
	    N'salam isci', -- text - nvarchar
	    dbo.sysdatetime() -- insertDate - datetime
	)	

    set @orderIndex = @orderIndex+1;
            END
   else if(@chiefWorkPlaceId = @workPlaceId AND @positionGroupId IN (17) AND @workPlaceId<>@signerWorkPlaceId)-- sohbe mudurunun razilasma sxemi
   begin
  if @count>1
  begin 
    set @vizaSenderWorkPlaceId = @oldChief;
  END;
              
  exec dbo.spVizaAdd
  @isDeleted=0, 
  @vizaDocId = @vizaDocId, 
  @vizaFileId=@fileId, 
  @vizaConfirmed=0, 
  @vizaOrderIndex=@orderIndex, 
  @vizaSendDate=null, 
  @vizaWorkPlaceId=@chiefWorkPlaceId, --55
  @vizaAgreementTypeId=1, 
  @vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
  @vizaFromWorkFlow=1,
  @result = @result out;

  set @orderIndex = @orderIndex+1;
    END
   else IF(@chiefWorkPlaceId = @workPlaceId AND @workPlaceId!=@signerWorkPlaceId and @positionGroupId IN (5)) -- elaqli-xidmeti sened ucun. qurum rehberini vizaya elave edir
   BEGIN
    exec dbo.spVizaAdd
    @isDeleted=0, 
    @vizaDocId = @vizaDocId, 
    @vizaFileId=@fileId, 
    @vizaConfirmed=0, 
    @vizaOrderIndex=@orderIndex, 
    @vizaSendDate=null, 
    @vizaWorkPlaceId=@workPlaceId, --55
    @vizaAgreementTypeId=1, 
    @vizaSenderWorkPlaceId=@workPlaceId, --51
    @vizaFromWorkFlow=1,
    @result = @result out;
    set @orderIndex = @orderIndex+1;
   END;
            set @chiefCount-=1;
          end;
      end;
      
      set @result = 1;
     
  end;

END TRY
BEGIN CATCH
	INSERT INTO dbo.debugTable
	(
	    --id - column value is auto-generated
	    [text],
	    insertDate
	)
	VALUES
	(
	    -- id - int
	    ERROR_MESSAGE(), -- text - nvarchar
	    dbo.sysdatetime() -- insertDate - datetime
	)	
END CATCH

