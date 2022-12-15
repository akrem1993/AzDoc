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
-- Create date: 07.02.2019
-- Description: Sorgularin(Feedback) ve cavablarin icra olunmasi
-- =============================================
CREATE PROCEDURE [dbo].[spFeedBackRequest_TEST]
@requestId  int output,
@answerText nvarchar(max),
@requestText nvarchar(max),
@lastMessageId int output,
@workPlaceId int,
@requestType int
AS
declare 
@date datetime=dbo.sysdatetime(),@messageId int,@userIsHelper bit;
BEGIN
  if @requestId=0
  begin 
   Insert into DC_REQUEST_TEST(InsertDate,RequestDate,RequestHeader,RequestStatus,WorkPlaceId,RequestType)
   values (@date,@date,@requestText,3,@workPlaceId,@requestType)
   set @requestId=SCOPE_IDENTITY();

   Insert into DC_REQUESTANSWER_TEST(RequestId,MessageText,MessageDate,WorkPlaceId,IsSeen) 
   values (@requestId,@requestText,@date,@workPlaceId,0)
   set @lastMessageId=SCOPE_IDENTITY();
  end
  else
  begin
      Insert into DC_REQUESTANSWER_TEST(RequestId,MessageText,MessageDate,WorkPlaceId,IsSeen,AnswerMessageId)
   values (@requestId,@answerText,@date,@workPlaceId,0,@lastMessageId);
   select @lastMessageId=SCOPE_IDENTITY();

   select @userIsHelper=[dbo].[fnIsPersonnHelperByWorkPlace](@workPLaceId);
   Update DC_REQUEST_TEST set RequestStatus=CASE 
             when @userIsHelper=1 then 5 
             else 3 END
             where RequestId=@requestId; 
    

  end;  
    
END

