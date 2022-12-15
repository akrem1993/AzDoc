CREATE procedure [admin].[GetUser] @formType          INT           = NULL, 
                                  @userId            INT           = NULL, 
                                  @pageIndex         INT           = 1, 
                                  @pageSize          INT           = 20, 
                                  @totalCount        INT           = NULL OUT,
                                  ---for searching

                                  @personnelname     NVARCHAR(50)  = NULL, 
                                  @personnelsurname  NVARCHAR(50)  = NULL, 
                                  @personnellastname NVARCHAR(50)  = NULL, 
                                  @username          NVARCHAR(MAX) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF(@formType = 1)
            BEGIN
                SELECT du.UserId, 
                       du.UserName, 
                       dp.PersonnelName, 
                       dp.PersonnelSurname, 
                       dp.PersonnelLastname,
                       CASE
                           WHEN du.UserStatus = 1
                           THEN 'Aktivdir'
                           ELSE 'Aktiv deyil'
                       END UserStatus
                FROM dbo.DC_USER du
                     INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                                       AND ((@personnelname IS NULL
                                                             OR dp.PersonnelName LIKE N'%' + @personnelname + '%')
                                                            AND (@personnelsurname IS NULL
                                                                 OR dp.PersonnelSurname LIKE N'%' + @personnelsurname + '%')
                                                            AND (@personnelname IS NULL
                                                                 OR dp.PersonnelLastname LIKE N'%' + @personnellastname + '%')
                                                            AND (@personnelname IS NULL
                                                                 OR du.UserName LIKE N'%' + @username + '%'))
                ORDER BY du.UserId DESC
                OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;
                SELECT @totalCount = COUNT(0)
                FROM dbo.DC_USER du
                     INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                                       AND ((@personnelname IS NULL
                                                             OR dp.PersonnelName LIKE N'%' + @personnelname + '%')
                                                            AND (@personnelsurname IS NULL
                                                                 OR dp.PersonnelSurname LIKE N'%' + @personnelsurname + '%')
                                                            AND (@personnelname IS NULL
                                                                 OR dp.PersonnelLastname LIKE N'%' + @personnellastname + '%')
                                                            AND (@personnelname IS NULL
                                                                 OR du.UserName LIKE N'%' + @username + '%'));
        END;
        IF(@formType = 2)
            BEGIN
                SELECT du.UserId, 
                       du.UserName, 
                       dp.PersonnelName, 
                       dp.PersonnelSurname, 
                       dp.PersonnelLastname,
                       CASE
                           WHEN du.UserStatus = 1
                           THEN 'Aktivdir'
                           ELSE 'Aktiv deyil'
                       END UserStatus
                FROM dbo.DC_USER du
                     INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                WHERE du.UserId = @userId;
        END;
    END;

