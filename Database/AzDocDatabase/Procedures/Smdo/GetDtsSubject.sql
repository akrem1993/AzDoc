-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 21.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[GetDtsSubject]
@DocId int
AS
BEGIN

SELECT rdd.Id, 
       rdd.DocId, 
       rdd.SignP7S, 
       rdd.AttachName, 
       rdd.AttachPath, 
       rdd.AttachGuid, 
       rdd.DvcBase64, 
       rdd.Subjects AS subject, 
       rdd.SerialNumber AS serialNumber, 
       rdd.ValidFrom AS validFrom, 
       rdd.ValidTo AS validTo
FROM smdo.ReceivedDocDetails rdd
WHERE rdd.DocId = @DocId;

END

