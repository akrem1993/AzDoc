/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spUserActionOperation]
@userId int,
@actionId int,
@result int output
as
begin
  set nocount on;
   
 IF EXISTS (SELECT * from dbo.DC_USER u WHERE u.UserId =@userId)
  BEGIN
        if(@actionId=1) --User Block
        begin
          update dbo.DC_USER set UserStatus=0 where UserId=@userId;
          set @result=1;
        end
        if(@actionId=2) --User UnBlock
        begin
          update dbo.DC_USER set UserStatus=1 where UserId=@userId;
          set @result=1;
        end
        if(@actionId=3) --User Reset
        begin
         declare @AlLChars varchar(20) = '0123456789'
         select @AlLChars=(SELECT RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1) +
                 RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1) +
                 RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1) + 
                 RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1) + 
                 RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1) +
     RIGHT( LEFT(@AlLChars,ABS(BINARY_CHECKSUM(NEWID())%10) + 1 ),1)) ;   
         
          insert dbo.DC_USER_RESET_CODE(UserId,ResetCode)
          values(@userId,(select @AlLChars));      
          set @result=1;
        end
  END
  ELSE
  BEGIN
    set @result=-1;
  END 
end

