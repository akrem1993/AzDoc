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
-- Create date: 26.04.2019
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetUserWorkPlaceId]
@WorkPlaceId int 
AS
BEGIN
select 
u.UserId,
u.UserPersonnelId,
u.UserName,
u.UserPassword,
u.DefaultPage,
u.UserStatus,
u.Notifications,
w.WorkplaceId 
from dbo.DC_WORKPLACE w 
inner join dbo.DC_USER u on u.UserId=w.WorkplaceUserId 
where w.WorkplaceId=@WorkPlaceId 
END

