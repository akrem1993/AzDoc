-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 17.10.2019
-- Description:	Istifadeci yaradilmasi
-- =============================================
CREATE procedure [admin].[CreateUser] @userName           NVARCHAR(50)             = NULL,
									 @userPassword       NVARCHAR(50)             = NULL, 
                                     @userStatus         BIT                      = NULL, 
                                     @personnelName      NVARCHAR(50)             = NULL, 
                                     @personnelSurname   NVARCHAR(50)             = NULL, 
                                     @personnelLastname  NVARCHAR(50)             = NULL, 
                                     @personnelBirthdate DATETIME                 = NULL, 
                                     @sexId              INT                      = NULL, 
                                     @personnelPhone     NVARCHAR(20)             = NULL, 
                                     @personnelEmail     NVARCHAR(20)             = NULL, 
                                     @personnelMobile    NVARCHAR(20)             = NULL, 
                                     @workPlaces         [admin].[UdttWorkPlaces] READONLY
AS
     DECLARE @workPlacesCount INT= 0, @personnelId INT= NULL, @userId INT= NULL, @workPlaceId INT= NULL, @organizationId INT= NULL, @departmentId INT= NULL,@sectorId INT= NULL, @departmentPositionId INT= NULL, @jsonRoleId NVARCHAR(MAX)= NULL;
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
            IF EXISTS
            (
                SELECT du.UserId
                FROM dbo.DC_USER du
                WHERE du.UserName = @username
            )
                THROW 56000, 'Bu adla istifadeci artiq movcuddur', 1;
            INSERT INTO dbo.DC_PERSONNEL
            (
            --PersonnelId - column value is auto-generated
            PersonnelName, 
            PersonnelSurname, 
            PersonnelLastname, 
            PersonnelBirthdate, 
            PersonnelSexId, 
            PersonnelPhone, 
            PersonnelEmail, 
            PersonnelMobile, 
            PersonnelStatus
            )
            VALUES
            (
            -- PersonnelId - int
            @personnelName, -- PersonnelName - nvarchar
            @personnelSurname, -- PersonnelSurname - nvarchar
            @personnelLastname, -- PersonnelLastname - nvarchar
            @personnelBirthdate, -- PersonnelBirthdate - date
            @sexId, -- PersonnelSexId - int
            @personnelPhone, 
            @personnelEmail, 
            @personnelMobile, 
            1 -- PersonnelStatus - bit
            );
            SET @personnelId = SCOPE_IDENTITY();
            INSERT INTO dbo.DC_USER
            (
            --UserId - column value is auto-generated
            UserPersonnelId, 
            UserName, 
            UserPassword, 
            DefaultPage, 
            UserStatus, 
            Notifications, 
            DomenUserName, 
            DefaultLang, 
            DefaultLeftMenu
            )
            VALUES
            (
            -- UserId - int
            @personnelId, -- UserPersonnelId - int
            @username, -- UserName - nvarchar
            N'bhourBsGm8TaOYj8xhERbw==' , -- UserPassword - nvarchar
            -1, -- DefaultPage - int
            1, -- UserStatus - bit
            NULL, -- Notifications - bit
            NULL, -- DomenUserName - nvarchar
            1, -- DefaultLang - int
            0 -- DefaultLeftMenu - bit
            );
            SET @userId = SCOPE_IDENTITY();
            SELECT @workPlacesCount = COUNT(0)
            FROM @workPlaces uw;
            WHILE(@workPlacesCount > 0)
                BEGIN
                    SELECT @workplaceId = s.WorkplaceId, 
                           @organizationId = s.OrganizationId, 
                           @departmentId = s.DepartmentId,
						   @sectorId = s.SectorId, 
                           @departmentPositionId = s.DepartmentPositionId, 
                           @jsonRoleId = s.JsonRoleId
                    FROM
                    (
                        SELECT wp.WorkplaceId, 
                               wp.OrganizationId, 
                               wp.DepartmentId, 
                               wp.DepartmentPositionId, 
                               wp.JsonRoleId,
							   wp.SectorId,
                               ROW_NUMBER() OVER(
                               ORDER BY wp.WorkplaceId) AS rownumber
                        FROM @workPlaces wp
                    ) s
                    WHERE s.rownumber = @workPlacesCount;
                    INSERT INTO dbo.DC_WORKPLACE
                    (
                    --WorkplaceId - column value is auto-generated
                    WorkplaceUserId, 
                    WorkplaceOrganizationId, 
                    WorkplaceDepartmentId, 
                    WorkplaceDepartmentPositionId, 
                    WorkPlaceStatus
                    )
                    VALUES
                    (
                    -- WorkplaceId - int
                    @userId, -- WorkplaceUserId - int
                    @organizationId, -- WorkplaceOrganizationId - int
                    Coalesce(@sectorId, @departmentId), -- WorkplaceDepartmentId - int
                    @departmentPositionId, -- WorkplaceDepartmentPositionId - int
                    1 -- WorkPlaceStatus - bit
                    );
                    SET @workPlaceId = SCOPE_IDENTITY();
                    INSERT INTO dbo.DC_WORKPLACE_ROLE
                    (WorkplaceId, 
                     RoleId, 
                     STATUS, 
                     InsertDate
                    )
                           SELECT @workplaceId, 
                                  js.value, 
                                  1, 
                                  dbo.sysdatetime()
                           FROM OPENJSON(@jsonRoleId) js;
                    SET @workPlacesCount-=1;
                END;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
                   @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();
            INSERT INTO dbo.debugTable
            ([text], 
             insertDate
            )
            VALUES
            (@ErrorMessage, 
             dbo.SYSDATETIME()
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;
    END;

