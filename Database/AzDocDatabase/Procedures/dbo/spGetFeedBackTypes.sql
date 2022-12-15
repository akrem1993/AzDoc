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
-- Author:  Musayev Nurlan
-- Create date: 15.04.2019
-- Description: FeedBack muraciet formalari
-- =============================================
CREATE PROCEDURE [dbo].[spGetFeedBackTypes]
AS
BEGIN
 select r.RequestTypeId,r.RequestTypeName from DC_REQUESTTYPE r where r.RequestTypeStatus=1
END

