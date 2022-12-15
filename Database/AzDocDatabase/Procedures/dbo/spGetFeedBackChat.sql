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
-- Create date: 05.02.2019
-- Description: FeedBack komek bolmesi ucun sorgularin idare olunmasi
-- =============================================
CREATE PROCEDURE [dbo].[spGetFeedBackChat] 
@requestId int,
@workPLaceId int
AS
set nocount on;
declare @userIsHelper bit,@requestUserWorkplace int;
BEGIN
 set @userIsHelper=[dbo].[fnIsPersonnHelperByWorkPlace](@workPLaceId);
 select @requestUserWorkplace=WorkPlaceId from DC_REQUEST_TEST where RequestId=@requestId;

 if @requestUserWorkplace=@workPLaceId or @userIsHelper=1
 begin
 Update DC_REQUESTANSWER_TEST set IsSeen=1 where RequestId=@requestId and WorkPlaceId<>@workPLaceId;
 end;
 

 select 
 t.RequestId,
 t.RequestDate,
 t.RequestStatus,
 t.WorkPlaceId,
 @userIsHelper as UserIsHelper,
 (select MAX(MessageId) from DC_REQUESTANSWER_TEST where RequestId=t.RequestId) as LastMessageId,
 (select 
 r.MessageId,
 r.RequestId,
 r.MessageText,
    [dbo].[fnGetPersonnelbyWorkPlaceId](r.WorkPlaceId,106) as PersonName,
 r.WorkPlaceId,
 r.MessageDate,
 r.IsSeen,
 [dbo].[fnIsPersonnHelperByWorkPlace](r.WorkPlaceId) as IsOperator,
 (select fi.FileInfoId as FileId,f.MessageId,fi.FileInfoName,f.Type,f.InsertDate,f.Status from DC_REQUESTFILES_TEST f join DOCS_FILEINFO fi on fi.FileInfoId=f.FileId where f.MessageId=r.MessageId for json path) as MessageFiles 
 from DC_REQUESTANSWER_TEST r where r.RequestId=t.RequestId order by r.MessageId for json auto) as Messages from DC_REQUEST_TEST t where t.RequestId=@requestId for json auto
 
END

