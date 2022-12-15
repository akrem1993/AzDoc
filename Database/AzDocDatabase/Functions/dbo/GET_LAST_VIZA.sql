create FUNCTION [dbo].[GET_LAST_VIZA] (@vizaId int,@fileId int,@workplaceId int) RETURNS INT
AS
BEGIN

DECLARE @count int = 0
DECLARE @confirmVizaId int = 0
 
SELECT @count = count(VizaId) from DOCS_VIZA WHERE VizaFileId=@fileId  and VizaWorkPlaceId=@workplaceId


IF @count = 1 RETURN @vizaId
ELSE IF @count = 0 RETURN 0;
ELSE
   BEGIN

   SELECT @count = count(VizaId) from DOCS_VIZA WHERE VizaFileId=@fileId  and VizaWorkPlaceId=@workplaceId and VizaConfirmed=0

   IF @count > 1 OR @count = 0
      BEGIN
        SELECT @confirmVizaId = MAX(VizaId) from DOCS_VIZA WHERE VizaFileId=@fileId  and VizaWorkPlaceId=@workplaceId and VizaAgreementTypeId=1
      END
   ELSE IF @count = 1
    BEGIN
      SELECT @confirmVizaId = MAX(VizaId) from DOCS_VIZA WHERE VizaFileId=@fileId  and VizaWorkPlaceId=@workplaceId and VizaAgreementTypeId=2
    END

   END

   RETURN @confirmVizaId

END

