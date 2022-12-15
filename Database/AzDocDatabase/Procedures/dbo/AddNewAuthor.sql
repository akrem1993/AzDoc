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
-- Author:  Rufin Ahmadov
-- Create date: 22.05.2019
-- Description: Add new author
-- =============================================
CREATE PROCEDURE [dbo].[AddNewAuthor] @surname        NVARCHAR(100)=NULL , 
                                     @firstName      NVARCHAR(100)=NULL , 
                                     @fatherName     NVARCHAR(100)=NULL , 
                                     @organizationName   NVARCHAR(MAX)=NULL, 
                                     @positionName       NVARCHAR(MAX)=NULL, 
                                     @departmentName     NVARCHAR(MAX)=NULL, 
                                     @organizationId INT           = NULL, 
                                     @positionId     INT           = NULL, 
                                     @departmentId   INT           = NULL, 
									 	 @addressName      NVARCHAR(MAX)=NULL,  ---new
                                     @authorId       int out,
                                     @authorOrganizationId int out,
                                     @result         INT OUT
AS
         BEGIN
        SET NOCOUNT ON;
   BEGIN TRANSACTION 
        BEGIN TRY

    DECLARE @currentOrgId INT=NULL,
			@currentPositionId int=NULL,
			@currentDepartId int=NULL;

    	IF	(@organizationName IS NOT NULL)
	    BEGIN
	    	IF(@organizationId IS NOT NULL) -- eger teskilat id gelirse demeli teskilat var ve ancaq select edirik eger yoxdursa insert edirik
	    	BEGIN
	    		SELECT @currentOrgId = do.OrganizationId
	    		FROM dbo.DC_ORGANIZATION do
	    		WHERE do.OrganizationId = @organizationId;
	    	END
	    	ELSE
	    	BEGIN
	    		INSERT dbo.DC_ORGANIZATION
	    		(
	    			OrganizationName,
	    			OrganizationShortname,
	    			OrganizationStatus
	    		)
	    		VALUES
	    		(
	    		    @organizationName,
	    			@organizationName,
	    			1
	    		) 
	    		SET @currentOrgId = SCOPE_IDENTITY();
	    	END;
	    END;

	    IF(@positionName IS NOT NULL)
	    BEGIN
	    	IF (@positionId IS NOT null)-- eger vezife id gelirse demeli vezife var ve ancaq select edirik eger yoxdursa insert edirik
	    	BEGIN
	    		SELECT @currentPositionId = dp.PositionId
	    		FROM dbo.DC_POSITION dp
	    		WHERE dp.PositionId = @positionId;
	    	END
	    	ELSE
	    	BEGIN
	    		INSERT dbo.DC_POSITION
	    		(
	    		    PositionName,
	    		    PositionStatus
	    		)
	    		VALUES
	    		(
	    		    @positionName, -- PositionName - nvarchar
	    		    1 -- PositionStatus - bit
	    		)
	    		SET @currentPositionId  = SCOPE_IDENTITY();
	    	END;
	    END;	




	    IF(@departmentName IS NOT NULL)
	    BEGIN
			IF(@departmentId IS NOT NULL)
			BEGIN
				SELECT @currentDepartId = dd.DepartmentId
				FROM dbo.DC_DEPARTMENT dd
				WHERE dd.DepartmentId = @departmentId;
			END
	    END;	

    INSERT dbo.DOC_AUTHOR
    (
        AuthorName,
        AuthorSurname,
        AuthorLastname,
        AuthorOrganizationId,
        AuthorPositionId,
        AuthorStatus,
		AuthorDepartmentId,
		AuthorDepartmentname
    )
    VALUES
    (
		@firstName,
		@surname,
		@fatherName,
		@currentOrgId,
		@currentPositionId,
		1,
		@currentDepartId,
		@departmentName
    )
    SET @authorId=scope_identity();
    SET @authorOrganizationId = @currentOrgId ;
    SET @result = 1;

   COMMIT TRANSACTION;
 END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            INSERT INTO dbo.debugTable
    ([text], insertDate)
            VALUES
    (ERROR_MESSAGE(), SYSDATETIME());
        END CATCH;
    END;

