/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spCreateDocument] 
@docTypeId int,
@docDeleted int,
@workPlaceId int,
@docId int=0 out,
@result int=0 out

WITH EXEC AS CALLER
AS
BEGIN
  begin try
    begin transaction
		
		DECLARE @periodId int,
		        @date DATE= dbo.SYSDATETIME(),
				@orgId int;

		SELECT @periodId = dp.PeriodId
        FROM DOC_PERIOD dp
        WHERE dp.PeriodDate1 <= @date
              AND dp.PeriodDate2 >= @date;

		SELECT @orgId =
        (
            SELECT dbo.fnPropertyByWorkPlaceId(@workPlaceId, 12)
        );

        INSERT INTO dbo.DOCS
                (
				 DocPeriodId, 
                 DocOrganizationId, 
                 DocDoctypeId, 
                 DocDeleted, 
                 DocDeletedByDate, 
                 DocInsertedById, 
                 DocInsertedByDate
                )
                VALUES
                (
				 @periodId, 
                 @orgId, 
                 @docTypeId, 
                 @docDeleted, 
                 dbo.SYSDATETIME(), 
                 @workPlaceId, 
                 dbo.SYSDATETIME()
                );

                SET @docId = SCOPE_IDENTITY();
                              
              if(@docId IS NOT NULL)
              begin
                 
                declare @directionId int;
                declare @personelFullName nvarchar(500);
                declare @nowDateTime datetime;
                 
                set @nowDateTime = dbo.sysdatetime();
                set @personelFullName=Cast([dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@workPlaceId ,5) as nvarchar);
                 
                exec dbo.spAddDirection
                              @directionDate=@nowDateTime, 
                              @directionDocId=@docId,
                              @directionTypeId=4,               --new document
                              @directionWorkplaceId=@workPlaceId,
                              @directionInsertedDate=@nowDateTime, 
                              @directionPersonFullName=@personelFullName,
                              @directionCreatorWorkplaceId=@workPlaceId,
                              @directionId=@directionId out,
                              @result=@result out;
                              
                if(@result = 1)
                begin
                  declare @Departament table (DepartmentOrganization int null,DepartmentTopDepartmentId int null,DepartmentId int,DepartmentSectionId int null,DepartmentSubSectionId int null)

              Insert into @Departament(DepartmentOrganization,
              DepartmentTopDepartmentId,
              DepartmentId,
              DepartmentSectionId,
              DepartmentSubSectionId) 
           select d.DepartmentOrganization,
              d.DepartmentTopDepartmentId,
              d.DepartmentId,
              d.DepartmentSectionId,
              d.DepartmentSubSectionId
           from DC_WORKPLACE w 
                  join DC_DEPARTMENT_POSITION dp  
                                                  on w.WorkplaceDepartmentPositionId = dp.DepartmentPositionId 
           join DC_DEPARTMENT d  
                                        on dp.DepartmentId = d.DepartmentId 
           where w.WorkplaceId = @workPlaceId
                  
                  declare @departmentOrganization int, 
        @departmentTopDepartmentId int, 
        @departmentId int, 
        @departmentSectionId int, 
        @departmentSubSectionId int;
                  
                  select 
                      @departmentOrganization = DepartmentOrganization, 
                      @departmentTopDepartmentId = DepartmentTopDepartmentId,  
                      @departmentId = DepartmentId, 
                      @departmentSectionId = DepartmentSectionId, 
                      @departmentSubSectionId = DepartmentSubSectionId
                  from 
                      @Departament
                  
                                
                  exec dbo.spAddExecutor
                                @executorDocId = @docId, 
                                @directionTypeId = 4,            --new document
                                @executorSection = @departmentSectionId, 
                                @executorMain = 0, 
                                @executorReadStatus = 0,
                                @executorSubsection = @departmentSubSectionId, 
                                @executorDepartment = @departmentId,
                                @executorWorkplaceId = @workPlaceId, 
                                @executorDirectionId = @directionId, 
                                @executorFullName = @personelFullName, 
                                @executorTopDepartment = @departmentTopDepartmentId,
                                @executorOrganizationId = @departmentOrganization,
                                @result = @result out;

      EXEC dbo.LogDocumentOperation
        @docId = @docId,
        @ExecutorId = null,
        @SenderWorkPlaceId = @workPlaceId,
        @ReceiverWorkPlaceId = null,
        @DocTypeId = @docTypeId,
        @OperationTypeId = 14,
        @DirectionTypeId = 4,
        @OperationStatusId = null,
        @OperationStatusDate = null,
        @OperationNote = null;
                end
                else
                  begin 
                    rollback transaction;
                  end;
                               
              end
              else
                begin 
                  rollback transaction;
                end;
                
    commit transaction;  
  end try
  begin catch
    rollback transaction;
    
  insert into debugTable(text, insertDate)
              values(ERROR_MESSAGE(), dbo.sysdatetime());
  end catch;
             
end;

