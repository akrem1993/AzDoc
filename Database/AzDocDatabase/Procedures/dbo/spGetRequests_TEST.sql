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
-- Author:  Musaeyev Nurlan
-- Create date: 21.02.2019
-- Description: Butun muracietleri getirmek ucun proesdur
-- =============================================
CREATE PROCEDURE [dbo].[spGetRequests_TEST]
@pageSize int=20,
@pageIndex int=1,
@totalCount int output
AS
SET NOCOUNT ON;
BEGIN 
select @totalCount= count(*) from DC_REQUEST_TEST;
 select r.RequestId ,
 r.RequestDate,
 CONCAT([dbo].[fnGetPersonnelbyWorkPlaceId](r.WorkPlaceId,106),' ',[dbo].[fnGetPersonPositionName](r.WorkPlaceId)) Person,
 r.RequestHeader ,
 t.RequestTypeName,
 s.RequestStatusName from DC_REQUEST_TEST r 
 join DC_REQUESTSTATUS s on r.RequestStatus=s.RequestStatusId
 join DC_REQUESTTYPE t on r.RequestType=t.RequestTypeId order by r.RequestId desc 
 OFFSET @pageSize * (@pageIndex-1) Rows FETCH NEXT @pageSize ROWS ONLY;

END

