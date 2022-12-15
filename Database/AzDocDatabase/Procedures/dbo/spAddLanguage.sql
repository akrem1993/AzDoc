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
-- Author:  IBrahimov Resid
-- Create date: 30.05.2019
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spAddLanguage]
@userId INT, 
@langId INT, 
@result INT out
AS
    BEGIN
        SET NOCOUNT ON;
        IF EXISTS
        (
            SELECT u.UserId
            FROM DC_USER u
                 INNER JOIN AC_LANGUAGE l ON l.Id = u.DefaultLang
            WHERE u.UserId = @userId
                  AND u.UserStatus = 1
                  AND l.IsActive = 1
        )
            BEGIN
                UPDATE dbo.DC_USER
                  SET 
                      dbo.DC_USER.DefaultLang = @langId -- int
                WHERE dbo.DC_USER.UserId = @userId;
                SET @result = 1;
    
        END
  else 
  begin 
    begin
      SET @result = -1;
    end
  end;
  end;

