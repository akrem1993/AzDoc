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
-- Create date: 27.05.2019
-- Description: Senedin tipine gore qeydiyyat nezaret vereqesini getirir
-- =============================================
CREATE PROCEDURE [dbo].[GetDocView]
@docId int,
@workPlaceId int=null,
@docTypeId int OUTPUT,
@newPlanedHistory nvarchar(max)=null OUTPUT
AS
DECLARE
@currentDocId int;
BEGIN
 SET NOCOUNT ON;
    SELECT @currentDocId=d.DocId,@docTypeId=d.DocDoctypeId FROM dbo.DOCS d WHERE d.DocId=@docId AND d.DocDeleted in(0,2);    
    
IF @currentDocId IS NULL THROW 56000,'Sənəd tapılmadı',1;

IF @docTypeId=3--serencamverici senedler
BEGIN
    EXEC dms_insdoc.spGetDocView
                     @docId = @docId,
                     @docType = 3,
                     @workPlaceId = @workPlaceId;
RETURN;
end;

IF @docTypeId=2--vetendash muracietleri
BEGIN
   EXEC citizenrequests.spGetDocView
                         @docId = @docId,
                         @docType = 2,
                         @workPlaceId = 0,
						 @newPlanedHistory=@newPlanedHistory OUT
RETURN; 
end;

IF @docTypeId=1--teshkilat muracietleri
BEGIN
       EXEC orgrequests.spGetDocView
                         @docId = @docId,
                         @workPlaceId = 0,
						 @newPlanedHistory=@newPlanedHistory OUT
RETURN;
end;
IF @docTypeId=18--xidməti məktublar
BEGIN
       EXEC serviceletters.spGetDocView
                         @docId = @docId,
                         @workPlaceId = 0;
RETURN;
end;

IF @docTypeId=12--xaric olan senedler
BEGIN
       EXEC outgoingdoc.spGetDocView
                         @docId = @docId,
                          @docType=12,
                         @workPlaceId = 0;
RETURN;
end;
END

