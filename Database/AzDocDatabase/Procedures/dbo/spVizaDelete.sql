/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spVizaDelete]
@vizaId int,
@result int output
WITH EXEC AS CALLER
AS

declare @DocsViza table (VizaId int,VizaDocId int,VizaFileId int,VizaWorkPlaceId int, VizaOrderIndex int, VizaFromWorkFlow int );

insert into @DocsViza(VizaId , VizaDocId, VizaFileId, VizaWorkPlaceId, VizaOrderIndex , VizaFromWorkFlow )

           select dv.VizaId, dv.VizaDocId, dv.VizaFileId, dv.VizaWorkPlaceId ,dv.VizaOrderindex, dv.VizaFromWorkflow 
           from DOCS_VIZA dv
           where VizaId = @vizaId;
                      
declare @vizaFromWorkFlow int, @vizaDocId int, @currentOrderIndex int;
select  @vizaFromWorkFlow = VizaFromWorkFlow, @vizaDocId=VizaDocId,@currentOrderIndex = VizaOrderIndex from @DocsViza

if (@vizaFromWorkFlow>0) -- @vizaFromWorkFlow>1
begin
  declare @SameOrderIndexs table (VizaOrderIndex int);
  declare @GreaterOrderIndexs table (VizaId int, VizaOrderIndex int, RowNumber int);
  
  insert into @SameOrderIndexs(VizaOrderIndex)
                        select VizaOrderindex from DOCS_VIZA where VizaOrderindex = @currentOrderIndex and VizaDocId = @vizaDocId and IsDeleted=0;
  
  insert into @GreaterOrderIndexs(VizaId, VizaOrderIndex, RowNumber)
                           select VizaId, VizaOrderindex, Row_Number() over (order by VizaId) 
                           from DOCS_VIZA where VizaOrderindex > @currentOrderIndex and VizaDocId = @vizaDocId and IsDeleted=0;

  update DOCS_VIZA
  set IsDeleted = 1
  where VizaId = @vizaId;
  
  update DOCS_DIRECTIONS
  set DirectionConfirmed = 0
  where DirectionWorkplaceId = (select VizaWorkPlaceId from @DocsViza)
  AND DOCS_DIRECTIONS.DirectionDocId =(SELECT dv.VizaDocId from @DocsViza dv)
  AND DOCS_DIRECTIONS.DirectionTypeId = 3;
                               
  declare @sameCount int;                      
  declare @greaterCount int;
  
  select @sameCount = count(0) from @SameOrderIndexs ;  
  select @greaterCount=count(0) from @GreaterOrderIndexs;

  if (not(@sameCount > 1))
    begin
      if(@greaterCount>0)
          begin
            while(@greaterCount>0)
            begin    
              update DOCS_VIZA
              set VizaOrderindex = (select VizaOrderIndex from @GreaterOrderIndexs where RowNumber = @greaterCount)-1
              where VizaId = (select VizaId from @GreaterOrderIndexs where RowNumber = @greaterCount);
              set @greaterCount-=1;
            end;
          end;
    end;

	SET @result = 1;
end;

