CREATE procedure [admin].[EditUser] @formTypeId         INT=NULL, 
                                   @userId             INT, 
                                   @userName           NVARCHAR(50)             = NULL, 
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
								  -- @result int OUTPUT
AS
     DECLARE @workPlacesCount INT= 0, @currentWorkPlacesCount INT= 0, @workplaceId INT= NULL, @organizationId INT= NULL, @departmentId INT= NULL, @sectorId INT= NULL, @departmentPositionId INT= NULL, @jsonRoleId NVARCHAR(MAX)= NULL;
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

			DECLARE @NewWorkPlace TABLE(NewWorkPlaceId INT);
            IF(@formTypeId = 1) --User block/unblock
                BEGIN
                    UPDATE dbo.DC_USER 
                      SET 
                          dbo.DC_USER.UserStatus = @userStatus
                    WHERE dbo.DC_USER.UserId = @userId;
            END;
                ELSE IF (@formTypeId = 3) -- User password reset
                    BEGIN
                        UPDATE dbo.DC_USER
                          SET 
                              dbo.DC_USER.UserPassword = N'bhourBsGm8TaOYj8xhERbw=='
                        WHERE dbo.DC_USER.UserId = @userId;

						COMMIT TRANSACTION

						return

                END;

                    ELSE -- User other change
                    BEGIN
                        IF EXISTS
                        (
                            SELECT du.*
                            FROM dbo.DC_USER du
                            WHERE du.UserId = @userId
                                  AND du.UserName <> @userName
                        )
                            BEGIN
                                IF NOT EXISTS
                                (
                                    SELECT du.*
                                    FROM dbo.DC_USER du
                                    WHERE du.UserId <> @userId
                                          AND du.UserName = @userName
                                )
                                    BEGIN
                                        UPDATE dbo.DC_USER
                                          SET 
                                              dbo.DC_USER.UserName = @userName
                                        WHERE dbo.DC_USER.UserId = @userId;
                                END;
                                    ELSE
                                        THROW 56000, N'Bu adla istifadeci artiq movcuddur', 1;
                                END;
                        END;
                        UPDATE dbo.DC_PERSONNEL
                          SET
                        --PersonnelId - column value is auto-generated
                              dbo.DC_PERSONNEL.PersonnelName = @personnelName, -- nvarchar
                              dbo.DC_PERSONNEL.PersonnelSurname = @personnelSurname, -- nvarchar
                              dbo.DC_PERSONNEL.PersonnelLastname = @personnelLastname, -- nvarchar
                              dbo.DC_PERSONNEL.PersonnelBirthdate = @personnelBirthdate, -- date
                              dbo.DC_PERSONNEL.PersonnelSexId = @sexId, -- int
                              dbo.DC_PERSONNEL.PersonnelPhone = @personnelPhone, -- nvarchar
                              dbo.DC_PERSONNEL.PersonnelEmail = @personnelEmail, -- nvarchar
                              dbo.DC_PERSONNEL.PersonnelMobile = @personnelMobile-- nvarchar
                        WHERE dbo.DC_PERSONNEL.PersonnelId =
                        (
                            SELECT du.UserPersonnelId
                            FROM dbo.DC_USER du
                            WHERE du.UserId = @userId
                        );
                        SELECT @workPlacesCount = COUNT(0)
                        FROM @workPlaces uw;
                        WHILE(@workPlacesCount > 0)
                            BEGIN
                                SELECT @workplaceId = s.WorkplaceId, 
                                       @organizationId = s.OrganizationId, 
                                       @departmentId = s.DepartmentId, 
                                       @departmentPositionId = s.DepartmentPositionId, 
                                       @jsonRoleId = s.JsonRoleId,
									   @sectorId = s.SectorId
                                FROM
                                (
                                    SELECT wp.WorkplaceId, 
                                           wp.OrganizationId, 
                                           wp.DepartmentId,
										   wp.SectorId, 
                                           wp.DepartmentPositionId, 
                                           wp.JsonRoleId, 
                                           ROW_NUMBER() OVER(
                                           ORDER BY wp.WorkplaceId) AS rownumber
                                    FROM @workPlaces wp
                                ) s
                                WHERE s.rownumber = @workPlacesCount;
                                IF(@workplaceId > 0)

								   BEGIN
								    
								   IF EXISTS (
									SELECT wp.WorkplaceId FROM @workPlaces wp WHERE wp.WorkplaceId > 0 
									AND wp.OrganizationId NOT IN 
									(
									 SELECT wp1.OrganizationId FROM @workPlaces wp1 WHERE wp1.WorkplaceId = 0
									 ) AND EXISTS (SELECT * FROM @workPlaces wp3 WHERE wp3.WorkplaceId = 0)
								   )
								   BEGIN 
								   UPDATE dbo.DC_WORKPLACE SET WorkPlaceStatus = 0 WHERE dbo.DC_WORKPLACE.WorkplaceId  IN
								   (
								   SELECT wp.WorkplaceId FROM @workPlaces wp WHERE wp.WorkplaceId > 0 
								   AND wp.OrganizationId NOT IN 
									(
									 SELECT wp1.OrganizationId FROM @workPlaces wp1 WHERE wp1.WorkplaceId = 0
									 )
								   )
										
								   END

								   ELSE
                                    BEGIN
                                        UPDATE dbo.DC_WORKPLACE
                                          SET 
                                              dbo.DC_WORKPLACE.WorkplaceOrganizationId = @organizationId, -- int
                                             -- dbo.DC_WORKPLACE.WorkplaceDepartmentId = @departmentId, -- int
											dbo.DC_WORKPLACE.WorkplaceDepartmentId = Coalesce(@sectorId, @departmentId),
                                              dbo.DC_WORKPLACE.WorkplaceDepartmentPositionId = @departmentPositionId -- int
                                        WHERE dbo.DC_WORKPLACE.WorkplaceId = @workplaceId;
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
                                               FROM OPENJSON(@jsonRoleId) js
                                               WHERE js.value NOT IN
                                               (
                                                   SELECT dwr.RoleId
                                                   FROM dbo.DC_WORKPLACE_ROLE dwr
                                                   WHERE dwr.WorkplaceId = @workplaceId
                                               );
                                        UPDATE dbo.DC_WORKPLACE_ROLE
                                          SET 
                                              dbo.DC_WORKPLACE_ROLE.STATUS = 0, -- bit
                                              dbo.DC_WORKPLACE_ROLE.InsertDate = dbo.sysdatetime()-- datetime
                                        WHERE dbo.DC_WORKPLACE_ROLE.WorkplaceId = @workplaceId
                                              AND dbo.DC_WORKPLACE_ROLE.RoleId NOT IN
                                        (
                                            SELECT js.value AS roleId
                                            FROM OPENJSON(@jsonRoleId) js
                                        );
                                END;
								END;
                                    ELSE
                                    BEGIN
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
                                      --  @departmentId, -- WorkplaceDepartmentId - int
									   -- CASE WHEN @sectorId IS NULL THEN @departmentId ELSE @sectorId END,
										Coalesce(@sectorId, @departmentId),
                                        @departmentPositionId, -- WorkplaceDepartmentPositionId - int
                                        1 -- WorkPlaceStatus - bit
                                        );

                                        SET @workplaceId = SCOPE_IDENTITY();
										INSERT @NewWorkPlace
										(
										    NewWorkPlaceId
										)
										VALUES
										(
										    @workplaceId -- WorkPlaceId - INT
										)

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
                                END;
                                SET @workPlacesCount-=1;
                                IF(@workPlacesCount = 0)
                                    BEGIN
                                        UPDATE dbo.DC_WORKPLACE
                                          SET 
                                              dbo.DC_WORKPLACE.WorkPlaceStatus = 0
                                        WHERE dbo.DC_WORKPLACE.WorkplaceId IN
                                        (
                                            SELECT dw.WorkplaceId
                                            FROM dbo.DC_WORKPLACE dw
                                            WHERE dw.WorkplaceUserId = @userId
                                                  AND dw.WorkplaceId NOT IN
                                            (
                                               ( SELECT uw.WorkplaceId
                                                FROM @workPlaces uw) 
												
                                            )
                                                  AND dw.WorkPlaceStatus = 1
                                        )
										AND dbo.DC_WORKPLACE.WorkplaceId NOT IN ((SELECT nwp.NewWorkPlaceId FROM @NewWorkPlace nwp));
                                END;
							
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

