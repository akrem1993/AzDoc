-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 17.10.2019
-- Description:	Istifadeci yaradilmasi
-- =============================================
CREATE   PROCEDURE dbo.CreateUser
@personName nvarchar(max),
@personSurname nvarchar(max),
@personLastName nvarchar(max),
@username nvarchar(max),
@gender int=1,--2
@organizationId int,
@departmentId int,
@departmentPositionId int
AS
DECLARE 
@personnelId int,
@userId int,
@workPlaceId int
BEGIN

BEGIN TRY
BEGIN TRANSACTION

IF EXISTS(SELECT du.UserId FROM dbo.DC_USER du WHERE du.UserName=@username) THROW 56000,'Bu adla istifadeci artiq movcuddur',1;


INSERT dbo.DC_PERSONNEL
(
    --PersonnelId - column value is auto-generated
    PersonnelName,
    PersonnelSurname,
    PersonnelLastname,
    PersonnelBirthdate,
    PersonnelSexId,
    PersonnelStatus
)
VALUES
(
    -- PersonnelId - int
    @personLastName, -- PersonnelName - nvarchar
    @personSurname, -- PersonnelSurname - nvarchar
    @personLastName, -- PersonnelLastname - nvarchar
    NULL, -- PersonnelBirthdate - date
    @gender, -- PersonnelSexId - int
    1 -- PersonnelStatus - bit
)

SET @personnelId=SCOPE_IDENTITY();

INSERT dbo.DC_USER
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
    N'bhourBsGm8TaOYj8xhERbw==', -- UserPassword - nvarchar
    -1, -- DefaultPage - int
    1, -- UserStatus - bit
    null, -- Notifications - bit
    null, -- DomenUserName - nvarchar
    1, -- DefaultLang - int
    0 -- DefaultLeftMenu - bit
)

SET @userId=SCOPE_IDENTITY();


INSERT dbo.DC_WORKPLACE
(
    --WorkplaceId - column value is auto-generated
    WorkplaceUserId,
    WorkplaceOrganizationId,
    WorkplaceDepartmentId,
    WorkplaceDepartmentPositionId
)
VALUES
(
    -- WorkplaceId - int
    @userId, -- WorkplaceUserId - int
    @organizationId, -- WorkplaceOrganizationId - int
    @departmentId, -- WorkplaceDepartmentId - int
    @departmentId -- WorkplaceDepartmentPositionId - int
) 
SET @workPlaceId=SCOPE_IDENTITY();

SELECT @userId AS UserId,@workPlaceId AS WorkPlaceId

COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK;
DECLARE 
@ErrorProcedure nvarchar(max),
@ErrorMessage nvarchar(max), 
@ErrorSeverity int, @ErrorState int;

SELECT
@ErrorProcedure='Procedure:'+ERROR_PROCEDURE(), 
@ErrorMessage = @ErrorProcedure+'.Message:'+ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)),
@ErrorSeverity = ERROR_SEVERITY(),
@ErrorState = ERROR_STATE();

INSERT INTO dbo.debugTable
([text],insertDate)
VALUES
(@ErrorMessage, dbo.SYSDATETIME())
         

RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

END

