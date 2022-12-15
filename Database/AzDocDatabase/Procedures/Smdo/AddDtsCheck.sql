-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 21.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[AddDtsCheck]
@DocId int,
@CheckName nvarchar(max),
@CheckStatus int,
@Indicator bit,
@CheckDescription nvarchar(max)
AS
BEGIN

IF EXISTS(SELECT dc.Id FROM smdo.DtsChecks dc WHERE dc.CheckName=@CheckName AND dc.DocId=@DocId)
BEGIN
 UPDATE smdo.DtsChecks
 SET
     CheckStatus = @CheckStatus, -- int
     Indicator = @Indicator, -- bit
     CheckDescription =@CheckDescription  -- nvarchar
    WHERE DocId=@DocId
 aND CheckName=@CheckName
END
ELSE
begin
INSERT smdo.DtsChecks
(
    --Id - column value is auto-generated
    DocId,
    CheckName,
    CheckStatus,
    Indicator,
    CheckDescription
)
VALUES
(
    @DocId,
    @CheckName,
    @CheckStatus,
    @Indicator,
    @CheckDescription
)
END

END

