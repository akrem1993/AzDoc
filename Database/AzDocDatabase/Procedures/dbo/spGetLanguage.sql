/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- Create date: 30.05.2019
-- Description: Dil seçmək
-- =============================================
 CREATE PROCEDURE [dbo].[spGetLanguage]
 @userId int
 AS
 BEGIN
 SET NOCOUNT ON;
 select
 l.id as [Id],
 l.Alias as [Name]
 from AC_LANGUAGE l 
 where l.isactive=1
 END

