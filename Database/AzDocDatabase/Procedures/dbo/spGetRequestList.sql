/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetRequestList]
as
set nocount on;
begin
 select 
 r.RequestId,
 rw.RequestAnswerText,
 rw.RequestAnswerDate,
 r.RequestText,
 r.RequestDate,
 rs.RequestStatusName,
 r.RequestStatusId,
 r.RequestTypeId,
 r.WorkPlaceId
 from
  [dbo].[DC_REQUEST] r full join [dbo].[DC_REQUESTANSWER] rw 
 on r.RequestId=rw.RequestId
 full join [dbo].[DC_REQUESTSTATUS] rs on r.RequestStatusId=rs.RequestStatusId
 where r.RequestId is not null
 
end;

