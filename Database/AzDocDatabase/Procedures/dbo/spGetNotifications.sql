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
 -- Author:  Ibrahimov Resid
 -- Create date: 31.05.2019
 -- Description: <Description,,>
 -- =============================================
 CREATE PROCEDURE [dbo].[spGetNotifications]
 @userid int
 AS
 BEGIN
 SET NOCOUNT ON;
 select
 u.Notifications
 from DC_USER u
 where u.UserId=@userid
 END

