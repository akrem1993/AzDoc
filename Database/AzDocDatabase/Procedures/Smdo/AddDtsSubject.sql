-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 21.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[AddDtsSubject]
@DocId int,
@subject nvarchar(max),
@serialNum nvarchar(max),
@ValidFrom datetime,
@ValidTo datetime
AS
BEGIN

 UPDATE smdo.ReceivedDocDetails
 SET
     smdo.ReceivedDocDetails.Subjects=@subject,
smdo.ReceivedDocDetails.SerialNumber=@serialNum,
smdo.ReceivedDocDetails.ValidFrom=@ValidFrom,
smdo.ReceivedDocDetails.ValidTo=@ValidTo
    WHERE DocId=@DocId

END

